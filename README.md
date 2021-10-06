<div align="center">

# asdf-janet [![Build](https://github.com/Jakski/asdf-janet/actions/workflows/build.yml/badge.svg)](https://github.com/Jakski/asdf-janet/actions/workflows/build.yml) [![Lint](https://github.com/Jakski/asdf-janet/actions/workflows/lint.yml/badge.svg)](https://github.com/Jakski/asdf-janet/actions/workflows/lint.yml)


[janet](https://janet-lang.org/docs/index.html) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add janet
# or
asdf plugin add janet https://github.com/Jakski/asdf-janet.git
```

janet:

```shell
# Show all installable versions
asdf list-all janet

# Install specific version
asdf install janet latest

# Set a version globally (on your ~/.tool-versions file)
asdf global janet latest

# Now janet commands are available
janet -v
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/Jakski/asdf-janet/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Jakub Pieńkowski](https://github.com/Jakski/)
