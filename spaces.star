"""
Checkout llvm, cmake, and ninja for a complete build system and toolchain.
"""

load("//@star/sdk/star/spaces-env.star", "spaces_working_env")
load("//@star/sdk/star/cmake.star", "cmake_add_configure_build_install")
load("//@star/sdk/star/shell.star", "ls")
load("//@star/packages/star/llvm.star", "llvm_add")
load("//@star/packages/star/cmake.star", "cmake_add")
load("//@star/packages/star/package.star", "package_add")
load(
    "//@star/sdk/star/checkout.star",
    "checkout_add_asset",
)
load(
    "//@star/sdk/star/run.star",
    "RUN_LOG_LEVEL_APP",
    "RUN_TYPE_ALL",
    "run_add_exec",
)
load("//@star/sdk/star/info.star", "info_set_minimum_version")

info_set_minimum_version("0.15.4")

cmake_add("cmake3", "v3.30.5")
package_add("github.com", "ninja-build", "ninja", "v1.12.1")

llvm_add(
    "llvm19",
    version = "llvmorg-19.1.3",
    toolchain_name = "llvm-19-toolchain.cmake",
)

# basic spaces environment - adds /usr/bin and /bin to PATH
spaces_working_env(add_spaces_to_sysroot=True,inherit_terminal=True)

cmake_add_configure_build_install(
    "cpp",
    source_directory = "rust-cpp-showdown/cpp",
    skip_install = True,
)

run_add_exec(
    "run",
    type = RUN_TYPE_ALL,
    deps = ["cpp"],
    help = "Run the build/hello binary",
    log_level = "Passthrough",
    command = "build/cpp/cpp",
)
