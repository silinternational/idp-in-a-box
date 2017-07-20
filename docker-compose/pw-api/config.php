<?php

use Sil\PhpEnv\Env;

$zxcvbnApiBaseUrl = Env::get('ZXCVBN_API_BASEURL', 'http://zxcvbn:3000');

return [
    'params' => [
        'accessTokenHashKey' => 'KEY4TESTING',
        'password' => [
            'minLength' => [
                'value' => 10,
                'phpRegex' => '/.{10,}/',
                'jsRegex' => '.{10,}',
                'enabled' => true
            ],
            'maxLength' => [
                'value' => 255,
                'phpRegex' => '/^.{0,255}$/',
                'jsRegex' => '.{0,255}',
                'enabled' => true
            ],
            'minNum' => [
                'value' => 2,
                'phpRegex' => '/(\d.*){2,}/',
                'jsRegex' => '(\d.*){2,}',
                'enabled' => true
            ],
            'minUpper' => [
                'value' => 1,
                'phpRegex' => '/([A-Z].*){1,}/',
                'jsRegex' => '([A-Z].*){1,}',
                'enabled' => true
            ],
            'minSpecial' => [
                'value' => 1,
                'phpRegex' => '/([\W_].*){1,}/',
                'jsRegex' => '([\W_].*){1,}',
                'enabled' => true
            ],
            'zxcvbn' => [
                'minScore' => 2,
                'enabled' => true,
                'apiBaseUrl' => $zxcvbnApiBaseUrl,
            ]
        ],
    ],
    'components' => [
        'mailer' => [
            'useFileTransport' => true,
            'transport' => [
                'host' => null,
            ],
        ],
        'personnel' => [
            'class' => 'tests\mock\personnel\Component',
        ],
        'auth' => [
          'class' => '\Sil\IdpPw\Auth\Saml',
          'signRequest' => false,
          'checkResponseSigning' => false,
          'requireEncryptedAssertion' => false,
          'idpCertificate' => 'MIIDzzCCAregAwIBAgIJAPlZYTAQSIbHMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJOQzEPMA0GA1UEBwwGV2F4aGF3MQwwCgYDVQQKDANTSUwxDTALBgNVBAsMBEdUSVMxDjAMBgNVBAMMBVN0ZXZlMSQwIgYJKoZIhvcNAQkBFhVzdGV2ZV9iYWd3ZWxsQHNpbC5vcmcwHhcNMTYxMDE3MTIzMTQ1WhcNMjYxMDE3MTIzMTQ1WjB+MQswCQYDVQQGEwJVUzELMAkGA1UECAwCTkMxDzANBgNVBAcMBldheGhhdzEMMAoGA1UECgwDU0lMMQ0wCwYDVQQLDARHVElTMQ4wDAYDVQQDDAVTdGV2ZTEkMCIGCSqGSIb3DQEJARYVc3RldmVfYmFnd2VsbEBzaWwub3JnMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArssOaeKbdOQFpN6bBolwSJ/6QFBXA73Sotg60anx9v6aYdUTmi+b7SVtvOmHDgsD5X8pN/6Z11QCZfTYg2nW3ZevGZsj8W/R6C8lRLHzWUr7e7DXKfj8GKZptHlUs68kn0ndNVt9r/+irJe9KBdZ+4kAihykomNdeZg06bvkklxVcvpkOfLTQzEqJAmISPPIeOXes6hXORdqLuRNTuIKarcZ9rstLnpgAs2TE4XDOrSuUg3XFnM05eDpFQpUb0RXWcD16mLCPWw+CPrGoCfoftD5ZGfll+W2wZ7d0kQ4TbCpNyxQH35q65RPVyVNPgSNSsFFkmdcqP9DsFqjJ8YC6wIDAQABo1AwTjAdBgNVHQ4EFgQUD6oyJKOPPhvLQpDCC3027QcuQwUwHwYDVR0jBBgwFoAUD6oyJKOPPhvLQpDCC3027QcuQwUwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAA6tCLHJQGfXGdFerQ3J0wUu8YDSLb0WJqPtGdIuyeiywR5ooJf8G/jjYMPgZArepLQSSi6t8/cjEdkYWejGnjMG323drQ9M1sKMUhOJF4po9R3t7IyvGAL3fSqjXA8JXH5MuGuGtChWxaqhduA0dBJhFAtAXQ61IuIQF7vSFxhTwCvJnaWdWD49sG5OqjCfgIQdY/mw70e45rLnR/bpfoigL67sTJxy+Kx2ogbvMR6lITByOEQFMt7BYpMtXrwvKUM7k9NOo1jREmJacC8PTx//jRhCWwzUj1RsfIri24BuITrawwqMsYl8DZiiwMpjUf9m4NPaf4E7+QRpzo+MCcg==',
          'spCertificate' => 'MIIDtTCCAp2gAwIBAgIJAK2cyEwuxdADMA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwHhcNMTcwNDI4MTMyNjA2WhcNMjcwNDI4MTMyNjA2WjBFMQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtVzLISMbdMHa7yPQgcdmH5khNTGv9zchvL15dEmsAgFIHZQULm72lclpsThdpb95r6lbnEqfhidTVnqpFQv755gzxn4r+ScFCTMPdsdK+Flh5Ej10VOYfBepBhrhU7mZhF4UFFHvx4karENyCQeEjw2JCNmDO/hDX5vluYip09TfEQSbCO6zYoEx6Z+PoDauYBYhQka3H8DDhSg/vjTuHoos4bkW/gRbgVAAOGgtx6gp4djb4WlldMKEjXcKihLGQXYPw5Ur2dHLOxuSAkxSnFrx+Eb/26/dU0RZC/a2ipujCQhjT9uiw1x7orSjDK1SFHq9Xlie0e0W8sVrgZtwYQIDAQABo4GnMIGkMB0GA1UdDgQWBBRxdpPqYNHv58zusXJyeb9L1Iv3pjB1BgNVHSMEbjBsgBRxdpPqYNHv58zusXJyeb9L1Iv3pqFJpEcwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUtU3RhdGUxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZIIJAK2cyEwuxdADMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADggEBAEUr+4aDqozvb3P+53vjYR1OIyJdE4EhZjLpT2xwIqhQVaED7nfxaY0E3znE53YoNUlDz8/+3zwU6aQxeZtD84Tbunv9X8hWgt9k97ib04pmHZe9Cp0B61Yv0aUmKGlFEPEzG84jfjnILhS0fxePIjKpot6bt3EJ1XnfLvrNGBeWgQao3qGaXVwK/9gJOFUGLRG2X34AI2nTNAbr2Sexvn8yVarY41VC08nGoqrFnoKf3zi1GH6Pp8XSVCt4bU7u/I9XBsUpagVFxkw2wJZW9kBkfQLqtOwgRv2n4F4Ftxo9wLZJ5bPMcJf+R6PsJJQRslsW7NSFjoXIPnVXEF6nxQk=',
          'spPrivateKey' => 'MIIEpQIBAAKCAQEAtVzLISMbdMHa7yPQgcdmH5khNTGv9zchvL15dEmsAgFIHZQULm72lclpsThdpb95r6lbnEqfhidTVnqpFQv755gzxn4r+ScFCTMPdsdK+Flh5Ej10VOYfBepBhrhU7mZhF4UFFHvx4karENyCQeEjw2JCNmDO/hDX5vluYip09TfEQSbCO6zYoEx6Z+PoDauYBYhQka3H8DDhSg/vjTuHoos4bkW/gRbgVAAOGgtx6gp4djb4WlldMKEjXcKihLGQXYPw5Ur2dHLOxuSAkxSnFrx+Eb/26/dU0RZC/a2ipujCQhjT9uiw1x7orSjDK1SFHq9Xlie0e0W8sVrgZtwYQIDAQABAoIBAEaRIIh4PIqlkyZRbSPSDi5lSsKD3s/2J65kmwlgUQlGrmSz5VZb3p5RjEpkgCup4RM0dmzNrFxqmMahW4DQ9OccFak6FqoPQKpfr7irusP/I1PL/7m/KSm/mwjBFMObB9y1LmLprr6Y3kQAyjIxNqbiwVssJyACbVSaODyErG+7UFave0VHsUnxM3oYnCjnh9/XpX5xqXacFlbmU9fsC0bM/Tz9Xc6d1PVc4oNKdmIbjY3B1jvuGh2UxKtj4z1FCysNvMt7GoU7+N4eJcQPpAwT8q2GSxxUTXLJl35vRn8u2L4gTNDYc9bxDYbtRFvRQlnWWX9B2OaGAJwcOu2HrQECgYEA4xZwxgA7vc5L5c+1HjzdIZsD1D1WvnidzZFmD/Qfc8fbleUqFxG8TqbkB9ene45wqCy0utbhoPMC9/d0GlXXeOD8BnJQgmhnwXUcj6QM2FKpS6ludJ8CiRiTWY1kPew4ThzcWjVtHKrv4ieaodU6RpXRryEM5/5bLTSMB2GTc/kCgYEAzHQDfR96eROFRobHuYjmSrfTFJ45f9u5+y7ITZp1gEDVgFu+jriQItO8uhfHJQa4X5nrv7krTlQPmW9BJ7BvGadid0E03DKqBvEDlprpLfPWr891Y+WpvLn/j+Xywgp6D66ub33jNnhuKTPV01i5IxNvPIYv4kW/N/zR/zF5KakCgYEAtMxfCSWSavHed5/BYcuve1wB1m7nq0o4yTwj+Duy9ul+KH+F3UwfkrdJAf1uuO6VPzAozEDc7tnL2UTIyVbi8LifrzpAYzNguCPXk31XRLu7UiQZbvxSdnh8iGYME0kJIxfTUHcM4jAuQO6rLIGpnh0WDsrPjb1zNjCJ9C55yXECgYEAsSP7OdeiN3EQUhDIzxmr3iTy/7QvQXZQ5y6bYZFoKN0Dnpjeu61xRJuLsviTFKOD72De/1giC1WNxnS8UPTu7Z03FPgsInTLGASOBVjmm2ffJKhsn0cHD3tfz39+G10UcK36eKLrz+/8EjrVEq6Wiat2/0uMBVJE4O9tyttEjTECgYEAghljC9wBMEpAlK4E3YbYS1QgVWMjsk9VkAnBbJgUMlr2nJ2FrXcLLczY9s+L2E1ag5WPL36T2YC2CqfRFvFTAo8TvmRGBxnpWLgx2Lj/QkS/9iZGbGqHoF4D4nVwxx1LetmUVIwoYMDBXevunAg1OCvO2Mn32qkqCxOU3ZD5iIc=',
          'entityId' => 'localhost:8080',
          'ssoUrl' => 'http://localhost/saml2/idp/SSOService.php',
          'sloUrl' => 'http://localhost/saml2/idp/SingleLogoutService.php',
          'attributeMap' => [
              'idp_username' => ['field' => 'username', 'element' => 0 ],
              'first_name' => ['field' => 'first_name', 'element' => 0 ],
              'last_name' => ['field' => 'last_name', 'element' => 0 ],
              'email' => ['field' => 'email', 'element' => 0 ],
              'employee_id' => ['field' => 'employee_id', 'element' => 0],
          ]
        ],
        'phone' => [
            'class' => 'tests\mock\phone\Component',
            'codeLength' => 4,
        ],
        'passwordStore' => [
            'class' => 'Sil\IdpPw\PasswordStore\IdBroker\IdBroker',
            'baseUrl' => 'http://broker',
            'accessToken' => 'abc123abc123'
        ],
    ],
];
