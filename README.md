# README

### Dependencies

System requirements:
- Ruby: 3.2.2
- PostgreSQL (installed and running)

This is a Rails 7 app initialized with:
- javascript: `esbuild`
- database: `postgres`
- css: `tailwind`

and further configured with:
- caching: `redis`
- tests: `rspec`, `factory_bot`, `shoulda-matchers` and `database-cleaner`

`pgcrypto` has [been enabled](https://github.com/labe/ab_voting_app/blob/main/db/migrate/20231219001747_enable_uuid.rb) to allow database tables to have `uuid`s as primary keys
*****

### Getting started

- Install dependencies: `$ bundle install`
- Create the db and run migrations: `$ rails db:setup`
- Start the server: `$ rails s` or `$ ./bin/dev`

*****

### Running tests

`$ rspec`

For a specific file: `$ rspec <path/to/spec>.rb`
For a specific test: `$ rspec <path/to/spec>.rb:<line number of test>`

*****

### Notes

Three basic models/tables have already been set up: `User`, `Candidate`, and `Vote`. Their associations to each other, as well as their attribute validations, are defined in the model files and covered in their respective model specs.

All three tables have `uuid` primary `id`s for enhanced security.
