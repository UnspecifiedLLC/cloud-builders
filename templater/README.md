# Templater

Lightweight container that will evaluate environment variable substitution in static files.
**Utilizes [envsubst](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)**

```bash
$ docker run --rm gcr.io/cloud-builders-un-life/templater

Usage: [SOURCE_PATTERN] [TARGET_DIRECTORY]

    This script will validate substitutions and substitute environment variables in static files.
        - https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html

    This can process a signle file, or a directory of files.

    The variable names must consist solely of alphanumeric or underscore ASCII characters,
        not start with a digit and be nonempty; otherwise such a variable reference is ignored.
  ```