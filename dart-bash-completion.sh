
_dart() 
{
    local cmd=$1 cur=${COMP_WORDS[COMP_CWORD]}
    [[ ${COMP_LINE:COMP_POINT-1:1} = " " ]] && cur=""
    local IFS=$' \t\n' words
    local sed_cmd sed_opt
    read -rd "" sed_cmd <<\@
    sed -En '/^Available (sub)?commands:/,${ s/^  ([^[:blank:]]+).*/\1/p }'
@
    read -rd "" sed_opt <<\@
    sed -En -e 's/^ *((-\w), )?(-[^[:blank:]<]+).*/\2\n\3/; tX; b' \
            -e ':X s/\[|\]//g; p; tY; b' -e ':Y s/no-//p'
@
    if [[ $cur == -* ]]; then
        if words=$( eval "${COMP_LINE% *} --help" 2>&1 ); then
            words=$( <<< $words eval "$sed_opt" )
        else
            echo; <<< $words head -n1 >&2
            return
        fi
    else
        if (( COMP_CWORD == 1 )); then
            words=$( $cmd --help | eval "$sed_cmd" )
        else
            if words=$( eval "${COMP_LINE% *} --help" 2>&1 ); then
                words=$( <<< $words eval "$sed_cmd" )
            else
                echo; <<< $words head -n1 >&2
                return
            fi
        fi
    fi
    COMPREPLY=( $(compgen -W "$words" -- "$cur") )
    [ "${COMPREPLY: -1}" = "=" ] && compopt -o nospace
}

complete -o default -o bashdefault -F _dart dart

