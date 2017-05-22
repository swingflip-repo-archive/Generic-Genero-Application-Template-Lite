#-------------------------------------------------------------------------------
# File: imageWS_imageWSPort.4gl
# GENERATED BY fglwsdl 1462804122
#-------------------------------------------------------------------------------
# THIS FILE WAS GENERATED. DO NOT MODIFY.
#-------------------------------------------------------------------------------


IMPORT FGL WSHelper
IMPORT com
IMPORT xml


GLOBALS "imageWS_imageWSPort.inc"



#-------------------------------------------------------------------------------
# Service: imageWS
# Port:    imageWSPort
# Server:  http://ryanhamlin.co.uk/ws/ws.php
#-------------------------------------------------------------------------------

PRIVATE DEFINE ws_funcs_check_serviceHTTPReq     com.HTTPRequest
PRIVATE DEFINE ws_funcs_check_serviceHTTPResp    com.HTTPResponse

PRIVATE DEFINE ws_funcs_process_imageHTTPReq     com.HTTPRequest
PRIVATE DEFINE ws_funcs_process_imageHTTPResp    com.HTTPResponse

#-------------------------------------------------------------------------------

#
# Operation: ws_funcs.check_service
#

#
# FUNCTION: ws_funcs_check_service
#
FUNCTION ws_funcs_check_service(p_client_key)
  DEFINE	p_client_key		STRING
  DEFINE	soapStatus		INTEGER


  LET ws_funcs_check_serviceRequest.client_key = p_client_key

  LET soapStatus = ws_funcs_check_service_g()

  RETURN soapStatus, ws_funcs_check_serviceResponse.return
END FUNCTION

