# idp-in-a-box
Terraform Configuration, Documentation, examples, and Docker Compose dev setup for the
IdP-in-a-Box service.

## bringing up idp-in-a-box locally using Docker Compose
1. Edit /etc/hosts or equivalent to assign `pw-api.local`, `pw-ui.local`, and
   `ssp.local` to 127.0.0.1.
2. Create `local.env` files in each of the subfolders there, using the existing
   `local.env.dist` files as guides where applicable.
3. `cd docker-compose`
4. `./up`
5. open browser to `localhost:51052`
