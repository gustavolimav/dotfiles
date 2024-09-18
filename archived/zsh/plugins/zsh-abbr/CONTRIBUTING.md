# Contributing

Thanks for your interest. Contributions are welcome!

> Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Check the [Issues](https://github.com/olets/zsh-abbr/issues) to see if your topic has been discussed before or if it is being worked on. You may also want to check the roadmap (see above). Discussing in an Issue before opening a Pull Request means future contributors only have to search in one place.

This project loosely follows the [Angular commit message conventions](https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit). This helps with searchability and with the changelog, which is generated automatically and touched up by hand only if necessary. Use the commit message format `<type>(<scope>): <subject>`, where `<type>` is **feat** for new or changed behavior, **fix** for fixes, **docs** for documentation, **style** for under the hood changes related to for example zshisms, **refactor** for other refactors, **test** for tests, or **chore** chore for general maintenance (this will be used primarily by maintainers not contributors, for example for version bumps). `<scope>` is more loosely defined. Look at the [commit history](https://github.com/olets/zsh-abbr/commits/master) for ideas.

The test suite uses [zsh-test-runner](https://github.com/olets/zsh-test-runner). Run with test suite with

```shell
. ./tests/abbr.ztr
```

## Maintainers

To cut a new release:

1. Check out the `main` branch.
1. Update all instances of the version number in `zsh-abbr.zsh`.
1. Update all instances of the release date in `zsh-abbr.zsh`.
1. Update all instances of the version number in `man/man1/abbr.1`.
1. Update all instances of the release date in `man/man1/abbr.1`.
1. Update all instances of the version number in `completions/_abbr`.
1. Run `bin/changelog`.
1. Update the first line of `CHANGELOG.md`: add the new version number twice:
    ```
    # [<HERE>](…vPrevious...v<AND HERE>) (…)
    ```
1. Commit `CHANGELOG.md`, `zsh-abbr.zsh`, `man/man1/abbr.1`, and `completions/_abbr`.
    ```shell
    git commit -i CHANGELOG.md completions/_abbr man/man1/abbr.1 zsh-abbr.zsh -m "feat(release): bump to %ABBR_CURSOR%, update changelog"
    ```
1. Create a signed commit with the version number, prefixed with `v`.
    ```shell
    git tag -s %ABBR_CURSOR% -m %ABBR_CURSOR%
    ```
1. If possible to fast-forward `next` to `main`, do so. If it isn't, rebase/merge/etc as needed to have `next` fork off the tip of `main`.
1. Fast-forward the major-version branch (e.g. branch `v5`) to `main`.
1. Push `main`, the tag, `next`, the major version branch, and any branches rewritten in the process of bringing `next` up to `main`.
1. In GitHub, publish a new release. https://github.com/olets/zsh-abbr/releases/new. A GitHub Actions workflow will automatically update the Homebrew formula.
