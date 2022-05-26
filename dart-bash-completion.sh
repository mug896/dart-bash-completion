
_dart() 
{
    local COM=${COMP_WORDS[0]}
    local CUR=${COMP_WORDS[COMP_CWORD]}
    local IFS=$' \t\n' WORDS
    local SED_COM='sed -En '\''/^Available (sub)?commands:/,${ s/^  ([^[:blank:]]+).*/\1/p }'\'
    local SED_OPT='sed -En -e '\''s/^... (--[^[:blank:]<]+).*/\1/; tX; b'\'' -e '\'':X s/\[|\]//g; p; tY; b'\'' -e '\'':Y s/no-//p'\'

    if [ "${CUR:0:1}" = "-" ]; then
        if WORDS=$( eval "${COMP_LINE% *} --help" 2>&1 ); then
            WORDS=$( echo "$WORDS" | eval "$SED_OPT" )
        else
            echo; echo "$WORDS" | head -n1 >&2
            return
        fi
    else
        if [ "${COMP_CWORD}" -eq 1 ]; then
            WORDS=$( $COM --help | eval "$SED_COM" )
        else
            if WORDS=$( eval "${COMP_LINE% *} --help" 2>&1 ); then
                WORDS=$( echo "$WORDS" | eval "$SED_COM" )
            else
                echo; echo "$WORDS" | head -n1 >&2
                return
            fi
        fi
    fi
    COMPREPLY=( $(compgen -W "$WORDS" -- "$CUR") )
    [ "${COMPREPLY: -1}" = "=" ] && compopt -o nospace
}

complete -o default -F _dart dart

