# Rick And Morty API

## Table of Contents
- [About The Project](#about-the-project)
    - [Built With](#built-with)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
- [Usage](#usage)
  - [Running tests](#running-tests)
  - [Docs as HTML](#docs-as-html)
  - [Benchmarks](#benchmarks)
  - [To run Hiring Team tests](#to-run-hiring-team-tests)
  - [Entering in dev mode](#entering-in-dev-mode)
  - [Note](#note)
- [API](#api)
  - [Travel Plans](#travel-plans)
    - [GET /travel_plans/:id](#get-travel_plansid)
    - [GET /travel_plans/](#get-travel_plans)
    - [POST /travel_plans](#post-travel_plans)
    - [PUT /travel_plans/:id](#put-travel_plansid)
    - [DELETE /travel_plans/:id](#delete-travel_plansid)
- [DB](#db)
- [Roadmap](#roadmap)
- [Contact](#contact)
- [Structural Decisions](#structural-decisions)


## About The Project

API build for a Code Challenge from a job posting. It uses
[Crystal](https://crystal-lang.org/), a programming language with ruby-like sintax
and performance close to C.

It was developed using TDD principles and OOP. Trying my best to apply
SOLID principles and Clean Code in a Layered Architecture. Contains Unit and E2E tests.

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

<details>
  <summary>Others</summary>

</details>

### To run Hiring Team tests
Runtest run "docker-compose up", so make sure you're outside a docker container and dont have any service up.

```
crystal run runtest
```

**Note:** There was a small mistake on runtest file, so I had to change the following line:

```
 rescue IO::EOFError
+ rescue IO::Error
```

Probably it was a breaking change on Crystal 0.35.1, or other versions, or is the error the crystal version in CI/CL will search for, but was breaking in crystal 1.8.2.

### Entering in dev mode

To facilitate developing and looking around, development mode is available. It will simply start the container and you can attach and run the commands from inside, with db (in test mode for now) and all envs already set up.


```bash
  docker-compose -f docker-compose.dev.yml up
```

### Note

For any command that has to be run inside docker, is better if run in dev mode, since test and prod will run the server on start.Ex: benchmarks bellow.

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

## API

This API allows you to manage travel plans. The following endpoints are available:

### Travel Plans

#### `GET /travel_plans/:id`

Retrieves a specific travel plan. You can provide the following options as query parameters:

- `optimise=true`: Optimises the travel stops according to the following rules:
  1. Every stop from the same dimension must be grouped.
  2. Inside a same dimension, the stops must be ordered in ascending order of popularity.
  3. If the popularity is the same, then order by name.
  4. The order of visit of the dimensions is defined by the average of their total populations.

- `expand=true`: Brings information on travel stop name, dimension, and type.

<details>
  <summary>Response</summary>

```json
{
  "id": 1,
  "travel_stops": [1, 2]
}
```
</details>

<details>
  <summary>Response Expanded</summary>

```json
{ 
  "id": 1,
  "travel_stops": [
    {
      "id": 1,
      "dimension": "Dimension C-137",
      "name": "Earth (C-137)",
      "type": "Planet"
    },
    {
      "id": 2,
      "dimension": "unknown",
      "name": "Abadango",
      "type": "Cluster"
    }
  ]
}
```
</details>

#### `GET /travel_plans`

Retrieves a list of all travel plans.

- `optimise=true`
- `expand=true`

<details>
  <summary>Response</summary>

```json
[
  { 
    "id": 1,
    "travel_stops": [1, 2]
  },
  { 
    "id": 2,
    "travel_stops": [10, 3]
  }
]
```
</details>


#### `POST /travel_plans`

Creates a new travel plan.

<details>
  <summary>Request body:</summary>

```json
{
  "travel_stops": [1, 2]
}
```
</details>

<details>
  <summary>Response</summary>

```json
{ 
  "id": created_travel_plan_id,
  "travel_stops": [1, 2]
}
```
</details>

#### `PUT /travel_plans/:id`

Updates a specific travel plan.

<details>
  <summary>Request body:</summary>

```json
{
  "travel_stops": [1, 2]
}
```
</details>

<details>
  <summary>Response</summary>

```json
{ 
  "id": :id,
  "travel_stops": [1, 2]
}
```
</details>

#### `DELETE /travel_plans/:id`

Deletes a specific travel plan.

## DB

The project uses a MySQL database, with [Jennifer](https://github.com/imdrasil/jennifer.cr) as ORM

![](app/backend/misc/mysql_table.png)


## Roadmap

This was a project done for a Job Application Code Challenger, but here its some things that can be
greatly improved:

- Add more tests
- Create a flow Middleware > Client > Handler | Handler > Client > Response for  errors.
- Add threading to expensive operations and requisitions to Rick And Morty Api
- Move validations (like id and body) to middlewares and add more restrictions.
- Create a better algorithm for optimising.

- Make the design more decoupled, so it can be more easily changed and easier
 to add new features and create unit tests.

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
