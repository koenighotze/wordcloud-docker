FROM python:3.8-slim AS build-env
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc
RUN adduser python -q
USER python

RUN python -m venv /home/python/venv
ENV PATH="/home/python/venv/bin:$PATH"

COPY req.txt ./
RUN pip install -r ./req.txt

FROM python:3.8-slim
RUN adduser tagcloud -q
WORKDIR /home/tagcloud
USER tagcloud

COPY --from=build-env /home/python/venv /home/python/venv

ENV PATH="/home/python/venv/bin:$PATH"

ENTRYPOINT [ "/home/python/venv/bin/wordcloud_cli" ]
CMD ["--help"]

