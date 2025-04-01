## Setup

1. Install [Colima](https://github.com/abiosoft/colima)

## Run structurizr

1. Start colima
```shell
colima start --network-address
```

2. Run structurizr lite
```shell
docker run -it --rm -p 8080:8080 -v $PWD/data:/usr/local/structurizr structurizr/lite
```