#
# FUNCTION: ws_funcs_check_service_g
#   RETURNING: soapStatus
#   INPUT: GLOBAL ws_funcs_check_serviceRequest
#   OUTPUT: GLOBAL ws_funcs_check_serviceResponse
#
FUNCTION ws_funcs_check_service_g()
  DEFINE wsstatus   INTEGER
  DEFINE retryAuth  INTEGER
  DEFINE retryProxy INTEGER
  DEFINE retry      INTEGER
  DEFINE nb         INTEGER
  DEFINE uri        STRING
  DEFINE setcookie  STRING
  DEFINE mustUnderstand INTEGER
  DEFINE request    com.HTTPRequest
  DEFINE response   com.HTTPResponse
  DEFINE writer     xml.DomDocument
  DEFINE reader     xml.DomDocument
  DEFINE envelope   xml.DomNode
  DEFINE header     xml.DomNode
  DEFINE body       xml.DomNode
  DEFINE node       xml.DomNode

  #
  # INIT VARIABLES
  #
  LET wsstatus = -1
  LET retryAuth = FALSE
  LET retryProxy = FALSE
  LET retry = TRUE
  LET uri = com.WebServiceEngine.GetOption("SoapModuleURI")

  IF imageWS_imageWSPortEndpoint.Address.Uri IS NULL THEN
    LET imageWS_imageWSPortEndpoint.Address.Uri = "http://ryanhamlin.co.uk/ws/ws.php"
  END IF

  #
  # CREATE REQUEST
  #
  TRY
    LET request = com.HTTPRequest.Create(imageWS_imageWSPortEndpoint.Address.Uri)
    CALL request.setMethod("POST")
    CALL request.setCharset("UTF-8")
    CALL request.setHeader("SOAPAction","\"http://www.ryanhamlin.co.uk/ws/imageWS#check_service\"")
    CALL WSHelper_SetRequestHeaders(request, imageWS_imageWSPortEndpoint.Binding.Request.Headers)
    IF imageWS_imageWSPortEndpoint.Binding.Version IS NOT NULL THEN
      CALL request.setVersion(imageWS_imageWSPortEndpoint.Binding.Version)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.Cookie IS NOT NULL THEN
      CALL request.setHeader("Cookie",imageWS_imageWSPortEndpoint.Binding.Cookie)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.ConnectionTimeout <> 0 THEN
      CALL request.setConnectionTimeout(imageWS_imageWSPortEndpoint.Binding.ConnectionTimeout)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.ReadWriteTimeout <> 0 THEN
      CALL request.setTimeout(imageWS_imageWSPortEndpoint.Binding.ReadWriteTimeout)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.CompressRequest IS NOT NULL THEN
      CALL request.setHeader("Content-Encoding",imageWS_imageWSPortEndpoint.Binding.CompressRequest)
    END IF
    CALL request.setHeader("Accept-Encoding","gzip, deflate")
  CATCH
    LET wsstatus = STATUS
    CALL WSHelper_FillSOAP11WSError("Client","Cannot create HTTPRequest")
    RETURN wsstatus    
  END TRY

  # START LOOP
  WHILE retry
    LET retry = FALSE

    #
    # DOM Request
    #

    TRY
      # Building SOAP1.1 envelope
      LET writer = xml.DomDocument.Create()
      LET envelope = WSHelper_BuildSOAP11Envelope(writer)
      CALL writer.appendDocumentNode(envelope)
      LET body = WSHelper_BuildSOAP11Body(writer)
      CALL envelope.appendChild(body)
      #
      # DOM SOAP REQUEST SERIALIZE
      #
      CALL xml.Serializer.VariableToSoapSection5(ws_funcs_check_serviceRequest,body)

      # Send SOAP envelope
      CALL request.doXmlRequest(writer)
    CATCH
      LET wsstatus = STATUS
      CALL WSHelper_FillSOAP11WSError("Client",SQLCA.SQLERRM)
      RETURN wsstatus    
    END TRY

    #
    # PROCESS RESPONSE
    #
    TRY
      LET response = request.getResponse()

      #
      # RETRIEVE SERVICE SESSION COOKIE
      #
      LET setcookie = response.getHeader("Set-Cookie")
      IF setcookie IS NOT NULL THEN
        LET imageWS_imageWSPortEndpoint.Binding.Cookie = WSHelper_ExtractServerCookie(setcookie,imageWS_imageWSPortEndpoint.Address.Uri)
      END IF

      #
      # RETRIEVE HTTP RESPONSE Headers
      #
      CALL WSHelper_SetResponseHeaders(response, imageWS_imageWSPortEndpoint.Binding.Response.Headers)
      CASE response.getStatusCode()

        WHEN 500 # SOAP Fault
          #
          # DOM SOAP FAULT
          #
          LET reader = response.getXmlResponse()
          LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
          IF envelope IS NULL THEN
            EXIT CASE
          END IF
          LET header = WSHelper_CheckSOAP11Header(envelope)
          LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
          IF body IS NULL THEN
            EXIT CASE
          END IF
          # Handle SOAP headers
          IF header IS NOT NULL THEN
            LET node = header.getFirstChildElement()
            WHILE (node IS NOT NULL)
              IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                IF mustUnderstand = -1 THEN
                  CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                  EXIT CASE
                END IF
                IF mustUnderstand THEN
                  CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                  EXIT CASE
                ELSE
                  LET node = node.getNextSiblingElement() # Skip header, not mandatory
                END IF
              ELSE
                LET node = node.getNextSiblingElement() # Skip header, not intended to us
              END IF
            END WHILE
          END IF
          CALL WSHelper_CheckSOAP11Fault(body.getFirstChildElement())

        WHEN 200 # SOAP Result
          #
          # DOM SOAP RESPONSE
          #
          LET reader = response.getXmlResponse()
          LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
          IF envelope IS NULL THEN
            EXIT CASE
          END IF
          LET header = WSHelper_RetrieveSOAP11Header(envelope)
          # Retrieve body
          LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
          # Handle SOAP headers
          IF header IS NOT NULL THEN
            LET node = header.getFirstChildElement()
            LET nb = 0
            WHILE (node IS NOT NULL)
              IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                IF mustUnderstand = -1 THEN
                  CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                  EXIT CASE
                END IF
                #
                # DOM SOAP RESPONSE HEADER DESERIALIZE
                #
                IF mustUnderstand THEN
                  CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                  EXIT CASE
                ELSE
                  LET node = node.getNextSiblingElement() # Skip header, not mandatory
                END IF
              ELSE
                LET node = node.getNextSiblingElement() # Skip header, not intended to us
              END IF
            END WHILE
            IF nb != 0 THEN
              CALL WSHelper_FillSOAP11WSError("Client","One or more headers are missing")
              EXIT CASE
            END IF
          END IF
          IF body IS NOT NULL THEN
            # Check message
            LET node = WSHelper_RetrieveSOAP11Message(body)
            IF node IS NOT NULL THEN
              #
              # DOM SOAP RESPONSE DESERIALIZE
              #
              CALL Xml.Serializer.SoapSection5ToVariable(node,ws_funcs_check_serviceResponse)
              LET wsstatus = 0
            END IF
          END IF

        WHEN 401 # HTTP Authentication
          IF retryAuth THEN
            CALL WSHelper_FillSOAP11WSError("Server","HTTP Error 401 ("||response.getStatusDescription()||")")
          ELSE
            LET retryAuth = TRUE
            LET retry = TRUE
          END IF

        WHEN 407 # Proxy Authentication
          IF retryProxy THEN
            CALL WSHelper_FillSOAP11WSError("Server","HTTP Error 407 ("||response.getStatusDescription()||")")
          ELSE
            LET retryProxy = TRUE
            LET retry = TRUE
          END IF

        OTHERWISE
          CALL WSHelper_FillSOAP11WSError("Server","HTTP Error "||response.getStatusCode()||" ("||response.getStatusDescription()||")")

      END CASE
    CATCH
      LET wsstatus = status
      CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
      RETURN wsstatus    
    END TRY

  # END LOOP
  END WHILE

  RETURN wsstatus

