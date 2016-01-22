# README

## Requirements

* postgres
* redis

## Setup

    bundle
    rails db:create # use `rails` instead of `rake` since the project uses rails 5
    rails db:migrate

## Tests

    rake

## Run

    foreman start -f Procfile.dev
