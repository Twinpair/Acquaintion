## Acquaintion [![Build Status](https://travis-ci.org/Twinpair/Acquaintion.svg?branch=master)](https://travis-ci.org/Twinpair/Acquaintion)

"Follow and be followed" Acquaintion is a basic Twitter clone built with the Ruby on Rails framework. 

Check it out here: https://acquaintion.herokuapp.com/

## Application / Version Information

* Ruby version - ruby 2.4.0rc1

* Rails version - 4.2.8

* Database - Postgres

* Framework - Ruby on Rails

* Hosted on Heroku

## Deployment Instructions

Make sure you have Rails and Git installed on your machine

1) git clone the repo to your local machine `git clone https://github.com/Twinpair/Acquaintion.git`

2) Run `bundle install` to install gems

3) Run `rake db:migrate` to migrate the database

4) On root path you can run `rails s` to begin server

5) Open browser to `localhost:3000` to view application

## Testing

Once you have the repo on your local machine

1) Run `rake db:migrate RAILS_ENV=test` to migrate the testing enviroment database

2) Run `rake test` to verify everything is ok =)
