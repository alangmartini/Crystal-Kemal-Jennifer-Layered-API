# Rick And Morty API

Code Chalenge

## Table of Contents
- [About The Project](#about-the-project)
    - [Built With](#built-with)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
- [Usage](#usage)
- [Roadmap](#roadmap)
- [Contact](#contact)
- [Structural Decisions](#structural-decisions)


## About The Project

API build for a Code Challenge from a job posting. It uses
[Crystal](https://crystal-lang.org/), a programming language with ruby-like sintax
and performance close to C.


### Built With
- Docker
- Docker Compose
- Crystal
- Jennifer
- Kemal

## Getting Started

### Prerequisites

To run the project, you need to have docker and docker-compose installed.

### Installation

Run the following command to start the project:

```
docker-compose up
```

**Note:** It will start the server on port 3000, check backend readme for endpoints.

## Usage

### Running tests

The file docker-compose.test.yml has all
setup for  running tests. It will create a new database for testing, and set the appropriate envs.

With server stopped:

```
docker-compose -f docker-compose.test.yml up --abort-on-container-exit
```

### Docs as HTML

Docs are fully completed! Run command below outside docker and go to http://localhost:8000/app/backend/docs

```
python3 -m http.server
```

### Benchmarks

Start the service and open the container with bash.

When inside run:

```
  crystal sam.cr benchmark
```

Or navigate to app/backend, install shards and run command:

```
  shards install
  crystal sam.cr benchmark
```

**note** If you want some memory data as well in Unix-like OS, run:

```
  /usr/bin/time -v crystal sam.cr benchmark
```

### To run Hiring Team tests

```
crystal run runtest
```

**Note:** There was a small mistake on runtest file, so I had to change the following line:

```
 rescue IO::EOFError
+ rescue IO::Error
```

Probably it was a breaking change on Crystal 0.35.1, or other versions, or is the error the crystal version in CI/CL will search for, but was breaking in crystal 1.8.2.


### Note

For all commands above, if running outside docker, you need to have crystal installed and set CRYSTAL_PATH env. (example in docker-compose 'enviroments').

## Roadmap

This was a project done for a Job Application Code Challenger, but here its some things that can be
greatly improved:

- Add more tests
- Create a flow Middleware > Client > Handler | Handler > Client > Response for  errors.
- Add threading to expensive operations and requisitions to Rick And Morty Api
- Move validations (like id and body) to middlewares and add more restrictions.
- Create a better algorithm for optimising.

## Contact

#### Alan Galvão martini
- [Linkedin](https://www.linkedin.com/in/alangmartini/)
- [Github](https://github.com/alangmartini/)
- [Email](gmartinialan@gmail.com)

## Structural Decisions

### Architecture

Inspired by Single Responsability Principle and Separation of Concerns, the project follows a Layered Architecture, where each layer has its own responsability and is not aware of the other layers.


- Routes: Responsible for defining routes of certain domain and invoking
    appropriate controllers.
- Controllers: Responsible for handling requests and responses.
- Services: Responsible for handling business logic.
- Models: Responsible for retrieving data from DB.

### OOP

The project also tries to implement OOP with SOLIDs principles. Most "things" in the project are either Entities, which represent a real entity, or Actions, which represent an action that can be performed.

### Importations

Each module or class has its own importations declared at the top of the its files.

Although it seems like a effort duplication, it facilitates unit testing. It also makes it easier to know which modules are being used.

#### Why absolute and not relative

With the frequent refactoring and folder structure changes, it was becoming messy to use relative importations.

### Class or Module

Found empiricately that using modules facilitates at lot the code organization, and allow for a better structured docs.

Con is that the variable and methods names get pretty large.