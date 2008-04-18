class QbwcApi < ActionWebService::API::Base
  inflect_names false

  # --- [ QBWC server version control ] ---
  # Expects:
  #   * string ticket  = A GUID based ticket string to maintain identity of QBWebConnector 
  # Returns string: 
  #   * Return a string describing the server version and any other information that you want your user to see.
  api_method :serverVersion, 
             :expects => [{:ticket => :string}], 
             :returns => [:string]
             
  # --- [ QBWC version control ] ---
  # Expects:
  #   * string strVersion = QBWC version number
  # Returns string: 
  #   * NULL or <emptyString> = QBWC will let the web service update
  #   * "E:<any text>" = popup ERROR dialog with <any text>, abort update and force download of new QBWC.
  #   * "W:<any text>" = popup WARNING dialog with <any text>, and give user choice to update or not.
  api_method :clientVersion, 
             :expects => [{:strVersion => :string}], 
             :returns => [[:string]]
               
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
  api_method :authenticate,
             :expects => [{:strUserName => :string}, {:strPassword => :string}], 
             :returns => [[:string]]
  
  # --- [ To facilitate capturing of QuickBooks error and notifying it to web services ] ---
  # Expects: 
  #   * string ticket  = A GUID based ticket string to maintain identity of QBWebConnector 
  #   * string hresult = An HRESULT value thrown by QuickBooks when trying to make connection
  #   * string message = An error message corresponding to the HRESULT
  # Returns string:
  #   * "done" = no further action required from QBWebConnector
  #   * any other string value = use this name for company file
  api_method :connectionError,
             :expects => [{:ticket => :string}, {:hresult => :string}, {:message => :string}],
             :returns => [:string]

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
  api_method :sendRequestXML, 
             :expects => [{:ticket => :string}, {:strHCPResponse => :string}, 
                          {:strCompanyFileName => :string}, {:Country => :string}, 
                          {:qbXMLMajorVers => :int}, {:qbXMLMinorVers => :int}],
             :returns => [:string]

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
  api_method :receiveResponseXML, 
             :expects => [{:ticket => :string}, {:response => :string}, 
                          {:hresult => :string}, {:message => :string}],
             :returns => [:int]

  # --- [ Facilitates QBWC to receive last web service error ] ---
  # Expects:
  #   * string ticket
  # Returns string:
  #   * error message describing last web service error
  api_method :getLastError,
             :expects => [{:ticket => :string}],
             :returns => [:string]

  # --- [ QBWC will call this method at the end of a successful update session ] ---
  # Expects:
  #   * string ticket 
  # Returns string:
  #   * closeConnection result. Ex: "OK"
  api_method :closeConnection,
             :expects => [{:ticket => :string}],
             :returns => [:string]

end