END FUNCTION


FUNCTION ws_funcs_check_serviceRequest_g()
  DEFINE wsstatus   INTEGER
  DEFINE nb         INTEGER
  DEFINE writer     xml.DomDocument
  DEFINE envelope   xml.DomNode
  DEFINE header     xml.DomNode
  DEFINE body       xml.DomNode
  DEFINE node       xml.DomNode

  #
  # CHECK PREVIOUS CALL  
  #
  IF ws_funcs_check_serviceHTTPReq IS NOT NULL AND ws_funcs_check_serviceHTTPResp IS NULL THEN
    # Request was sent but there was no response yet
    CALL WSHelper_FillSOAP11WSError("Client","Cannot issue a new request until previous response was received")
    RETURN -2 # waiting for the response
  ELSE
    IF imageWS_imageWSPortEndpoint.Address.Uri IS NULL THEN
      LET imageWS_imageWSPortEndpoint.Address.Uri = "http://ryanhamlin.co.uk/ws/ws.php"
    END IF
  END IF

  #
  # CREATE REQUEST
  #
  TRY
    LET ws_funcs_check_serviceHTTPReq = com.HTTPRequest.Create(imageWS_imageWSPortEndpoint.Address.Uri)
    CALL ws_funcs_check_serviceHTTPReq.setMethod("POST")
    CALL ws_funcs_check_serviceHTTPReq.setCharset("UTF-8")
    CALL ws_funcs_check_serviceHTTPReq.setHeader("SOAPAction","\"http://www.ryanhamlin.co.uk/ws/imageWS#check_service\"")
    CALL WSHelper_SetRequestHeaders(ws_funcs_check_serviceHTTPReq, imageWS_imageWSPortEndpoint.Binding.Request.Headers)
    IF imageWS_imageWSPortEndpoint.Binding.Version IS NOT NULL THEN
      CALL ws_funcs_check_serviceHTTPReq.setVersion(imageWS_imageWSPortEndpoint.Binding.Version)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.Cookie IS NOT NULL THEN
      CALL ws_funcs_check_serviceHTTPReq.setHeader("Cookie",imageWS_imageWSPortEndpoint.Binding.Cookie)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.ConnectionTimeout <> 0 THEN
      CALL ws_funcs_check_serviceHTTPReq.setConnectionTimeout(imageWS_imageWSPortEndpoint.Binding.ConnectionTimeout)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.ReadWriteTimeout <> 0 THEN
      CALL ws_funcs_check_serviceHTTPReq.setTimeout(imageWS_imageWSPortEndpoint.Binding.ReadWriteTimeout)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.CompressRequest IS NOT NULL THEN
      CALL ws_funcs_check_serviceHTTPReq.setHeader("Content-Encoding",imageWS_imageWSPortEndpoint.Binding.CompressRequest)
    END IF
    CALL ws_funcs_check_serviceHTTPReq.setHeader("Accept-Encoding","gzip, deflate")
  CATCH
    LET wsstatus = STATUS
    CALL WSHelper_FillSOAP11WSError("Client","Cannot create HTTPRequest")
    LET ws_funcs_check_serviceHTTPReq = NULL
    RETURN wsstatus    
  END TRY

    #
    # DOM Request
    #

    TRY
      # Building SOAP1.1 envelope
      LET writer = xml.DomDocument.Create()
      LET envelope = WSHelper_BuildSOAP11Envelope(writer)
      CALL writer.appendDocumentNode(envelope)
      LET body = WSHelper_BuildSOAP11Body(writer)
      CALL envelope.appendChild(body)
      #
      # DOM SOAP REQUEST SERIALIZE
      #
      CALL xml.Serializer.VariableToSoapSection5(ws_funcs_check_serviceRequest,body)

      # Send SOAP envelope
      CALL ws_funcs_check_serviceHTTPReq.doXmlRequest(writer)
    CATCH
      LET wsstatus = STATUS
      CALL WSHelper_FillSOAP11WSError("Client",SQLCA.SQLERRM)
      LET ws_funcs_check_serviceHTTPReq = NULL
      RETURN wsstatus    
    END TRY

  #
  # PROCESS RESPONSE
  #
  TRY
    LET ws_funcs_check_serviceHTTPResp = ws_funcs_check_serviceHTTPReq.getAsyncResponse()
    RETURN 0 # SUCCESS
  CATCH
    LET wsstatus = STATUS
    CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
    LET ws_funcs_check_serviceHTTPReq = NULL
    RETURN wsstatus
  END TRY
END FUNCTION


