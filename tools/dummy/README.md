## Introduction
Dummy - is a lightweight container that executes dummy binary that does nothing.
You can use it whenever you need a dummy container.

## How to use it?
The idea is to create containers when necessary. But it is hard in Docker as there are no if statements. So the trick is to use environment variables and a dummy container.
Let's assume you need Mailcatcher. This is what your setup can look like:
1. Add Mailcatcher to docker-compose.yaml file:
```yaml
mailcatcher:
  build:
    context: .
    dockerfile: tools/mailcatcher/Dockerfile
    target: m2d_mailcatcher
    args:
      - M2D_ENABLE_MAILCATCHER=${M2D_ENABLE_MAILCATCHER:-no}
  container_name: magento2mailcatcher
  ports:
    - "${M2D_PORT_FOR_MAILCATCHER:-1080}:1080"
```
2. Add Dockerfile for Mailcatcher:
```Dockerfile
## set the default value for the argument if not defined
ARG M2D_ENABLE_MAILCATCHER='no'

## prepare a dummy container for the "no" option
FROM scratch as m2d_mailcatcher_no
COPY tools/dummy/dummy ./
CMD ["/dummy"]

## prepare the actual Mailcatcher container for the "yes" option
FROM schickling/mailcatcher AS m2d_mailcatcher_yes

## build target container from mailcatcher_yes or mailcatcher_no based on value from M2D_ENABLE_MAILCATCHER argument
FROM m2d_mailcatcher_${M2D_ENABLE_MAILCATCHER} AS m2d_mailcatcher
```
3. Set expected value for argument:
- in .env file:
```
M2D_ENABLE_MAILCATCHER=yes
```
- or in the terminal:
```bash
export M2D_ENABLE_MAILCATCHER=yes
```
4. Spin up the expected container:
```bash
docker-composer up -d --build
```

## Need more?
If you need a dummy container that is doing something (e.g., displaying hello world), you can modify the source code and recompile it with the following:
```bash
gcc -o tools/dummy/dummy tools/dummy/dummy.c
```