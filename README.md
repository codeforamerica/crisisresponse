# RideAlong Response

[![Circle CI](https://circleci.com/gh/codeforamerica/crisisresponse.svg?style=svg&circle-token=3dbea1eed1c1d0e056ef0ceaeb0f54039facd079)](https://circleci.com/gh/codeforamerica/crisisresponse)

## Contents

* [Background](#background)
* [Installation](#installation)
  * [Dependencies](#dependencies)
  * [Configuring the Application](#configuring-the-application)
  * [Setting up a Development Machine](#setting-up-a-development-machine)
  * [Setting up a Production Server](#setting-up-a-production-server)
* [Development](#development)
  * [Running Tests](#running-tests)
  * [Building the Docker Image](#building-the-docker-image)

## Background

The Seattle Police Department engaged Code for America
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

[See more about the project][more].

[more]: http://c4a-sea-2016.tumblr.com/

## Installation

This should be everything you need to start the application from scratch.
If you run into any problems or obstacles,
please [open an issue] to help us improve the documentation.

[open an issue]: https://github.com/codeforamerica/crisisresponse/issues/new

### Dependencies

Because this application handles information
that is regulated by [HIPAA] and [CJIS] requirements,
it is built to be hosted on an internal police server
instead of on the cloud.
We use [Docker] to make it easy
to develop, package, and deploy the application on any platform.

Whether you're working in development or hosting on production,
the only requirement for the application is that you [install Docker].

[HIPAA]: https://en.wikipedia.org/wiki/Health_Insurance_Portability_and_Accountability_Act
[CJIS]: https://www.fbi.gov/services/cjis
[Docker]: https://docker.com/
[install Docker]: https://github.com/codeforamerica/howto/blob/master/Docker.md

### Configuring the Application

The application requires two custom files in order to run properly.

* `.env` defines configuration variables for the application
* `bin/serve` defines the processes to spin up when the application starts

Each of these files has corresponding sample configurations,
in `.sample.env` and `bin/serve.dev`.
The `./bin/setup` script will copy the sample files into place
if they don't exist, to provide a sample configuration.

See the sections on [setting up a production server](#setting-up-a-production-server)
or [setting up a development machine](#setting-up-a-development-machine)
for details on how to set up the configurations.

The variables defined in `.env` can be sensitive,
like database credentials for the Records Management System,
the variables cannot be stored in the project's git repository.
Instead, the `.env` file is ignored from git and a `.sample.env` file
is included to demonstrate the expected structure of the file.

All of the variables that can be set are shown in [`.sample.env`],
along with explanations of their functions.
At the least, you'll have to provide real values for:

* `GOOGLE_MAPS_API_KEY`
* `KEEN_PROJECT_ID`
* `KEEN_WRITE_KEY`
* `PERMITTED_USERNAME_OVERRIDES`
* `LDAP_WHITELIST_GROUP`
* `LDAP_HOST`
* `LDAP_NAMESPACE`
* `LDAP_PORT`
* `RMS_PASSWORD`
* `RMS_USERNAME`
* `SECRET_KEY_BASE`

If you fail to provide any environment variables,
the application may fail in unpredictable ways.
It is important that you understand and set the variables correctly.

When you run the [`bin/setup`] script,
`.sample.env` is copied to `.env`
to provide a starting point for your application configuration.

[`.sample.env`]: .sample.env
[`bin/setup`]: bin/setup

### Setting up a Development Machine

The application is managed through the `docker-compose` tool.
A full reference is available at https://docs.docker.com/compose/reference/,
but you can accomplish most tasks with a few commands:

```bash
# start by cloning the repository
$ git clone git@github.com:codeforamerica/crisisresponse.git && cd crisisresponse

# Set up the app for development:
$ ./bin/setup

# Run the server
$ ./bin/docker-compose up

# Stop the server
$ ./bin/docker-compose stop

# Connect to the database through the Rails Console
# See http://railsonedge.blogspot.com/2008/05/intro-to-rails-console.html
$ ./bin/docker-compose run --rm web rails c

# Connect to the database with a Postgres database connection
$ ./bin/docker-compose run --rm backup psql -h db -U postgres -d crisisresponse_development
```

After those commands,
your application should be serving the site on the port specified in `.env`.
Open <http://localhost:3000> (replacing 3000 with the relevant port)
in your web browser to see the site.

### Setting up a Production Server

To deploy to production,
set up a machine with Docker installed and follow the steps above.
Be sure to set these values in `.env`:

```
RAILS_ENV=production
RACK_ENV=production
PORT=443
```

To keep the server running when you log off,
tell Docker to run the process as a daemon.

```bash
# Run the server as a background daemon
# See other usage documentation at https://docs.docker.com/compose/reference/up/
$ ./bin/docker-compose up -d
```

To update the deploy after code changes,
run:

```bash
# Pull new code changes from GitHub,
# Migrate the database,
# and restart the server
$ ./bin/docker-compose stop &&\
  git pull &&\
  ./bin/docker-compose run --rm web rake db:migrate &&\
  ./bin/docker-compose up -d
```

## Development

### Running Tests

The application's tests are stored in the `spec/` directory,
and have the `_spec.rb` suffix.

Run the entire test suite with `./bin/test`,
or run an individual test file with `./bin/test spec/my/test/file.rb`.

### Building the Docker image

```bash
# After updating the `Dockerfile` or `Gemfile`,
# you'll need to rebuild the application container.
$ ./bin/docker-compose build

# Push a new docker image to Docker Hub:
$ ./bin/docker-compose build && docker push codeforamerica/crisisresponse
```
