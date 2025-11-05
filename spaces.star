"""
Checkout llvm, cmake, and ninja for a complete build system and toolchain.
"""

load("//@star/sdk/star/spaces-env.star", "spaces_working_env")
load("//@star/sdk/star/cmake.star", "cmake_add_configure_build_install")
load("//@star/sdk/star/shell.star", "ls")
load("//@star/packages/star/llvm.star", "llvm_add")
load("//@star/packages/star/rust.star", "rust_add")
load("//@star/packages/star/cmake.star", "cmake_add")
load("//@star/packages/star/buildifier.star", "buildifier_add")
load("//@star/packages/star/starship.star", "starship_add_bash")
load("//@star/packages/star/package.star", "package_add")
load(
    "//@star/sdk/star/checkout.star",
    "checkout_add_asset",
    "checkout_update_asset",
)
load(
    "//@star/sdk/star/run.star",
    "run_add_target",
    "RUN_LOG_LEVEL_APP",
    "RUN_TYPE_ALL",
    "run_add_exec",
)
load("//@star/sdk/star/info.star", "info_set_minimum_version", "info_get_path_to_store")
load("//@star/sdk/star/ws.star", "workspace_get_absolute_path")

info_set_minimum_version("0.15.4")

cmake_add("cmake3", "v3.30.5")
package_add("github.com", "ninja-build", "ninja", "v1.12.1")
rust_add("rust1", "1.90")
buildifier_add("buildifier8", "v8.2.1")

llvm_add(
    "llvm19",
    version = "llvmorg-19.1.3",
    toolchain_name = "llvm-19-toolchain.cmake",
)

# basic spaces environment - adds /usr/bin and /bin to PATH
spaces_working_env(add_spaces_to_sysroot=True, inherit_terminal=True)

starship_add_bash("starship_bash", shortcuts = {})

checkout_update_asset(
    "zed_settings",
    destination = ".zed/settings.json",
    value = {
        "lsp": {
            "clangd": {
                "binary": {
                    "path": "{}/sysroot/bin/clangd".format(workspace_get_absolute_path()),
                    "arguments": [
                        "--compile-commands-dir=build/cpp",
                        "--query-driver=**usr/bin/**"
                    ]
                }
            }
        },
        "languages": {
            "Starlark": {
                "language_servers": ["!buck2-lsp", "!starpls", "!tilt"],
                "tab_size": 4
            }
        }
    },
)


cmake_add_configure_build_install(
    "cpp",
    source_directory = "rust-cpp-showdown/cpp",
    skip_install = True,
)

run_add_exec(
    "build_rust",
    command = "cargo",
    args = ["build"],
    help = "Run the build/hello binary",
    working_directory = "./rust"
)

run_add_exec(
    "run_rust",
    command = "target/debug/rust",
    help = "Run the build/hello binary",
    log_level = "Passthrough",
    deps = ["build_rust"],
    working_directory = "./rust"
)


run_add_exec(
    "run_cpp",
    deps = ["cpp"],
    help = "Run the build/hello binary",
    log_level = "Passthrough",
    command = "build/cpp/cpp",
)

run_add_target(
    "run",
    deps = ["run_cpp", "run_rust"],
    type = RUN_TYPE_ALL,
)
