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

This project uses [Docker] to make it easy
to develop, package, and deploy on any platform.

Before starting, install Docker.
Their website has instructions for [mac], [windows], and [linux].

After installing Docker,
run this script to set up your development environment.
All of the dependencies are managed through Docker,
so there shouldn't be any problems running this script.
If you do encounter a problem, please [open an issue] to report it.

    % ./bin/setup

[Docker]: https://www.docker.com/
[mac]: https://docs.docker.com/mac/
[windows]: https://docs.docker.com/windows/
[linux]: https://docs.docker.com/linux/
[open an issue]: https://github.com/codeforamerica/crisisresponse

### External Connections

At the moment, the application makes no connections to external services.

Eventually, we expect the application to pull data
from the internal SPD database that powers the Records Management System (RMS).

### Running Tests

Currently, the application has no tests.

Once we move out of the initial phase, we will introduce an automated test suite
that can be used to make sure the application is functioning correctly.

### Starting the Application

With `docker-compose` installed, you can run the application with the command:

```bash
$ docker-compose up
```

After running that command,
access the application by visiting http://localhost:8080

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)




## Docker commands

```bash
# start by cloning the repository
git clone git@github.com:codeforamerica/crisisresponse.git

# For the first run:
docker-compose build
# After updating the `Dockerfile`:
docker-compose build
# When packaging up code for the production environment:
docker-compose build && docker save crisis_web > build/crisis.tar


# After updating the `Gemfile`:
docker-compose up
# To run the server
docker-compose up
```
