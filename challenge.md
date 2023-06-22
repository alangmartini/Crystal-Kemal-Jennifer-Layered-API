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
