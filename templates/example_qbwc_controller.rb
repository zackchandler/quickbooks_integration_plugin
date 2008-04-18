# This controller implements the seven web callback methods for QBWC
# Check qbwc_api.rb file for descriptions of parameters and return values
class QbwcController < ApplicationController
  before_filter :set_soap_header

  # --- [ QBWC server version control ] ---
  # Expects:
  #   * string ticket  = A GUID based ticket string to maintain identity of QBWebConnector 
  # Returns string: 
  #   * Return a string describing the server version and any other information that you want your user to see.
  def serverVersion(ticket)
    'Describe your app version here...'
  end

  # --- [ QBWC version control ] ---
  # Expects:
  #   * string strVersion = QBWC version number
  # Returns string: 
  #   * NULL or <emptyString> = QBWC will let the web service update
  #   * "E:<any text>" = popup ERROR dialog with <any text>, abort update and force download of new QBWC.
  #   * "W:<any text>" = popup WARNING dialog with <any text>, and give user choice to update or not.  
  def clientVersion(version)
    nil # support any version
  end

  # --- [ Authenticate web connector ] ---
  # Expects: 
  #   * string strUserName = username from QWC file
  #   * string strPassword = password
  # Returns string[2]: 
  #   * string[0] = ticket (guid)
  #   * string[1] =
  #       - empty string = use current company file
  #       - "none" = no further request/no further action required
  #       - "nvu" = not valid user
  #       - any other string value = use this company file             
  def authenticate(username, password)
    [ 'ABC123', '' ]
  end

  # --- [ To facilitate capturing of QuickBooks error and notifying it to web services ] ---
  # Expects: 
  #   * string ticket  = A GUID based ticket string to maintain identity of QBWebConnector 
  #   * string hresult = An HRESULT value thrown by QuickBooks when trying to make connection
  #   * string message = An error message corresponding to the HRESULT
  # Returns string:
  #   * "done" = no further action required from QBWebConnector
  #   * any other string value = use this name for company file
  def connectionError(ticket, hresult, message)
    'done'
  end

  # --- [ Facilitates web service to send request XML to QuickBooks via QBWC ] ---
  # Expects:
  #   * int qbXMLMajorVers
  #   * int qbXMLMinorVers
  #   * string ticket
  #   * string strHCPResponse 
  #   * string strCompanyFileName 
  #   * string Country
  #   * int qbXMLMajorVers
  #   * int qbXMLMinorVers
  # Returns string:
  #   * "any_string" = Request XML for QBWebConnector to process
  #   * "" = No more request XML
  def sendRequestXML(ticket, hpc_response, company_file_name, country, qbxml_major_version, qbxml_minor_version)
    # Sample qbxml request to query customers and only return 'Name' attribute
    xml = <<-REQUEST
    <CustomerQueryRq requestID="1">
      <IncludeRetElement>Name</IncludeRetElement>
    </CustomerQueryRq>
    REQUEST
    wrap_qbxml_request(xml)
  end

  # --- [ Facilitates web service to receive response XML from QuickBooks via QBWC ] ---
  # Expects:
  #   * string ticket
  #   * string response
  #   * string hresult
  #   * string message
  # Returns int:
  #   * Greater than zero  = There are more request to send
  #   * 100 = Done. no more request to send
  #   * Less than zero  = Custom Error codes
  def receiveResponseXML(ticket, response, hresult, message)
    # Simply prints QuickBooks customers to log file
    xml = XmlSimple.xml_in(response, { 'ForceArray' => false })
    logger.info "QuickBooks has the following customers:"
    xml['QBXMLMsgsRs']['CustomerQueryRs']['CustomerRet'].each do |customer|
      logger.info customer['Name']
    end
    100 # Signal done - no more requests are needed.
  end

  # --- [ Facilitates QBWC to receive last web service error ] ---
  # Expects:
  #   * string ticket
  # Returns string:
  #   * error message describing last web service error
  def getLastError(ticket)
    'An error occurred'
  end

  # --- [ QBWC will call this method at the end of a successful update session ] ---
  # Expects:
  #   * string ticket 
  # Returns string:
  #   * closeConnection result. Ex: "OK"
  def closeConnection(ticket)
    'OK'
  end
  
  private
    
    # The W3C SOAP docs state (http://www.w3.org/TR/2000/NOTE-SOAP-20000508/#_Toc478383528):
    #   "The SOAPAction HTTP request header field can be used to indicate the intent of
    #    the SOAP HTTP request. The value is a URI identifying the intent. SOAP places
    #    no restrictions on the format or specificity of the URI or that it is resolvable.
    #    An HTTP client MUST use this header field when issuing a SOAP HTTP Request."
    # Unfortunately the QBWC does not set this header and ActionWebService needs 
    # HTTP_SOAPACTION set correctly in order to route the incoming SOAP request.
    # So we set the header in this before filter.
    def set_soap_header
      if request.env['HTTP_SOAPACTION'].blank? || request.env['HTTP_SOAPACTION'] == %Q("")
        xml = REXML::Document.new(request.raw_post)
        element = REXML::XPath.first(xml, '/soap:Envelope/soap:Body/*')
        request.env['HTTP_SOAPACTION'] = element.name if element
      end
    end

    # Simple wrapping helper
    def wrap_qbxml_request(body)
      r_start = <<-XML
<?xml version="1.0" ?>
<?qbxml version="5.0" ?>
<QBXML>
  <QBXMLMsgsRq onError="continueOnError">
XML
      r_end = <<-XML
  </QBXMLMsgsRq>
</QBXML>
XML
      r_start + body + r_end
    end
    
end