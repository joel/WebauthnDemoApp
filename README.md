# README

## Run the service

```
DB_PORT=5432 ./bin/db start
```

```
DB_PORT=5432 bin/rails db:prepare OR bin/rails db:reset
```

```
ngrok http 3005
```

```
RAILS_LOG_TO_STDOUT=true NGROK_DOMAIN=b16a-213-94-41-19 PORT=3005 ./bin/dev
```
