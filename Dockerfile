FROM python:3.13-slim

# 安装系统依赖
RUN apt-get update && apt-get install -y pipx && rm -rf /var/lib/apt/lists/*
RUN pipx ensurepath

# 安装 poetry
RUN pipx install poetry

WORKDIR /app

# 先拷贝依赖文件，利用 Docker 缓存
COPY pyproject.toml poetry.lock* ./
RUN pipx run poetry install --no-root

# 拷贝代码
COPY todo todo

# 默认启动命令（去掉 sleep）
CMD ["pipx", "run", "poetry", "run", "flask", "--app", "todo", "run", "--host", "0.0.0.0", "--port", "6400"]