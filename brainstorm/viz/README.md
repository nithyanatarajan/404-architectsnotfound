## Installations

1. Install [uv](https://github.com/astral-sh/uv)

## Setup

### Virtual Environment Setup

```shell
uv venv  --allow-existing
source .venv/bin/activate
```

### Install Dependencies

```shell
uv pip sync requirements.lock
```

## Run

```shell
python view.py
```