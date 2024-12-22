FROM ubuntu
RUN apt-get update
RUN apt-get install -y ldc gcc dub zlib1g-dev libssl-dev libphobos2-ldc-shared-dev
RUN rm -rf "/var/lib/apt/lists/*"
COPY . /tmp/d-snake
WORKDIR /tmp/d-snake
RUN dub -v build
COPY /tmp/d-snake/d-snake /
USER nobody
CMD ["/d-snake"]
