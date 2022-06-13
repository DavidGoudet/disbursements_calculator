# README

This app will calculate and persist the disbursements that need to be paid to merchants on a given week.

## Installation instructions
The app is using the Ruby on Rails framework to work. To test it in a local environment you need to:
* Install Ruby on Rails on your local machine:
[Ruby on Rails Installation Instructions](http://https://www.tutorialspoint.com/ruby-on-rails/rails-installation.htm "Ruby on Rails Installation Instructions")
* Install Postgres and create a user for the database:
[Postgress setup for Rails](http://https://www.digitalocean.com/community/tutorials/how-to-set-up-ruby-on-rails-with-postgres "Postgress setup for Rails")
* Fill the username and password in the file `database.yml`
* Run `bundle install` to install the gems
* Create a server with `rails s`

## Use instructions
* Start by saving the JSON files you want to use in these paths:
`public/inputs/merchants.json`
`public/inputs/orders.json`
* Fetch the JSON files from the app by opening a browser and accessing:
`http://127.0.0.1:3000/fetch`
* Calculate the disbursements by browsing:
`http://127.0.0.1:3000/calculator/01-01-2018/B611111112`
Where `01-01-2018` represents a week and **must be a Monday** and `B611111112` represents the CIF of a Merchant.

## Technologies
* Ruby 2.7.3
* Ruby on Rails 7.0.3
* RSpec for the testing suite
* Sidekiq for background job processing
* Figaro for app configuration
* Rubocop as code analyzer

## Patterns
* Strategy: in both the fetcher and the calculator the app is using a Strategy Pattern by using Rails modules. Making easy the creation of new fetchers (as for CSV) and calculators (i.e. for other countries).
* Builder: the calculator is using an implicit Builder Pattern that allows the easy replacement of the methods for other calculators.