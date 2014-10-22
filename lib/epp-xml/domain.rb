module Domain
  def create(xml_params = {}, dnssec_params = {})
    defaults = {
      name: { value: 'example.ee' },
      period: { value: '1', attrs: { unit: 'y' } },
      ns: [
        { hostObj: { value: 'ns1.example.net' } },
        { hostObj: { value: 'ns2.example.net' } }
      ],
      registrant: { value: 'jd1234' },
      _other: [
        { contact: { value: 'sh8013', attrs: { type: 'admin' } } },
        { contact: { value: 'sh8013', attrs: { type: 'tech' } } },
        { contact: { value: 'sh801333', attrs: { type: 'tech' } } }
      ]
    }

    xml_params = defaults.deep_merge(xml_params)

    dsnsec_defaults = {
      _other: [
        {  keyData: {
          flags: { value: '257' },
          protocol: { value: '3' },
          alg: { value: '5' },
          pubKey: { value: 'AwEAAddt2AkLfYGKgiEZB5SmIF8EvrjxNMH6HtxWEA4RJ9Ao6LCWheg8' }
        }
      }]
    }

    dnssec_params = dsnsec_defaults.deep_merge(dnssec_params) if dnssec_params != false

    xml = Builder::XmlMarkup.new

    xml.instruct!(:xml, standalone: 'no')
    xml.epp('xmlns' => 'urn:ietf:params:xml:ns:epp-1.0') do
      xml.command do
        xml.create do
          xml.tag!('domain:create', 'xmlns:domain' => 'urn:ietf:params:xml:ns:domain-1.0') do
            EppXml.generate_xml_from_hash(xml_params, xml, 'domain:')
          end
        end
        xml.extension do
          xml.tag!('secDNS:create', 'xmlns:secDNS' => 'urn:ietf:params:xml:ns:secDNS-1.1') do
            EppXml.generate_xml_from_hash(dnssec_params, xml, 'secDNS:')
          end
        end if dnssec_params != false
        xml.clTRID 'ABC-12345'
      end
    end
  end
end
