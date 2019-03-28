# idp-in-a-box
Documentation, examples, Docker Compose setup, Terraform modules, etc. for our IdP-in-a-Box service

## bringing up idp-in-a-box locally
1. Edit /etc/hosts or equivalent to assign `pw-api.local`, `pw-ui.local`, and `ssp.local` to 127.0.0.1.
2. `cd docker-compose`
3. `docker-compose up -d`
4. `docker-compose exec broker ./yii migrate --interactive=0`
5. open browser to `localhost:51052`

#### Optional
1. Add `LOGENTRIES` tokens in `docker-compose.yml`

#### Changes for 2019 Profile UI redesign
##### New or newly required environment variables
  * broker
    * `EMAILER_CLASS`
    * `EMAIL_SERVICE_accessToken`
    * `EMAIL_SERVICE_assertValidIp`
    * `EMAIL_SERVICE_baseUrl`  
    * `EMAIL_SERVICE_validIpRanges`
  * pw-api
    * `EMAILER_CLASS`
    * `EMAIL_SERVICE_accessToken`
    * `EMAIL_SERVICE_assertValidIp`
    * `EMAIL_SERVICE_baseUrl`
    * `EMAIL_SERVICE_validIpRanges`
    * `AUTH_CLASS`
    * `AUTH_SAML_signRequest`
    * `AUTH_SAML_checkResponseSigning`
    * `AUTH_SAML_requireEncryptedAssertion`
    * `AUTH_SAML_idpCertificate`
    * `AUTH_SAML_spCertificate`
    * `AUTH_SAML_spPrivateKey`
    * `AUTH_SAML_entityId`
    * `AUTH_SAML_ssoUrl`
    * `AUTH_SAML_sloUrl`
    * `APP_ENV`
    * `ID_BROKER_baseUrl`
    * `ID_BROKER_accessToken`
    * `ID_BROKER_assertValidBrokerIp`
    * `ID_BROKER_validIpRanges`
    * `PASSWORDSTORE_CLASS`
    * `PASSWORD_RULE_minLength`
    * `PASSWORD_RULE_maxLength`
    * `PASSWORD_RULE_minScore`
    * `PERSONNEL_CLASS`
  * ssp
    * `ID_BROKER_ASSERT_VALID_IP`
##### Remove obsolete environment variables:
  * broker
    * `MAILER_HOST`
    * `MAILER_PASSWORD`
    * `MAILER_USEFILES`
    * `MAILER_USERNAME`
  * pw-api
    * `ALERTS_EMAIL_ENABLED`
    * `MAILER_HOST`
    * `MAILER_PASSWORD`
    * `MAILER_USEFILES`
    * `MAILER_USERNAME`
    * `FROM_EMAIL`
##### Change namespace of pw-api components
  * `common\components\auth\Saml` (note `Auth` changed to `auth`)
  * `common\components\passwordStore\IdBroker`
  * `common\components\personnel\IdBroker`
##### Other changes
  * Components are not required to be defined in a `local.php` file in 
    `idp-pw-api`. Defaults are provided.
  * New `simplesamlphp-module-profilereview` module, which requires
    a new environment variable `PROFILE_URL` and an optional variable
    `SKIP_REVIEW_WHEN_HEADED_TO_PROFILE`.
  * New `groups` and `personal_email` properties
##### API changes
  * On pw-api, POST changed to PUT on `/mfa/{id}/verify`.
  * Also on pw-api, PUT `/method/{id}` changed to PUT `/method/{id}/verify`.
  * On broker, the `nag` property within the `mfa` object was replaced
    by `add` and `review`.
  * Several other additions for new features.
