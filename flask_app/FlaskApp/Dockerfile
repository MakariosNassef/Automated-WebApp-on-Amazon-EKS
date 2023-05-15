FROM python:alpine3.18
EXPOSE 5002
WORKDIR /app
COPY requirements.txt /app
RUN apk update && apk add --no-cache build-base mysql-dev
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
COPY . /app
CMD python -m flask run --host=0.0.0.0 --port=5002