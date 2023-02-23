FROM python:alpine3.16

WORKDIR /app

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV USER_NAME=foobar

COPY ./requirements.txt requirements.txt
COPY ./templates templates
COPY ./app.py app.py

RUN pip install -r requirements.txt
EXPOSE 5000

CMD [ "flask", "run" ]
