FROM python:3.10.6

WORKDIR /var/www/html
COPY ./python/requirements.txt .
RUN pip install --upgrade cython
Run --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

COPY python .

ENV FLASK_APP ConvertToJsonApi.py
ENV FLASK_ENV development
ENV FLASK_RUN_PORT 5000
ENV FLASK_RUN_HOST 0.0.0.0

EXPOSE 5000

CMD ["flask", "run"]