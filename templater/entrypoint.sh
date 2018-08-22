#!/bin/ash

if [ -z "${1+x}" ]; then
	cat <<EOM

Usage: [SOURCE_PATTERN] [TARGET_DIRECTORY]

    This script will validate substitutions and substitute environment variables in static files.
        - https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html

    This can process a single file, or a directory of files.

    The variable names must consist solely of alphanumeric or underscore ASCII characters,
        not start with a digit and be nonempty; otherwise such a variable reference is ignored.

EOM
	exit 2
fi

PATTERN="${1}"
TARGET="${2}"

function parse_template {
    SOURCE="${1}"
    SUBS=$(awk -F"[\${}]" '{print $3}' "${SOURCE}" | sort -u)
    echo "${SOURCE} has ${SUBS}"
    UNMATCHED=''
    for sub in ${SUBS}; do
        VAL_NAME=$(echo "${sub}" | sed 's/[^a-zA-Z0-9_]//g')
        value=$(eval echo "\$${VAL_NAME}")
        if [[ -z "${value// }" ]]; then
            UNMATCHED=$(echo -e "${UNMATCHED} ${sub}\n")
        fi
    done

    if [ ${#UNMATCHED[@]} -eq 0 ]; then
        FILENAME=$(basename ${SOURCE})
    else
        echo -e "Not all substitutions are set: ${UNMATCHED}" 1>&2;
    fi

    envsubst < ${SOURCE} > ${TARGET}/$FILENAME && echo "generated ${TARGET}/$FILENAME"
}

for filename in ${PATTERN}; do
    parse_template $filename
done
