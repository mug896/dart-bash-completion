
_dart() 
{
    local CMD=$1 CUR=${COMP_WORDS[COMP_CWORD]}
    [[ ${COMP_LINE:COMP_POINT-1:1} = " " ]] && CUR=""
    local IFS=$' \t\n' WORDS
    local SED_CMD='sed -En '\''/^Available (sub)?commands:/,${ s/^  ([^[:blank:]]+).*/\1/p }'\'
    local SED_OPT='sed -En -e '\''s/^ *((-\w), )?(-[^[:blank:]<]+).*/\2\n\3/; tX; b'\'' \
                    -e '\'':X s/\[|\]//g; p; tY; b'\'' -e '\'':Y s/no-//p'\'

    if [[ $CUR == -* ]]; then
        if WORDS=$( eval "${COMP_LINE% *} --help" 2>&1 ); then
            WORDS=$( echo "$WORDS" | eval "$SED_OPT" )
        else
            echo; echo "$WORDS" | head -n1 >&2
            return
        fi
    else
        if (( COMP_CWORD == 1 )); then
            WORDS=$( $CMD --help | eval "$SED_CMD" )
        else
            if WORDS=$( eval "${COMP_LINE% *} --help" 2>&1 ); then
                WORDS=$( echo "$WORDS" | eval "$SED_CMD" )
            else
                echo; echo "$WORDS" | head -n1 >&2
                return
            fi
        fi
    fi
    COMPREPLY=( $(compgen -W "$WORDS" -- "$CUR") )
    [ "${COMPREPLY: -1}" = "=" ] && compopt -o nospace
}

complete -o default -o bashdefault -F _dart dart flutter

