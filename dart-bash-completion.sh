
_dart() 
{
    local COM=${COMP_WORDS[0]}
    local CUR=${COMP_WORDS[COMP_CWORD]}
    local IFS=$' \t\n' WORDS
    local SED_COM='sed -En '\''/^Available (sub)?commands:/,${ s/^  ([^ ]+).*/\1/p }'\'
    local SED_OPT='sed -En -e '\''s/^... (--[^ <]+).*/\1/; tX; b'\'' -e '\'':X s/\[|\]//g; p; tY; b'\'' -e '\'':Y s/no-//p'\'

    for (( i = 1; i < $COMP_CWORD; i++ )); do
        if [[ ${COMP_WORDS[i]} = "=" || ${COMP_WORDS[i-1]} = "=" ]]; then
            COM="$COM${COMP_WORDS[i]}"
        else
            COM="$COM ${COMP_WORDS[i]}"
        fi
    done
    if [ "${CUR:0:1}" = "-" ]; then
        WORDS=$( eval "$COM --help" |& eval "$SED_OPT" )
    else
        if [ "${COMP_CWORD}" -eq 1 ]; then
            WORDS=$( ${COMP_WORDS[0]} --help | eval "$SED_COM" )
        else
            WORDS=$( eval "$COM --help" |& eval "$SED_COM" )
        fi
    fi
    [ -n "$WORDS" ] && COMPREPLY=( $(compgen -W "$WORDS" -- "$CUR") )
    [ "${COMPREPLY: -1}" = "=" ] && compopt -o nospace
}

complete -o default -F _dart dart
