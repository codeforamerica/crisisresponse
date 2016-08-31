# Crisis Response

[![Circle CI](https://circleci.com/gh/codeforamerica/crisisresponse.svg?style=svg&circle-token=3dbea1eed1c1d0e056ef0ceaeb0f54039facd079)](https://circleci.com/gh/codeforamerica/crisisresponse)

An internal tool to help the Seattle Police Department
respond to the needs of people in crisis.

## Background

The Seattle Police Department is engaging Code for America
to help develop software to divert individuals
with mental health and addiction issues
away from the criminal justice system
and connect them to health, housing, and social services.
In 2015, the Seattle police responded to 9,675 calls to 911
that involved a person
in a mental health and/or chemical dependency-related crisis.
Specialized crisis response officers review these incidents
and follow up with the most acute cases –
contacting the person's caseworker,
speaking to their family,
and connecting the individual with local services.
The Seattle police also train patrol officers
to respond to crisis calls
and to use de-escalation techniques
with citizens in crisis.

The Seattle fellowship team is working to develop an app
for patrol officers to use
during interactions with individuals in crisis.
Focused on tailored plans
for individuals who are frequently in contact with the police,
this tool will include information such as who to call
(family members, caseworker, etc.)
and specific action steps to help the person.

[See more about the project][more] or [get email updates][updates].

[more]: http://c4a-sea-2016.tumblr.com/
[updates]: http://codeforamerica.us13.list-manage.com/subscribe?u=6100a3c3b87484e2482c465f2&id=4f2ea46fa4

## Technical Notes

This should be everything you need to start the application from scratch.
If you run into any problems or obstacles,
please [open an issue] to help us improve the documentation.

[open an issue]: https://github.com/codeforamerica/crisisresponse/issues/new

### Dependencies

Because this application handles information
that is regulated by HIPAA and CJIS requirements,
it is built to be hosted on an internal police server
instead of on the cloud.
We use [Docker] to make it easy
to develop, package, and deploy the application
on any platform.

Before starting, install Docker ([mac], [windows], [linux]) and [Docker Compose].

After installing,
pull [the application image] from Docker Hub,
or build it yourself.
All of the dependencies are managed through Docker,
so there shouldn't be any problems running this script.
If you do encounter a problem, please [open an issue] to report it.

```bash
# Pull from Docker Hub
docker pull codeforamerica/crisisresponse
# Build the image locally
docker-compose build
```

[Docker]: https://www.docker.com/
[mac]: https://docs.docker.com/mac/
[windows]: https://docs.docker.com/windows/
[linux]: https://docs.docker.com/linux/
[Docker Compose]: https://docs.docker.com/compose/install/
[open an issue]: https://github.com/codeforamerica/crisisresponse
[the application image]: https://hub.docker.com/r/codeforamerica/crisisresponse/

### Starting the Application

Run the application with the command:

```bash
$ touch .env.local; rm tmp/pids/server.pid; docker-compose up
```

After running that command,
access the application by visiting http://localhost:3000

## Managing Application Lifecycle

```bash
# start by cloning the repository
git clone git@github.com:codeforamerica/crisisresponse.git

# To set up:
docker-compose build
docker-compose run web rake db:create db:migrate

# To run the server
docker-compose up

# After updating the `Dockerfile`:
docker-compose build

# Push a new docker image to Docker Hub:
docker-compose build && docker push codeforamerica/crisisresponse

# After updating the `Gemfile`:
docker-compose up

# To run the server
docker-compose up
```

### Running Tests

The application's tests are stored in the `spec/` directory,
and have the `_spec.rb` suffix.

Run the entire test suite with `./bin/test`,
or run an individual test file with `./bin/test spec/my/test/file.rb`.

## Importing Data from the SPD Record Management System

* Set the `RMS_PASSWORD`, `RMS_URL`, and `RMS_USERNAME` environment variables.
* run:

  ```bash
  app run --rm web rails c
  ```

* Inside the rails console, type:

  ```ruby
  require "rms_importer"
  RMSImporter.new.import
  ```

This will run for a while as it searches for updates
to all of the crisis incident records.
When it finishes,
check the log files that it wrote under `log/import`
for notes about unprocessable records,
skipped records,
or duplicate records.

## Backups

Backups are stored in the application root,
under the `backups/` subfolder.

```bash
# Create a backup of the database
docker-compose run --rm backup

# Restore a backup
docker-compose run --rm restore backups/2016-01-02_12:00:00.sql
```

## Development Guidelines

Use the following guides for
getting things done,
programming well,
and programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)
