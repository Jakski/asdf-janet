# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test janet https://github.com/Jakski/asdf-janet.git "janet -v"
```

Tests are automatically run in GitHub Actions on push and PR.
