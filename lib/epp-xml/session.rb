require 'client_transaction_id'

class EppXml
  class Session
    include ClientTransactionId

    def login(xml_params = {})
      defaults = {
        clID: { value: 'user' },
        pw: { value: 'pw' },
        newPW: nil,
        options: {
          version: { value: '1.0' },
          lang: { value: 'en' }
        },
        svcs: {
          _objURIs: [
            { objURI: { value: 'https://epp.tld.ee/schema/domain-eis-1.0.xsd' } },
            { objURI: { value: 'https://epp.tld.ee/schema/contact-ee-1.1.xsd' } },
            { objURI: { value: 'urn:ietf:params:xml:ns:host-1.0' } },
            { objURI: { value: 'urn:ietf:params:xml:ns:keyrelay-1.0' } }
          ],
          svcExtension: [
            { extURI: { value: 'urn:ietf:params:xml:ns:secDNS-1.1' } },
            { extURI: { value: 'https://epp.tld.ee/schema/eis-1.0.xsd' } }
          ]
        }
      }

      xml_params = defaults.deep_merge(xml_params)

      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp(
        'xmlns' => 'https://epp.tld.ee/schema/epp-ee-1.0.xsd'
      ) do
        xml.command do
          xml.login do
            EppXml.generate_xml_from_hash(xml_params, xml)
          end
          xml.clTRID(clTRID) if clTRID
        end
      end
    end

    def logout
      xml = Builder::XmlMarkup.new
      xml.instruct!(:xml, standalone: 'no')
      xml.epp(
        'xmlns' => 'https://epp.tld.ee/schema/epp-ee-1.0.xsd'
      ) do
        xml.command do
          xml.logout
          xml.clTRID(clTRID) if clTRID
        end
      end
    end

    def poll(xml_params = {}, custom_params = {})
      defaults = {
        poll: { value: '', attrs: { op: 'req' } }
      }

      xml_params = defaults.deep_merge(xml_params)

      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => 'https://epp.tld.ee/schema/epp-ee-1.0.xsd') do
        xml.command do
          EppXml.generate_xml_from_hash(xml_params, xml)

          EppXml.custom_ext(xml, custom_params)
          xml.clTRID(clTRID) if clTRID
        end
      end
    end
  end
end
