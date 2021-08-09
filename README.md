# Food find

[![CD](https://github.com/felunka/food_find/actions/workflows/cd.yml/badge.svg)](https://github.com/felunka/food_find/actions/workflows/cd.yml)

This is a very basic web application written in ruby on rails 6 to help find something to cook for dinner. You can setup your favorite foods and add tags to them.
Using the tags you can choose a random meal every day.

## Infrastructure

This repo is intended to be used with [this traefik setup](https://github.com/conscribtor/docker-traefik-letsencrypt). The reverse proxy handles obtaining a valid certificate and enforcing TLS.

### Docker setup

Starting the app via the compose will create a production build. The compose file also contains the postgresql db for the app. A database needs to be created manually with `rails db:create`

## Authentication

To enable password less authentication this app uses [webauthn](https://www.w3.org/TR/webauthn-2/) implemented with the [webauthn-ruby](https://github.com/cedarcode/webauthn-ruby) gem. To register a new Client you will need a one-time token which can be generated in the app or via the rails console:
```ruby
[1] pry(main)> RegistrationToken.create
```

## Adding food

Food and tags can be added once you are logged in. A food can have one image and unlimited amount of tags. Emoji are supported both in the name of the tags and food.

## Getting a random food

On the homepage you can get a random food item. Adding one or more tags (optional) will only select a random food with at least one of the selected tags.
