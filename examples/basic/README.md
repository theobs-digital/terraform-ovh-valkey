# Basic example

Creates a Valkey 8.1 database on plan `essential`, with two `b3-8` nodes in
`GRA` on the public network, and no user. The module defaults apply to
everything else, deletion protection included.

```bash
export OVH_ENDPOINT=ovh-eu OVH_CLIENT_ID=... OVH_CLIENT_SECRET=...
terraform init
terraform apply -var service_name=<Public Cloud project ID>
```

The provider also takes `OVH_APPLICATION_KEY`, `OVH_APPLICATION_SECRET` and
`OVH_CONSUMER_KEY` instead of the OAuth2 client.
