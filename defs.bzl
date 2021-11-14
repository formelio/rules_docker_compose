load("@bazel_tools//tools/build_defs/repo:http.bzl", _http_file = "http_file")

def setup_rules_docker_compose():
    _http_file(
        name = "docker_compose_v2.1.0_linux_amd64",
        executable = True,
        sha256 = "90990e7268e954e7930353650d7bcf5a37d29c77925ea2066335367b5f27ec9a",
        urls = ["https://github.com/docker/compose/releases/download/v2.1.0/docker-compose-linux-x86_64"],
    )

    _http_file(
        name = "docker_compose_v2.1.0_macos_amd64",
        executable = True,
        sha256 = "ce06797cc850b3d41f617bf3ed0abb3c46aace4b7d91e48aab185fe33141c635",
        urls = ["https://github.com/docker/compose/releases/download/v2.1.0/docker-compose-darwin-x86_64"],
    )

    _http_file(
        name = "docker_compose_v2.1.0_macos_arm64",
        executable = True,
        sha256 = "ad87ee0b00bc3218d425225c968f44e33b6bb993f002c3aad2696e9f1d36f9f6",
        urls = ["https://github.com/docker/compose/releases/download/v2.1.0/docker-compose-darwin-aarch64"],
    )

    native.register_toolchains(
        "@com_github_ivido_rules_docker_compose//toolchains/docker_compose:docker_compose_v2.1.0_linux_amd64_toolchain",
        "@com_github_ivido_rules_docker_compose//toolchains/docker_compose:docker_compose_v2.1.0_macos_amd64_toolchain",
        "@com_github_ivido_rules_docker_compose//toolchains/docker_compose:docker_compose_v2.1.0_macos_arm64_toolchain",
    )
