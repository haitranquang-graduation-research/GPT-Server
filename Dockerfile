FROM python:3.9.18

WORKDIR /model

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY start.sh start.sh

CMD [ "bash", "start.sh" ]