# Authelia on Fly.io

This repo contains the configuration files for my personal single-user [Authelia] server running on [Fly.io].
It runs the single `authelia/authelia` Docker image with an embedded configuration file,
secrets stored in [Fly Secrets], and an on-disk SQLite database.
Even the ["lite"] example of Authelia spins up 5 containers, which isn't necessary for very simple uses.

There are certainly other ways to set this up, but this worked for me.

[Authelia]: https://www.authelia.com/
[Fly.io]: https://fly.io/
[Fly Secrets]: https://www.fly.io/docs/apps/secrets/
["lite"]: https://github.com/authelia/authelia/tree/master/examples/compose/lite

## Install Authelia

I use Authelia's built-in crypto utilities below to generate secrets and keys,
but you certainly don't have to.
It's available in a bunch of package repos,
or you can clone <https://github.com/authelia/authelia/> and build using `go install ./cmd/authelia`.

## Configuration

My [configuration] is pretty simple and contains basically the minimal needed to run.
I have a single OIDC client configured for [use with Tailscale].

I also have a `users_database.yml` file that contains my user account.
Just copy and update the [user database template file].
To generate a password and hash, run:

```
authelia crypto hash generate --random
```

[configuration]: ./configuration.yml
[use with Tailscale]: https://tailscale.com/kb/1240/sso-custom-oidc
[user database template file]: https://github.com/authelia/authelia/blob/master/internal/authentication/users_database.template.yml

## Fly

Adjust fly.toml to your needs, then run `fly app create` to create a new application.
Follow normal Fly docs to set that all up.
Also create a volume to store the SQLite database on.
I just created a 1GB volume named `data`.

## Secrets

I have an `.envrc` file that looks something like:

```
export AUTH_OIDC_HMAC_SECRET="SECRET"
export AUTH_OIDC_JWKS_KEY="SECRET"
export AUTH_OIDC_TAILSCALE_CLIENT_SECRET="$argon2id$v=19$m=65536,t=3,p=4$SECRET"
export AUTH_SESSION_SECRET="SECRET"
export AUTH_STORAGE_ENCRYPTION_KEY="SECRET"
export AUTH_SMTP_EMAIL="auth@example.com"
export AUTH_SMTP_PASSWORD="SECRET"
export AUTH_WILLNORRIS_PASSWORD="SECRET"
export AUTH_DOMAIN="auth.example.com"
```

Secret values can be generated with something like:

```
authelia crypto rand
```

For a random client secret and digest, use:

```
authelia crypto hash generate --random
```

For the `AUTH_OIDC_JWKS_KEY`, generate an RSA key pair with:

```
authelia crypto certificate rsa generate
```

Then take the actual key from `private.pem` (remove the `-----BEGIN/END PRIVATE KEY-----` lines),
combine everything onto a single line with no spaces,
and store that in the `AUTH_OIDC_JWKS_KEY` secret.

### Fly Secrets

I have the `export` command in my `.envrc` so that it loads with direnv and I can validate with `authelia config validate`.
To load into Fly, I run:

```
cat .envrc | sed 's/export //' | fly secrets import
```

## Deploy

And that's basically it.
Run `fly deploy` to deploy a new version.
