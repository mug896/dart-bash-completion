
_dart_get_coms () 
{
    for (( i = 1; i < $COMP_CWORD; i++ )); do
        if [[ ${COMP_WORDS[i]} = "=" || ${COMP_WORDS[i-1]} = "=" ]]; then
            COM="$COM${COMP_WORDS[i]}"
            continue
        else
            COM="$COM ${COMP_WORDS[i]}"
        fi
        [[ ! ${COMP_WORDS[i]} =~ ^[[:alnum:]]+$ ]] && continue
        $COM --help |& grep -Eq '^Available (sub)?commands:' || return
    done
    echo "$( eval "$COM --help" |& eval "$SED_COM" )"
}

_dart_get_opts () 
{
    for (( i = 1; i < $COMP_CWORD; i++ )); do
        if [[ ${COMP_WORDS[i]} = "=" || ${COMP_WORDS[i-1]} = "=" ]]; then
            COM="$COM${COMP_WORDS[i]}"
        else
            COM="$COM ${COMP_WORDS[i]}"
        fi
    done
    echo "$( eval "$COM --help" |& eval "$SED_OPT" )"
}

_dart() 
{
    local COM=${COMP_WORDS[0]}
    local CUR=${COMP_WORDS[COMP_CWORD]}
    local IFS=$' \t\n' WORDS
    local SED_COM='sed -En '\''/^Available (sub)?commands:/,${ s/^  ([^ ]+).*/\1/p }'\'
    local SED_OPT='sed -En -e '\''s/... (--[^ <]+).*/\1/; tX; b'\'' -e '\'':X s/\[|\]//g; p; tY; b'\'' -e '\'':Y s/no-//p'\'

    if [ "${CUR:0:1}" = "-" ]; then
        WORDS=$( _dart_get_opts )
    else
        if [ "${COMP_CWORD}" -eq 1 ]; then
            WORDS=$( $COM --help | eval "$SED_COM" )
        else
            WORDS=$( _dart_get_coms )
        fi
    fi
    [ -n "$WORDS" ] && COMPREPLY=( $(compgen -W "$WORDS" -- "$CUR") )
    [ "${COMPREPLY: -1}" = "=" ] && compopt -o nospace
}

complete -o default -F _dart dart
