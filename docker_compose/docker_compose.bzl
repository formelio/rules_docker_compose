def _docker_compose_up_impl(ctx):
    """
    Runs docker-compose up for an application

    Args:
        name            : The name for this rule
        compose_files   : List of compose files to use for configuration. Files are
                          evaluated in order, each one overriding the last. Override
                          files should therefore be included.
        images          : Images the services depend on.
    """
    compose_binaries = ctx.toolchains["@com_github_ivido_rules_docker_compose//toolchains/docker_compose:toolchain_type"].info.tool.files.to_list()
    compose_path = compose_binaries[0].path

    docker_path = ctx.toolchains["@io_bazel_rules_docker//toolchains/docker:toolchain_type"].info.tool_path

    image_files = ctx.files.images
    compose_files = ctx.files.compose_files

    args = []
    for compose_file in compose_files:
        args.append("-f")
        args.append(compose_file.short_path)

    image_file_paths = [image_file.short_path for image_file in image_files]

    executable = ctx.actions.declare_file(ctx.attr.name + ".sh")

    ctx.actions.expand_template(
        template = ctx.file._template,
        output = executable,
        substitutions = {
            "%{compose_args}": " ".join(args),
            "%{compose_binary}": compose_path,
            "%{docker_binary}": docker_path,
            "%{image_files}": ",".join(image_file_paths),
        },
        is_executable = True,
    )

    return [
        DefaultInfo(
            executable = executable,
            runfiles = ctx.runfiles(compose_binaries + compose_files + image_files),
        ),
    ]

_docker_compose_up = rule(
    implementation = _docker_compose_up_impl,
    attrs = {
        "compose_files": attr.label_list(
            allow_files = True,
            allow_empty = False,
            doc = "Compose files. This should include any overrides. Evaluated in order.",
        ),
        "images": attr.label_list(
            allow_files = True,
            allow_empty = False,
        ),
        "_template": attr.label(
            allow_single_file = True,
            default = ":up.sh.tpl",
        ),
    },
    executable = True,
    toolchains = [
        "@com_github_ivido_rules_docker_compose//toolchains/docker_compose:toolchain_type",
        "@io_bazel_rules_docker//toolchains/docker:toolchain_type",
    ],
)

def docker_compose(name, images, **kwargs):
    _docker_compose_up(
        name = name + ".up",
        images = [image + ".tar" for image in images],
        **kwargs
    )
