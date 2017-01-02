require 'spec_helper'

describe EppXml::Contact do
  let(:epp_xml) { EppXml.new(cl_trid: 'ABC-12345')}

  it 'generates valid check xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <check>
            <contact:check
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd" />
          </check>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.contact.check).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <check>
            <contact:check
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd">
              <contact:id>sh8013</contact:id>
              <contact:id>sah8013</contact:id>
              <contact:id>8013sah</contact:id>
            </contact:check>
          </check>

          <extension>
            <eis:extdata xmlns:eis="https://epp.tld.ee/schema/eis-1.0.xsd">
              <eis:legalDocument type="ddoc">base64</eis:legalDocument>
            </eis:extdata>
          </extension>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.contact.check({
      _anonymus: [
        { id: { value: 'sh8013' } },
        { id: { value: 'sah8013' } },
        { id: { value: '8013sah' } }
      ]
    }, {
      _anonymus: [
        legalDocument: { value: 'base64', attrs: { type: 'ddoc' } }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid check xml without clTRID' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <check>
            <contact:check
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd" />
          </check>
        </command>
      </epp>
    ').to_s.squish

    ex = EppXml.new(cl_trid: false)
    generated = Nokogiri::XML(ex.contact.check).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid info xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <info>
            <contact:info
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd" />
          </info>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.contact.info).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <info>
            <contact:info
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd">
              <contact:id>sh8013</contact:id>
              <contact:authInfo>
                <contact:pw>2fooBAR</contact:pw>
              </contact:authInfo>
            </contact:info>
          </info>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.contact.info({
      id: { value: 'sh8013' },
      authInfo: {
        pw: { value: '2fooBAR' }
      }
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid transfer xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <transfer op="query">
            <contact:transfer
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd" />
          </transfer>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.contact.transfer).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <transfer op="query">
            <contact:transfer
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd">
              <contact:id>sh8013</contact:id>
              <contact:authInfo>
                <contact:pw>2fooBAR</contact:pw>
              </contact:authInfo>
            </contact:transfer>
          </transfer>

          <extension>
            <eis:extdata xmlns:eis="https://epp.tld.ee/schema/eis-1.0.xsd">
              <eis:legalDocument type="ddoc">base64</eis:legalDocument>
            </eis:extdata>
          </extension>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.contact.transfer({
      id: { value: 'sh8013' },
      authInfo: {
        pw: { value: '2fooBAR' }
      }
    }, 'query', {
      _anonymus: [
        legalDocument: { value: 'base64', attrs: { type: 'ddoc' } }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid create xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <create>
            <contact:create
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd" />
          </create>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.contact.create).to_s.squish
    expect(generated).to eq(expected)

    ###

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <create>
            <contact:create
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd">
              <contact:id>sh8013</contact:id>
              <contact:postalInfo type="int">
                <contact:name>John Doe</contact:name>
                <contact:org>Example Inc.</contact:org>
                <contact:addr>
                  <contact:street>123 Example Dr.</contact:street>
                  <contact:street>Suite 100</contact:street>
                  <contact:city>Dulles</contact:city>
                  <contact:sp>VA</contact:sp>
                  <contact:pc>20166-6503</contact:pc>
                  <contact:cc>US</contact:cc>
                </contact:addr>
              </contact:postalInfo>
              <contact:voice x="1234">+1.7035555555</contact:voice>
              <contact:fax>+1.7035555556</contact:fax>
              <contact:email>jdoe@example.com</contact:email>
              <contact:authInfo>
                <contact:pw>2fooBAR</contact:pw>
              </contact:authInfo>
              <contact:disclose flag="0">
                <contact:voice/>
                <contact:email/>
              </contact:disclose>
            </contact:create>
          </create>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.contact.create({
      id: { value: 'sh8013' },
      postalInfo: { value: {
        name: { value: 'John Doe' },
        org: { value: 'Example Inc.' },
        addr: [
          { street: { value: '123 Example Dr.' } },
          { street: { value: 'Suite 100' } },
          { city: { value: 'Dulles' } },
          { sp: { value: 'VA' } },
          { pc: { value: '20166-6503' } },
          { cc: { value: 'US' } }
        ]
      }, attrs: { type: 'int' } },
      voice: { value: '+1.7035555555', attrs: { x: '1234' } },
      fax: { value: '+1.7035555556' },
      email: { value: 'jdoe@example.com' },
      authInfo: {
        pw: { value: '2fooBAR' }
      },
      disclose: { value: {
        voice: { value: '' },
        email: { value: '' }
      }, attrs: { flag: '0' } }
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid delete xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <delete>
            <contact:delete
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd" />
          </delete>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.contact.delete).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <delete>
            <contact:delete
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd">
              <contact:id>sh8013</contact:id>
            </contact:delete>
          </delete>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.contact.delete({
      id: { value: 'sh8013' }
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid update xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <update>
            <contact:update
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd" />
          </update>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.contact.update).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
        <command>
          <update>
            <contact:update
             xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd">
              <contact:id>sh8013</contact:id>
              <contact:add>
                <contact:status s="clientDeleteProhibited"/>
              </contact:add>
              <contact:chg>
                <contact:postalInfo type="int">
                  <contact:org/>
                  <contact:addr>
                    <contact:street>124 Example Dr.</contact:street>
                    <contact:street>Suite 200</contact:street>
                    <contact:city>Dulles</contact:city>
                    <contact:sp>VA</contact:sp>
                    <contact:pc>20166-6503</contact:pc>
                    <contact:cc>US</contact:cc>
                  </contact:addr>
                </contact:postalInfo>
                <contact:voice>+1.7034444444</contact:voice>
                <contact:fax/>
                <contact:authInfo>
                  <contact:pw>2fooBAR</contact:pw>
                </contact:authInfo>
                <contact:disclose flag="1">
                  <contact:voice/>
                  <contact:email/>
                </contact:disclose>
              </contact:chg>
            </contact:update>
          </update>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.contact.update({
      id: { value: 'sh8013' },
      add: [
        { status: { value: '', attrs: { s: 'clientDeleteProhibited' } } }
      ],
      chg: [
        {
          postalInfo: { value: {
            org: { value: '' },
            addr: [
              { street: { value: '124 Example Dr.' } },
              { street: { value: 'Suite 200' } },
              { city: { value: 'Dulles' } },
              { sp: { value: 'VA' } },
              { pc: { value: '20166-6503' } },
              { cc: { value: 'US' } }
            ]
          }, attrs: { type: 'int' } }
        },
        { voice: { value: '+1.7034444444' } },
        { fax: { value: ''} },
        { authInfo: { pw: { value: '2fooBAR' } } },
        {
          disclose: { value: {
            voice: { value: '' },
            email: { value: '' }
          }, attrs: { flag: '1' } }
        }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end
end
