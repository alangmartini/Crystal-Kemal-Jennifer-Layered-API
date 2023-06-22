# Commands

To run the project, you need to have docker and docker-compose installed.

Run the following command:

```bash
docker-compose up
``` 

**Note:** It will start the server on port 3000. If you want to run tests, you need to stop the server and run the following command:

```bash
docker-compose down
```

```bash
docker-compose -f docker-compose.test.yml up --abort-on-container-exit
```

## To run Hiring Team tests

```bash
crystal run runtest
```

**Note:** There was a small mistake on runtest file, so I had to change the following line:

```bash
- rescue IO::EOFError
+ rescue IO::Error
```

Probably it was a breaking change on Crystal 0.35.1, or other versions.
