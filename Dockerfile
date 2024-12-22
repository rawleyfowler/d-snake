FROM ubuntu AS build
RUN apt-get update
RUN apt-get install -y ldc gcc dub zlib1g-dev libssl-dev
RUN rm -rf "/var/lib/apt/lists/*"
COPY . /tmp
WORKDIR /tmp
RUN dub -v build

# We could probably use Alpine... but not sure D support for packages there.
FROM ubuntu:latest
RUN rm -rf "/var/lib/apt/lists/*"
RUN apt-get update
RUN apt-get install -y libphobos2-ldc-shared-dev
COPY --from=build /tmp/d-snake /
USER nobody
CMD ["/d-snake"]
