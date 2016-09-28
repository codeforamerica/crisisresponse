# RideAlong Response

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

Before starting, install Docker ([mac], [windows], [linux]).

#### Mac or Windows VM setup

If you are running Docker for the first time on OS X or Windows,
you'll need to [install docker-machine] and [VirtualBox],
then create a virtual machine:

```bash
$ docker-machine create --driver virtualbox default

# Add relevant environment variables to your shell
# (if you don't use bash, replace with `.zshrc`, `.profile`, etc.
$ cat 'eval $(docker-machine env)' >> ~/.bashrc && source ~/.bashrc

# Open up port 3000 between the host and the virtualbox machine
$ VBoxManage modifyvm "default" --natpf1 "guestnginx,tcp,,3000,,3000"
```

#### Confirm dependencies are installed correctly:

```bash
$ docker run --rm hello-world
# should print something like:

Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

[Docker]: https://www.docker.com/
[mac]: https://docs.docker.com/mac/
[windows]: https://docs.docker.com/windows/
[linux]: https://docs.docker.com/linux/
[install docker-machine]: https://docs.docker.com/machine/install-machine
[VirtualBox]: https://www.virtualbox.org/wiki/Downloads

## Running and Managing the Application

There are a few common commands to get you set up:

```bash
# start by cloning the repository
$ git clone git@github.com:codeforamerica/crisisresponse.git && cd crisisresponse

# Set up the app for development:
$ ./bin/setup

# Run the server
$ ./bin/docker-compose up
```

After those commands,
your application should be serving the site on port 3000.
Open <http://localhost:3000> in your web browser to see the site.

There are a few more commands
that you'll need after you change the application's dependencies:

```bash
# After updating the `Dockerfile` or `Gemfile`,
# you'll need to rebuild the application container.
$ ./bin/docker-compose build

# Push a new docker image to Docker Hub:
$ ./bin/docker-compose build && docker push codeforamerica/crisisresponse
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
  $ ./bin/docker-compose run --rm web rails c
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
$ ./bin/docker-compose run --rm backup

# Restore a backup
$ ./bin/docker-compose run --rm restore backups/2016-01-02_12:00:00.sql
```

## Development Guidelines

Use the following guides for
getting things done,
programming well,
and programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)