FUNCTION ws_funcs_check_serviceResponse_g()
  DEFINE wsstatus        INTEGER
  DEFINE nb              INTEGER
  DEFINE uri             STRING
  DEFINE setcookie       STRING
  DEFINE mustUnderstand  INTEGER
  DEFINE reader          xml.DomDocument
  DEFINE envelope        xml.DomNode
  DEFINE header          xml.DomNode
  DEFINE body            xml.DomNode
  DEFINE node            xml.DomNode

  LET wsstatus = -1

  LET uri = com.WebServiceEngine.GetOption("SoapModuleURI")
  #
  # CHECK PREVIOUS CALL  
  #
  IF ws_funcs_check_serviceHTTPReq IS NULL THEN
    # No request was sent
    CALL WSHelper_FillSOAP11WSError("Client","No request has been sent")
    RETURN -1    
  END IF

  TRY
    #
    # PROCESS RESPONSE
    #
    IF ws_funcs_check_serviceHTTPResp IS NULL THEN
      # Still no response, try again
      LET ws_funcs_check_serviceHTTPResp = ws_funcs_check_serviceHTTPReq.getAsyncResponse()
    END IF

    IF ws_funcs_check_serviceHTTPResp IS NULL THEN
      # We got no response, still waiting for
      CALL WSHelper_FillSOAP11WSError("Client","Response was not yet received")
      RETURN -2      
    END IF

      #
      # RETRIEVE SERVICE SESSION COOKIE
      #
      LET setcookie = ws_funcs_check_serviceHTTPResp.getHeader("Set-Cookie")
      IF setcookie IS NOT NULL THEN
        LET imageWS_imageWSPortEndpoint.Binding.Cookie = WSHelper_ExtractServerCookie(setcookie,imageWS_imageWSPortEndpoint.Address.Uri)
      END IF

      #
      # RETRIEVE HTTP RESPONSE Headers
      #
      CALL WSHelper_SetResponseHeaders(ws_funcs_check_serviceHTTPResp, imageWS_imageWSPortEndpoint.Binding.Response.Headers)
      CASE ws_funcs_check_serviceHTTPResp.getStatusCode()

        WHEN 500 # SOAP Fault
          #
          # DOM SOAP FAULT
          #
          LET reader = ws_funcs_check_serviceHTTPResp.getXmlResponse()
          LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
          IF envelope IS NULL THEN
            EXIT CASE
          END IF
          LET header = WSHelper_CheckSOAP11Header(envelope)
          LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
          IF body IS NULL THEN
            EXIT CASE
          END IF
          # Handle SOAP headers
          IF header IS NOT NULL THEN
            LET node = header.getFirstChildElement()
            WHILE (node IS NOT NULL)
              IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                IF mustUnderstand = -1 THEN
                  CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                  EXIT CASE
                END IF
                IF mustUnderstand THEN
                  CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                  EXIT CASE
                ELSE
                  LET node = node.getNextSiblingElement() # Skip header, not mandatory
                END IF
              ELSE
                LET node = node.getNextSiblingElement() # Skip header, not intended to us
              END IF
            END WHILE
          END IF
          CALL WSHelper_CheckSOAP11Fault(body.getFirstChildElement())

        WHEN 200 # SOAP Result
          #
          # DOM SOAP RESPONSE
          #
          LET reader = ws_funcs_check_serviceHTTPResp.getXmlResponse()
          LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
          IF envelope IS NULL THEN
            EXIT CASE
          END IF
          LET header = WSHelper_RetrieveSOAP11Header(envelope)
          # Retrieve body
          LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
          # Handle SOAP headers
          IF header IS NOT NULL THEN
            LET node = header.getFirstChildElement()
            LET nb = 0
            WHILE (node IS NOT NULL)
              IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                IF mustUnderstand = -1 THEN
                  CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                  EXIT CASE
                END IF
                #
                # DOM SOAP RESPONSE HEADER DESERIALIZE
                #
                IF mustUnderstand THEN
                  CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                  EXIT CASE
                ELSE
                  LET node = node.getNextSiblingElement() # Skip header, not mandatory
                END IF
              ELSE
                LET node = node.getNextSiblingElement() # Skip header, not intended to us
              END IF
            END WHILE
            IF nb != 0 THEN
              CALL WSHelper_FillSOAP11WSError("Client","One or more headers are missing")
              EXIT CASE
            END IF
          END IF
          IF body IS NOT NULL THEN
            # Check message
            LET node = WSHelper_RetrieveSOAP11Message(body)
            IF node IS NOT NULL THEN
              #
              # DOM SOAP RESPONSE DESERIALIZE
              #
              CALL Xml.Serializer.SoapSection5ToVariable(node,ws_funcs_check_serviceResponse)
              LET wsstatus = 0
            END IF
          END IF

        OTHERWISE
          CALL WSHelper_FillSOAP11WSError("Server","HTTP Error "||ws_funcs_check_serviceHTTPResp.getStatusCode()||" ("||ws_funcs_check_serviceHTTPResp.getStatusDescription()||")")

      END CASE
    CATCH
      LET wsstatus = status
      CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
    END TRY

  #
  # RESET VARIABLES
  #
  LET ws_funcs_check_serviceHTTPReq = NULL
  LET ws_funcs_check_serviceHTTPResp = NULL
  RETURN wsstatus

