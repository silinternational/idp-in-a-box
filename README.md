# idp-in-a-box
Documentation, examples, Docker Compose setup, Terraform modules, etc. for our IdP-in-a-Box service

## bringing up idp-in-a-box locally
1. Edit /etc/hosts or equivalent to assign `pw-api.local`, `pw-ui.local`, and `ssp.local` to 127.0.0.1.
2. `cd docker-compose`
3. `docker-compose up -d`
4. `docker-compose exec broker ./yii migrate --interactive=0`

#### Optional
1. Add `LOGENTRIES` tokens in `docker-compose.yml`

