setup() {
  docker history registry.docker/alpine:3.2 >/dev/null 2>&1
}

@test "version is correct" {
  run /bin/sh -c "docker run registry.docker/alpine:3.2 cat /etc/os-release 2>/dev/null"
  [ $status -eq 0 ]
  [ "${lines[2]}" = "VERSION_ID=3.2.3" ]
}

@test "package installs cleanly" {
  run docker run registry.docker/alpine:3.2 apk add --update openssl
  [ $status -eq 0 ]
}

@test "timezone" {
  run /bin/sh -c "docker run registry.docker/alpine:3.2 date +%Z 2>/dev/null"
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "apk-install script should be available" {
  run docker run registry.docker/alpine:3.2 which apk-install
  [ $status -eq 0 ]
}

@test "repository list is correct" {
  run /bin/sh -c "docker run registry.docker/alpine:3.2 cat /etc/apk/repositories 2>/dev/null"
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://dl-4.alpinelinux.org/alpine/v3.2/main" ]
}

@test "cache is empty" {
  run /bin/sh -c "docker run registry.docker/alpine:3.2 sh -c 'ls -1 /var/cache/apk | wc -l' 2>/dev/null"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}
