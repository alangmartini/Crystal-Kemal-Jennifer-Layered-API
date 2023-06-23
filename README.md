# Commands

## **Starting project**

To run the project, you need to have docker and docker-compose installed.

Run the following command:

```bash
docker-compose up
``` 

**Note:** It will start the server on port 3000.

## **Running unit and integration tests**
With server stopped:

```bash
docker-compose -f docker-compose.test.yml up --abort-on-container-exit
```

## **Docs as HTML**

```bash
python3 -m http.server
```
and open http://localhost:8000/docs
** or check a bit more down here **

## **Benchmarks**

Start the service and open the container with bash.

When inside run:

```
  crystal sam.cr benchmark
```

Or navigate to app/backend, install shards and run command:

```
  shards install
```

```
  crystal sam.cr benchmark
```

**note** If you want some memory data as well in Unix-like OS, run:

```
  /usr/bin/time -v crystal sam.cr benchmark
```

## **To run Hiring Team tests**

```bash
crystal run runtest
```

**Note:** There was a small mistake on runtest file, so I had to change the following line:

```bash
- rescue IO::EOFError
+ rescue IO::Error
```

Probably it was a breaking change on Crystal 0.35.1, or other versions.

# Architecture

Inspired by Single Responsability Principle and Separation of Concerns,
the project follows a Layered Architecture, where each layer has its own
responsability and is not aware of the other layers.

Where:

Routes: Responsible for defining routes of certain domain and invoking
    appropriate controllers.
Controllers: Responsible for handling requests and responses.
Services: Responsible for handling business logic.
Models: Responsible for retrieving data from DB.

## OOP

The project also tries to implement OOP with SOLIDs principles. Most
"things" in the project are either Entities, which represent a real
entity, or Actions, which represent an action that can be performed.

