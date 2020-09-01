# Kata Containers CI scripts

* [Summary](#summary)
* [Script conventions](#script-conventions)

This directory contains scripts used by the [Kata Containers](https://github.com/kata-containers)
[CI (Continuous Integration) system](https://github.com/kata-containers/ci).

## Summary

> **WARNING:**
>
> You should **NOT** run any of these scripts until you have reviewed their
> contents and understood their usage. See
> https://github.com/kata-containers/tests#ci-setup for further details.

| Script(s) | Description |
| -- | -- |
| [`go-test.sh`](go-test.sh) | Central interface to the `golang` `go test` facility. |
| `install_*` | Install various parts of the system and dependencies. |
| [`jenkins_job_build.sh`](jenkins_job_build.sh) | Called by the [Jenkins CI](https://github.com/kata-containers/ci) to trigger a CI run. |
| [`kata-arch.sh`](kata-arch.sh) | Displays architecture name in various formats. |
| [`kata-doc-to-script.sh`](kata-doc-to-script.sh) | Convert a [GitHub-Flavoured Markdown](https://github.github.com/gfm) document to a shell script. |
| [`kata-find-stale-skips.sh`](kata-find-stale-skips.sh) | Find skipped tests that can be unskipped. |
| [`kata-simplify-log.sh`](kata-simplify-log.sh) | Simplify a logfile to make it easer to `diff(1)`. |
| [`lib.sh`](lib.sh) | Library of shell utilities used by other scripts. |
| [`run_metrics_PR_ci.sh`](run_metrics_PR_ci.sh) | Run various performance metrics on a PR. |
| [`run.sh`](run.sh) | Run the tests in a CI environment. |
| `setup_env_*.sh` | Distro-specific setup scripts. |
| [`setup.sh`](setup.sh) | Setup the CI environment. |
| [`static-checks.sh`](static-checks.sh) | Central static analysis script. |
| [`teardown.sh`](teardown.sh) | Tasks to run at the end of a CI run. |

| Directory | Description |
| -- | -- |
| [`openshift-ci`](openshift-ci) | Files for OpenShift CI |

## Script conventions

The `kata-*` scripts *might* be useful for users to run. These scripts support the
`-h` option to display their help text:

```
$ ./kata-doc-to-script.sh -h
```

> **Note:**
>
> See the warning in the [Summary](#summary) section before running any of
> these scripts.
