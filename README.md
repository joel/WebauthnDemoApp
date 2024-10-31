# README

Example inspired from https://github.com/cedarcode/webauthn-rails-demo-app and the tweak of it https://github.com/pedz/rails-7-passkey-demo
using: https://github.com/cedarcode/webauthn-ruby and https://github.com/github/webauthn-json

Other code with differente approach
https://alliedcode.com/bits_and_bytes/passkeys-rails-gem
https://github.com/alliedcode/passkeys-rails
using: https://github.com/w3c/webauthn


# Run

## DB start (Docker)

`./bin/db start`

## Local Network

```
ngrok http 9292
```

## Rails app, change 6858-213-94-41-19 for the generate one by Ngrok

```
RAILS_LOG_TO_STDOUT=true NGROK_DOMAIN=6858-213-94-41-19 PORT=3005 ./bin/dev
```

## Open browser, change 6858-213-94-41-19 for the generate one by Ngrok

```
https://6858-213-94-41-19.ngrok-free.app
```