END FUNCTION



#
# Operation: ws_funcs.process_image
#

#
# FUNCTION: ws_funcs_process_image
#
FUNCTION ws_funcs_process_image(p_client_key, p_requestee, p_requesteddate, p_payload)
  DEFINE	p_client_key		STRING
  DEFINE	p_requestee		STRING
  DEFINE	p_requesteddate		STRING
  DEFINE	p_payload		STRING
  DEFINE	soapStatus		INTEGER


  LET ws_funcs_process_imageRequest.client_key = p_client_key
  LET ws_funcs_process_imageRequest.requestee = p_requestee
  LET ws_funcs_process_imageRequest.requesteddate = p_requesteddate
  LET ws_funcs_process_imageRequest.payload = p_payload

  LET soapStatus = ws_funcs_process_image_g()

  RETURN soapStatus, ws_funcs_process_imageResponse.return
END FUNCTION

#
# FUNCTION: ws_funcs_process_image_g
#   RETURNING: soapStatus
#   INPUT: GLOBAL ws_funcs_process_imageRequest
#   OUTPUT: GLOBAL ws_funcs_process_imageResponse
#
FUNCTION ws_funcs_process_image_g()
  DEFINE wsstatus   INTEGER
  DEFINE retryAuth  INTEGER
  DEFINE retryProxy INTEGER
  DEFINE retry      INTEGER
  DEFINE nb         INTEGER
  DEFINE uri        STRING
  DEFINE setcookie  STRING
  DEFINE mustUnderstand INTEGER
  DEFINE request    com.HTTPRequest
  DEFINE response   com.HTTPResponse
  DEFINE writer     xml.DomDocument
  DEFINE reader     xml.DomDocument
  DEFINE envelope   xml.DomNode
  DEFINE header     xml.DomNode
  DEFINE body       xml.DomNode
  DEFINE node       xml.DomNode

  #
  # INIT VARIABLES
  #
  LET wsstatus = -1
  LET retryAuth = FALSE
  LET retryProxy = FALSE
  LET retry = TRUE
  LET uri = com.WebServiceEngine.GetOption("SoapModuleURI")

  IF imageWS_imageWSPortEndpoint.Address.Uri IS NULL THEN
    LET imageWS_imageWSPortEndpoint.Address.Uri = "http://ryanhamlin.co.uk/ws/ws.php"
  END IF

  #
  # CREATE REQUEST
  #
  TRY
    LET request = com.HTTPRequest.Create(imageWS_imageWSPortEndpoint.Address.Uri)
    CALL request.setMethod("POST")
    CALL request.setCharset("UTF-8")
    CALL request.setHeader("SOAPAction","\"http://www.ryanhamlin.co.uk/ws/imageWS2#process_image\"")
    CALL WSHelper_SetRequestHeaders(request, imageWS_imageWSPortEndpoint.Binding.Request.Headers)
    IF imageWS_imageWSPortEndpoint.Binding.Version IS NOT NULL THEN
      CALL request.setVersion(imageWS_imageWSPortEndpoint.Binding.Version)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.Cookie IS NOT NULL THEN
      CALL request.setHeader("Cookie",imageWS_imageWSPortEndpoint.Binding.Cookie)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.ConnectionTimeout <> 0 THEN
      CALL request.setConnectionTimeout(imageWS_imageWSPortEndpoint.Binding.ConnectionTimeout)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.ReadWriteTimeout <> 0 THEN
      CALL request.setTimeout(imageWS_imageWSPortEndpoint.Binding.ReadWriteTimeout)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.CompressRequest IS NOT NULL THEN
      CALL request.setHeader("Content-Encoding",imageWS_imageWSPortEndpoint.Binding.CompressRequest)
    END IF
    CALL request.setHeader("Accept-Encoding","gzip, deflate")
  CATCH
    LET wsstatus = STATUS
    CALL WSHelper_FillSOAP11WSError("Client","Cannot create HTTPRequest")
    RETURN wsstatus    
  END TRY

  # START LOOP
  WHILE retry
    LET retry = FALSE

    #
    # DOM Request
    #

    TRY
      # Building SOAP1.1 envelope
      LET writer = xml.DomDocument.Create()
      LET envelope = WSHelper_BuildSOAP11Envelope(writer)
      CALL writer.appendDocumentNode(envelope)
      LET body = WSHelper_BuildSOAP11Body(writer)
      CALL envelope.appendChild(body)
      #
      # DOM SOAP REQUEST SERIALIZE
      #
      CALL xml.Serializer.VariableToSoapSection5(ws_funcs_process_imageRequest,body)

      # Send SOAP envelope
      CALL request.doXmlRequest(writer)
    CATCH
      LET wsstatus = STATUS
      CALL WSHelper_FillSOAP11WSError("Client",SQLCA.SQLERRM)
      RETURN wsstatus    
    END TRY

    #
    # PROCESS RESPONSE
    #
    TRY
      LET response = request.getResponse()

      #
      # RETRIEVE SERVICE SESSION COOKIE
      #
      LET setcookie = response.getHeader("Set-Cookie")
      IF setcookie IS NOT NULL THEN
        LET imageWS_imageWSPortEndpoint.Binding.Cookie = WSHelper_ExtractServerCookie(setcookie,imageWS_imageWSPortEndpoint.Address.Uri)
      END IF

      #
      # RETRIEVE HTTP RESPONSE Headers
      #
      CALL WSHelper_SetResponseHeaders(response, imageWS_imageWSPortEndpoint.Binding.Response.Headers)
      CASE response.getStatusCode()

        WHEN 500 # SOAP Fault
          #
          # DOM SOAP FAULT
          #
          LET reader = response.getXmlResponse()
          LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
          IF envelope IS NULL THEN
            EXIT CASE
          END IF
          LET header = WSHelper_CheckSOAP11Header(envelope)
          LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
          IF body IS NULL THEN
            EXIT CASE
          END IF
          # Handle SOAP headers
          IF header IS NOT NULL THEN
            LET node = header.getFirstChildElement()
            WHILE (node IS NOT NULL)
              IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                IF mustUnderstand = -1 THEN
                  CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                  EXIT CASE
                END IF
                IF mustUnderstand THEN
                  CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                  EXIT CASE
                ELSE
                  LET node = node.getNextSiblingElement() # Skip header, not mandatory
                END IF
              ELSE
                LET node = node.getNextSiblingElement() # Skip header, not intended to us
              END IF
            END WHILE
          END IF
          CALL WSHelper_CheckSOAP11Fault(body.getFirstChildElement())

        WHEN 200 # SOAP Result
          #
          # DOM SOAP RESPONSE
          #
          LET reader = response.getXmlResponse()
          LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
          IF envelope IS NULL THEN
            EXIT CASE
          END IF
          LET header = WSHelper_RetrieveSOAP11Header(envelope)
          # Retrieve body
          LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
          # Handle SOAP headers
          IF header IS NOT NULL THEN
            LET node = header.getFirstChildElement()
            LET nb = 0
            WHILE (node IS NOT NULL)
              IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                IF mustUnderstand = -1 THEN
                  CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                  EXIT CASE
                END IF
                #
                # DOM SOAP RESPONSE HEADER DESERIALIZE
                #
                IF mustUnderstand THEN
                  CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                  EXIT CASE
                ELSE
                  LET node = node.getNextSiblingElement() # Skip header, not mandatory
                END IF
              ELSE
                LET node = node.getNextSiblingElement() # Skip header, not intended to us
              END IF
            END WHILE
            IF nb != 0 THEN
              CALL WSHelper_FillSOAP11WSError("Client","One or more headers are missing")
              EXIT CASE
            END IF
          END IF
          IF body IS NOT NULL THEN
            # Check message
            LET node = WSHelper_RetrieveSOAP11Message(body)
            IF node IS NOT NULL THEN
              #
              # DOM SOAP RESPONSE DESERIALIZE
              #
              CALL Xml.Serializer.SoapSection5ToVariable(node,ws_funcs_process_imageResponse)
              LET wsstatus = 0
            END IF
          END IF

        WHEN 401 # HTTP Authentication
          IF retryAuth THEN
            CALL WSHelper_FillSOAP11WSError("Server","HTTP Error 401 ("||response.getStatusDescription()||")")
          ELSE
            LET retryAuth = TRUE
            LET retry = TRUE
          END IF

        WHEN 407 # Proxy Authentication
          IF retryProxy THEN
            CALL WSHelper_FillSOAP11WSError("Server","HTTP Error 407 ("||response.getStatusDescription()||")")
          ELSE
            LET retryProxy = TRUE
            LET retry = TRUE
          END IF

        OTHERWISE
          CALL WSHelper_FillSOAP11WSError("Server","HTTP Error "||response.getStatusCode()||" ("||response.getStatusDescription()||")")

      END CASE
    CATCH
      LET wsstatus = status
      CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
      RETURN wsstatus    
    END TRY

  # END LOOP
  END WHILE

  RETURN wsstatus

