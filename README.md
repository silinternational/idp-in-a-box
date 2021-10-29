# idp-in-a-box
Documentation, examples, Docker Compose setup, Terraform modules, etc. for our
IdP-in-a-Box service

## bringing up idp-in-a-box locally
1. Edit /etc/hosts or equivalent to assign `pw-api.local`, `pw-ui.local`, and
   `ssp.local` to 127.0.0.1.
2. Create `local.env` files in each of the subfolders there, using the existing
   `local.env.dist` files as guides where applicable.
3. `cd docker-compose`
4. `./up`
5. open browser to `localhost:51052`
