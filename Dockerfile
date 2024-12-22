FROM ubuntu:24.04
RUN apt-get update
RUN apt-get install -y ldc gcc dub zlib1g-dev libssl-dev libphobos2-ldc-shared-dev pkg-config
RUN mkdir -p /tmp/d-snake
COPY . /tmp/d-snake
WORKDIR /tmp/d-snake
RUN dub -v build
RUN cp /tmp/d-snake/d-snake /
USER nobody
CMD ["/d-snake"]