END FUNCTION


FUNCTION ws_funcs_process_imageRequest_g()
  DEFINE wsstatus   INTEGER
  DEFINE nb         INTEGER
  DEFINE writer     xml.DomDocument
  DEFINE envelope   xml.DomNode
  DEFINE header     xml.DomNode
  DEFINE body       xml.DomNode
  DEFINE node       xml.DomNode

  #
  # CHECK PREVIOUS CALL  
  #
  IF ws_funcs_process_imageHTTPReq IS NOT NULL AND ws_funcs_process_imageHTTPResp IS NULL THEN
    # Request was sent but there was no response yet
    CALL WSHelper_FillSOAP11WSError("Client","Cannot issue a new request until previous response was received")
    RETURN -2 # waiting for the response
  ELSE
    IF imageWS_imageWSPortEndpoint.Address.Uri IS NULL THEN
      LET imageWS_imageWSPortEndpoint.Address.Uri = "http://ryanhamlin.co.uk/ws/ws.php"
    END IF
  END IF

  #
  # CREATE REQUEST
  #
  TRY
    LET ws_funcs_process_imageHTTPReq = com.HTTPRequest.Create(imageWS_imageWSPortEndpoint.Address.Uri)
    CALL ws_funcs_process_imageHTTPReq.setMethod("POST")
    CALL ws_funcs_process_imageHTTPReq.setCharset("UTF-8")
    CALL ws_funcs_process_imageHTTPReq.setHeader("SOAPAction","\"http://www.ryanhamlin.co.uk/ws/imageWS2#process_image\"")
    CALL WSHelper_SetRequestHeaders(ws_funcs_process_imageHTTPReq, imageWS_imageWSPortEndpoint.Binding.Request.Headers)
    IF imageWS_imageWSPortEndpoint.Binding.Version IS NOT NULL THEN
      CALL ws_funcs_process_imageHTTPReq.setVersion(imageWS_imageWSPortEndpoint.Binding.Version)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.Cookie IS NOT NULL THEN
      CALL ws_funcs_process_imageHTTPReq.setHeader("Cookie",imageWS_imageWSPortEndpoint.Binding.Cookie)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.ConnectionTimeout <> 0 THEN
      CALL ws_funcs_process_imageHTTPReq.setConnectionTimeout(imageWS_imageWSPortEndpoint.Binding.ConnectionTimeout)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.ReadWriteTimeout <> 0 THEN
      CALL ws_funcs_process_imageHTTPReq.setTimeout(imageWS_imageWSPortEndpoint.Binding.ReadWriteTimeout)
    END IF
    IF imageWS_imageWSPortEndpoint.Binding.CompressRequest IS NOT NULL THEN
      CALL ws_funcs_process_imageHTTPReq.setHeader("Content-Encoding",imageWS_imageWSPortEndpoint.Binding.CompressRequest)
    END IF
    CALL ws_funcs_process_imageHTTPReq.setHeader("Accept-Encoding","gzip, deflate")
  CATCH
    LET wsstatus = STATUS
    CALL WSHelper_FillSOAP11WSError("Client","Cannot create HTTPRequest")
    LET ws_funcs_process_imageHTTPReq = NULL
    RETURN wsstatus    
  END TRY

    #
    # DOM Request
    #

    TRY
      # Building SOAP1.1 envelope
      LET writer = xml.DomDocument.Create()
      LET envelope = WSHelper_BuildSOAP11Envelope(writer)
      CALL writer.appendDocumentNode(envelope)
      LET body = WSHelper_BuildSOAP11Body(writer)
      CALL envelope.appendChild(body)
      #
      # DOM SOAP REQUEST SERIALIZE
      #
      CALL xml.Serializer.VariableToSoapSection5(ws_funcs_process_imageRequest,body)

      # Send SOAP envelope
      CALL ws_funcs_process_imageHTTPReq.doXmlRequest(writer)
    CATCH
      LET wsstatus = STATUS
      CALL WSHelper_FillSOAP11WSError("Client",SQLCA.SQLERRM)
      LET ws_funcs_process_imageHTTPReq = NULL
      RETURN wsstatus    
    END TRY

  #
  # PROCESS RESPONSE
  #
  TRY
    LET ws_funcs_process_imageHTTPResp = ws_funcs_process_imageHTTPReq.getAsyncResponse()
    RETURN 0 # SUCCESS
  CATCH
    LET wsstatus = STATUS
    CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
    LET ws_funcs_process_imageHTTPReq = NULL
    RETURN wsstatus
  END TRY
