<?php
/**
 * SAML 2.0 remote SP metadata for SimpleSAMLphp.
 *
 * See: https://simplesamlphp.org/docs/stable/simplesamlphp-reference-sp-remote
 */

/*
 * Example SimpleSAMLphp SAML 2.0 SP
 */
$metadata['pw-api.local:8080'] = [
    'NameIDFormat' => 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent',
	  'AssertionConsumerService' => 'http://pw-api.local:8080/auth/login',
    'certData' => 'MIIDtTCCAp2gAwIBAgIJAK2cyEwuxdADMA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwHhcNMTcwNDI4MTMyNjA2WhcNMjcwNDI4MTMyNjA2WjBFMQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtVzLISMbdMHa7yPQgcdmH5khNTGv9zchvL15dEmsAgFIHZQULm72lclpsThdpb95r6lbnEqfhidTVnqpFQv755gzxn4r+ScFCTMPdsdK+Flh5Ej10VOYfBepBhrhU7mZhF4UFFHvx4karENyCQeEjw2JCNmDO/hDX5vluYip09TfEQSbCO6zYoEx6Z+PoDauYBYhQka3H8DDhSg/vjTuHoos4bkW/gRbgVAAOGgtx6gp4djb4WlldMKEjXcKihLGQXYPw5Ur2dHLOxuSAkxSnFrx+Eb/26/dU0RZC/a2ipujCQhjT9uiw1x7orSjDK1SFHq9Xlie0e0W8sVrgZtwYQIDAQABo4GnMIGkMB0GA1UdDgQWBBRxdpPqYNHv58zusXJyeb9L1Iv3pjB1BgNVHSMEbjBsgBRxdpPqYNHv58zusXJyeb9L1Iv3pqFJpEcwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUtU3RhdGUxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZIIJAK2cyEwuxdADMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADggEBAEUr+4aDqozvb3P+53vjYR1OIyJdE4EhZjLpT2xwIqhQVaED7nfxaY0E3znE53YoNUlDz8/+3zwU6aQxeZtD84Tbunv9X8hWgt9k97ib04pmHZe9Cp0B61Yv0aUmKGlFEPEzG84jfjnILhS0fxePIjKpot6bt3EJ1XnfLvrNGBeWgQao3qGaXVwK/9gJOFUGLRG2X34AI2nTNAbr2Sexvn8yVarY41VC08nGoqrFnoKf3zi1GH6Pp8XSVCt4bU7u/I9XBsUpagVFxkw2wJZW9kBkfQLqtOwgRv2n4F4Ftxo9wLZJ5bPMcJf+R6PsJJQRslsW7NSFjoXIPnVXEF6nxQk=',
];
