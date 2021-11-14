# Docker Compose Bazel rules

Bazel rules for using Docker Compose for local development. Currently only support `docker-compose up` with override files.

## Usage

Add the following to your WORKSPACE file

```
git_repository(
    name = "com_github_ivido_rules_docker_compose",
    commit = "c704111dafad803aaa03d68c41c9568923a26a45",
    remote = "https://github.com/ivido/rules_docker_compose.git",
    shallow_since = "1636919993 +0100",
)

load("@com_github_ivido_rules_docker_compose//:defs.bzl", "setup_rules_docker_compose")

setup_rules_docker_compose()
```

Then, in your Build files you can use the `docker_compose` macro. Here is an example:

```
load("@io_bazel_rules_docker//nodejs:image.bzl", "nodejs_image")
load("@com_github_ivido_rules_docker_compose//docker_compose:docker_compose.bzl", "docker_compose")

nodejs_image(
    name = "myapp",
    entry_point = "//path/to:file.js",
    ...
)

docker_compose(
    name = "myapp",
    # We use glob here because the override file might not exist
    compose_files = ["docker-compose.yml"] + glob(["docker-compose.override.yml"]),
    images = [":myapp"],
)
```

This rule will import the `:myapp` image into your local Docker registry. Your compose files should therefore use the name Bazel assigns to your image when it's imported. In this case `bazel:myapp`. Here's an example of what your compose file might look like:

```
version: '3'

services:
  myapp:
    image: bazel:myapp
```

To run your application, run `bazel run //:myapp.up`. This will build the image and run `docker-compose up`. Compose files are evaluated in the order in which they appear in `compose_files`, each one overriding values from the last.
