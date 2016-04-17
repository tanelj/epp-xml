require 'client_transaction_id'

class EppXml
  class Domain
    include ClientTransactionId

    @xmlns = 'urn:ietf:params:xml:ns:epp-1.0'

    @xmlns_domain = 'https://epp.tld.ee/schema/domain-eis-1.0.xsd'

    @xmlns_secDNS = 'urn:ietf:params:xml:ns:secDNS-1.1'

    @xmlns_eis = 'https://epp.tld.ee/schema/eis-1.0.xsd'

    @clTRID = clTRID

    def info(xml_params = {}, custom_params = {})
      build('info', xml_params, custom_params)
    end

    def check(xml_params = {}, custom_params = {})
      build('check', xml_params, custom_params)
    end

    def delete(xml_params = {}, custom_params = {}, verified = false)
      build('delete', xml_params, custom_params, verified)
    end

    def renew(xml_params = {}, custom_params = {})
      build('renew', xml_params, custom_params)
    end

    def create(xml_params = {}, dnssec_params = {}, custom_params = {})
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => @xmlns) do
        xml.command do
          xml.create do
            xml.tag!('domain:create', 'xmlns:domain' => @xmlns_domain) do
              EppXml.generate_xml_from_hash(xml_params, xml, 'domain:')
            end
          end

          xml.extension do
            xml.tag!('secDNS:create', 'xmlns:secDNS' => @xmlns_secDNS) do
              EppXml.generate_xml_from_hash(dnssec_params, xml, 'secDNS:')
            end if dnssec_params.any?

            xml.tag!('eis:extdata',
              'xmlns:eis' => @xmlns_eis) do
              EppXml.generate_xml_from_hash(custom_params, xml, 'eis:')
            end if custom_params.any?
          end if dnssec_params.any? || custom_params.any?

          xml.clTRID(@clTRID) if @clTRID
        end
      end
    end

    def update(xml_params = {}, dnssec_params = {}, custom_params = {})
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => @xmlns) do
        xml.command do
          xml.update do
            xml.tag!('domain:update', 'xmlns:domain' => @xmlns_domain) do
              EppXml.generate_xml_from_hash(xml_params, xml, 'domain:')
            end
          end

          xml.extension do
            xml.tag!('secDNS:update', 'xmlns:secDNS' => @xmlns_secDNS) do
              EppXml.generate_xml_from_hash(dnssec_params, xml, 'secDNS:')
            end

            xml.tag!('eis:extdata',
              'xmlns:eis' => @xmlns_eis) do
              EppXml.generate_xml_from_hash(custom_params, xml, 'eis:')
            end if custom_params.any?
          end if dnssec_params.any? || custom_params.any?

          xml.clTRID(@clTRID) if @clTRID
        end
      end
    end

    def transfer(xml_params = {}, op = 'query', custom_params = {})
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => @xmlns) do
        xml.command do
          xml.transfer('op' => op) do
            xml.tag!('domain:transfer', 'xmlns:domain' => @xmlns_domain) do
              EppXml.generate_xml_from_hash(xml_params, xml, 'domain:')
            end
          end

          EppXml.custom_ext(xml, custom_params)
          xml.clTRID(@clTRID) if @clTRID
        end
      end
    end

    private

    def build(command, xml_params, custom_params, verified = false)
      xml = Builder::XmlMarkup.new

      verified_option = {'verified' => verified} if verified && nil

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => @xmlns) do
        xml.command do
          xml.tag!(command) do
            xml.tag!("domain:#{command}", [{'xmlns:domain' => @xmlns_domain}].push(verified_option)) do
              EppXml.generate_xml_from_hash(xml_params, xml, 'domain:')
            end
          end

          EppXml.custom_ext(xml, custom_params)
          xml.clTRID(@clTRID) if @clTRID
        end
      end
    end
  end
end