END FUNCTION


FUNCTION ws_funcs_process_imageResponse_g()
  DEFINE wsstatus        INTEGER
  DEFINE nb              INTEGER
  DEFINE uri             STRING
  DEFINE setcookie       STRING
  DEFINE mustUnderstand  INTEGER
  DEFINE reader          xml.DomDocument
  DEFINE envelope        xml.DomNode
  DEFINE header          xml.DomNode
  DEFINE body            xml.DomNode
  DEFINE node            xml.DomNode

  LET wsstatus = -1

  LET uri = com.WebServiceEngine.GetOption("SoapModuleURI")
  #
  # CHECK PREVIOUS CALL  
  #
  IF ws_funcs_process_imageHTTPReq IS NULL THEN
    # No request was sent
    CALL WSHelper_FillSOAP11WSError("Client","No request has been sent")
    RETURN -1    
  END IF

  TRY
    #
    # PROCESS RESPONSE
    #
    IF ws_funcs_process_imageHTTPResp IS NULL THEN
      # Still no response, try again
      LET ws_funcs_process_imageHTTPResp = ws_funcs_process_imageHTTPReq.getAsyncResponse()
    END IF

    IF ws_funcs_process_imageHTTPResp IS NULL THEN
      # We got no response, still waiting for
      CALL WSHelper_FillSOAP11WSError("Client","Response was not yet received")
      RETURN -2      
    END IF

      #
      # RETRIEVE SERVICE SESSION COOKIE
      #
      LET setcookie = ws_funcs_process_imageHTTPResp.getHeader("Set-Cookie")
      IF setcookie IS NOT NULL THEN
        LET imageWS_imageWSPortEndpoint.Binding.Cookie = WSHelper_ExtractServerCookie(setcookie,imageWS_imageWSPortEndpoint.Address.Uri)
      END IF

      #
      # RETRIEVE HTTP RESPONSE Headers
      #
      CALL WSHelper_SetResponseHeaders(ws_funcs_process_imageHTTPResp, imageWS_imageWSPortEndpoint.Binding.Response.Headers)
      CASE ws_funcs_process_imageHTTPResp.getStatusCode()

        WHEN 500 # SOAP Fault
          #
          # DOM SOAP FAULT
          #
          LET reader = ws_funcs_process_imageHTTPResp.getXmlResponse()
          LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
          IF envelope IS NULL THEN
            EXIT CASE
          END IF
          LET header = WSHelper_CheckSOAP11Header(envelope)
          LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
          IF body IS NULL THEN
            EXIT CASE
          END IF
          # Handle SOAP headers
          IF header IS NOT NULL THEN
            LET node = header.getFirstChildElement()
            WHILE (node IS NOT NULL)
              IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                IF mustUnderstand = -1 THEN
                  CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                  EXIT CASE
                END IF
                IF mustUnderstand THEN
                  CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                  EXIT CASE
                ELSE
                  LET node = node.getNextSiblingElement() # Skip header, not mandatory
                END IF
              ELSE
                LET node = node.getNextSiblingElement() # Skip header, not intended to us
              END IF
            END WHILE
          END IF
          CALL WSHelper_CheckSOAP11Fault(body.getFirstChildElement())

        WHEN 200 # SOAP Result
          #
          # DOM SOAP RESPONSE
          #
          LET reader = ws_funcs_process_imageHTTPResp.getXmlResponse()
          LET envelope = WSHelper_RetrieveSOAP11Envelope(reader)
          IF envelope IS NULL THEN
            EXIT CASE
          END IF
          LET header = WSHelper_RetrieveSOAP11Header(envelope)
          # Retrieve body
          LET body = WSHelper_RetrieveSOAP11Body(envelope,header)
          # Handle SOAP headers
          IF header IS NOT NULL THEN
            LET node = header.getFirstChildElement()
            LET nb = 0
            WHILE (node IS NOT NULL)
              IF WSHelper_CheckSOAP11HeaderActor(node,uri) THEN
                LET mustUnderstand = WSHelper_GetSOAP11HeaderMustUnderstand(node)
                IF mustUnderstand = -1 THEN
                  CALL WSHelper_FillSOAP11WSError("Client","Invalid mustUnderstand value")
                  EXIT CASE
                END IF
                #
                # DOM SOAP RESPONSE HEADER DESERIALIZE
                #
                IF mustUnderstand THEN
                  CALL WSHelper_FillSOAP11WSError("MustUnderstand","Mandatory header block not understood")
                  EXIT CASE
                ELSE
                  LET node = node.getNextSiblingElement() # Skip header, not mandatory
                END IF
              ELSE
                LET node = node.getNextSiblingElement() # Skip header, not intended to us
              END IF
            END WHILE
            IF nb != 0 THEN
              CALL WSHelper_FillSOAP11WSError("Client","One or more headers are missing")
              EXIT CASE
            END IF
          END IF
          IF body IS NOT NULL THEN
            # Check message
            LET node = WSHelper_RetrieveSOAP11Message(body)
            IF node IS NOT NULL THEN
              #
              # DOM SOAP RESPONSE DESERIALIZE
              #
              CALL Xml.Serializer.SoapSection5ToVariable(node,ws_funcs_process_imageResponse)
              LET wsstatus = 0
            END IF
          END IF

        OTHERWISE
          CALL WSHelper_FillSOAP11WSError("Server","HTTP Error "||ws_funcs_process_imageHTTPResp.getStatusCode()||" ("||ws_funcs_process_imageHTTPResp.getStatusDescription()||")")

      END CASE
    CATCH
      LET wsstatus = status
      CALL WSHelper_FillSOAP11WSError("Server",SQLCA.SQLERRM)
    END TRY

  #
  # RESET VARIABLES
  #
  LET ws_funcs_process_imageHTTPReq = NULL
  LET ws_funcs_process_imageHTTPResp = NULL
  RETURN wsstatus

END FUNCTION


