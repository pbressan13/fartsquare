# FartSquare Project

## Pre-Requisites

- Ruby 2.7
- Rails 5+
- Postgre
- Yarn

## How to install

- Download the source code

- Do the following steps on your terminal

```
cd fartsquare
gem install bundler  -v '~> 2.2'
bundle install
rails db:create
rails db:migrate
yarn add bootstrap jquery popper.js
```

- Create a new file with these enviroment variables

```touch .env```

***
BONSAI_SILVER_URL=

BONSAI_URL=

CLOUDINARY_URL=

DATABASE_URL=

DOMAIN=

ELASTICSEARCH_URL=

GOOGLE_CLIENT_ID=

GOOGLE_CLIENT_SECRET=

LANG=

MAPBOX_API_KEY=

MAPQUEST_API_KEY=

PLACES_API=

RACK_ENV=

RAILS_ENV=

RAILS_LOG_TO_STDOUT=

RAILS_SERVE_STATIC_FILES=

REDISCLOUD_URL=

SECRET_KEY_BASE=

TZ=

***

- Run rails server

```
rails server
```





