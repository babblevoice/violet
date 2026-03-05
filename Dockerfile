FROM alpine:3.23 AS builder

RUN apk update --no-cache; \
    apk add --no-cache cmake make gcc musl-dev;

WORKDIR /usr/src/violet
COPY . .

RUN cmake -B build -DCMAKE_BUILD_TYPE=Release; \
    cd build; \
    make -j2

FROM alpine:3.23 AS app

RUN apk update --no-cache; \
    apk add --no-cache musl;

COPY --from=builder /usr/src/violet/build/violet /usr/local/bin/

ENTRYPOINT [ "/usr/local/bin/violet" ]