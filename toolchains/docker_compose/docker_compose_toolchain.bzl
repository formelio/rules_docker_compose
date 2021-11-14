DockerComposeInfo = provider(
    doc = "Docker Compose toolchain",
    fields = {
        "docker_compose_version": "Docker Compose version (>=2.0.0)",
        "tool": "Docker Compose executable binary",
    },
)

def _docker_compose_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        info = DockerComposeInfo(
            docker_compose_version = ctx.attr.docker_compose_version,
            tool = ctx.attr.tool,
        ),
    )

    return [toolchain_info]

docker_compose_toolchain = rule(
    implementation = _docker_compose_toolchain_impl,
    attrs = {
        "docker_compose_version": attr.string(),
        "tool": attr.label(allow_single_file = True),
    },
)
