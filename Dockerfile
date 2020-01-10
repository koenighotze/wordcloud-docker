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

ARG NAME=n/a
ARG CREATED=n/a
ARG TITLE=n/a
ARG SOURCE=n/a
ARG REVISION=n/a
ARG BUILD_URL=n/a

LABEL org.opencontainers.image.authors="David Schmitz / @Koenighotze"
LABEL org.opencontainers.image.name="${NAME}"
LABEL org.opencontainers.image.created="${CREATED}"
LABEL org.opencontainers.image.title="${TITLE}"
LABEL org.opencontainers.image.source="${SOURCE}"
LABEL org.opencontainers.image.revision="${REVISION}"
LABEL org.opencontainers.image.build_url="${BUILD_URL}"

ENV PATH="/home/python/venv/bin:$PATH"

ENTRYPOINT [ "/home/python/venv/bin/wordcloud_cli" ]
CMD ["--help"]

