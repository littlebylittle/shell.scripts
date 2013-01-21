#my aliases
alias dig='dig +short'
alias hype25='ssh hype25@hype25.tmweb.ru'
alias trollfred='ssh trollfred@trollfred.tmweb.ru'

#complete hacks
#dirs
complete -d cd mkdir rmdir pushd

#files
complete -f cat less more chown ln strip
complete -f -X '*.gz' gzip
complete -f -X '*.Z' compress
complete -f -X '!*.+(Z|gz|tgz|Gz)' gunzip zcat zmore
complete -f -X '!*.Z' uncompress zmore zcat
complete -f -X '!*.+(gif|jpg|jpeg|GIF|JPG|bmp)' ee xv
complete -f -X '!*.+(ps|PS|ps.gz)' gv
complete -f -X '!*.+(dvi|DVI)' dvips xdvi dviselect dvitype
complete -f -X '!*.+(pdf|PDF)' acroread xpdf
complete -f -X '!*.texi*' makeinfo texi2dvi texi2html
complete -f -X '!*.+(tex|TEX)' tex latex slitex
complete -f -X '!*.+(mp3|MP3)' mpg123

#for java
complete -f -X '!*.+(jar)' java
#for python
complete -f -X '!*.+(py|py3|pyw|py2)' python python3

#tasks
complete -A signal kill -P '%'
complete -A stopped -P '%' bg
complete -j -P '%' fg jobs disown

#network commands
complete -A hostname ssh rsh telnet rlogin ftp ping fping host traceroute nslookup

#ssh known-hosts
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

#integral sh programm
# подставляются переменные окружения
complete -v export local readonly unset
# подставляются параметры команд set, shopt, help, unalias, bind
complete -A setopt set
complete -A shopt shopt
complete -a unalias
complete -A binding bind

#handling other program
complete -c command time type nohup exec nice eval strace gdb

#autocomplit for `find`
_find ()
{
    local cur prev

        COMPREPLY=()
        cur=${COMP_WORDS[COMP_CWORD]#-}
        prev=${COMP_WORDS[COMP_CWORD-1]}

    case "$prev" in
    -@(max|min)depth)
        COMPREPLY=( $( compgen -W '0 1 2 3 4 5 6 7 8 9' ) )
        return 0
        ;;
    -?(a)newer|-fls|-fprint?(0|f))
        COMPREPLY=( $( compgen -f $cur ) )
        return 0
        ;;
    -fstype)
        # this is highly non-portable (the option to -d is a tab)
        COMPREPLY=( $( cut -d'  ' -f 2 /proc/filesystems | grep ^$cur ) )
        return 0
        ;;
    -gid)
        COMPREPLY=( $( awk 'BEGIN {FS=":"} \
                {if ($3 ~ /^'$cur'/) print $3}' /etc/group ) )
        return 0
        ;;
    -group)
        COMPREPLY=( $( awk 'BEGIN {FS=":"} \
                {if ($1 ~ /^'$cur'/) print $1}' /etc/group ) )
        return 0
        ;;
    -?(x)type)
        COMPREPLY=( $( compgen -W 'b c d p f l s' $cur ) )
        return 0
        ;;
    -uid)
        COMPREPLY=( $( awk 'BEGIN {FS=":"} \
                {if ($3 ~ /^'$cur'/) print $3}' /etc/passwd ) )
        return 0
        ;;
    -user)
        COMPREPLY=( $( compgen -u $cur ) )
        return 0
        ;;
    -[acm]min|-[acm]time|-?(i)?(l)name|-inum|-?(i)path|-?(i)regex| \
    -links|-perm|-size|-used|-exec|-ok|-printf)
        # do nothing, just wait for a parameter to be given
        return 0
        ;;
    esac

    # complete using basic options ($cur has had its dash removed here,
    # as otherwise compgen will bomb out with an error, since it thinks
    # the dash is an option to itself)
    COMPREPLY=( $( compgen -W 'daystart depth follow help maxdepth \
            mindepth mount noleaf version xdev amin anewer atime \
            cmin cnewer ctime empty false fstype gid group ilname \
            iname inum ipath iregex links lname mmin mtime name \
            newer nouser nogroup perm regex size true type uid \
            used user xtype exec fls fprint fprint0 fprintf ok \
            print print0 printf prune ls' $cur ) )

    # this removes any options from the list of completions that have
    # already been specified somewhere on the command line.
    COMPREPLY=( $( echo "${COMP_WORDS[@]}-" | \
               (while read -d '-' i; do
                [ "$i" == "" ] && continue
                # flatten array with spaces on either side,
                # otherwise we cannot grep on word boundaries of
                # first and last word
                COMPREPLY=" ${COMPREPLY[@]} "
                # remove word from list of completions
                COMPREPLY=( ${COMPREPLY/ ${i%% *} / } )
                done
                echo ${COMPREPLY[@]})
          ) )

    # put dashes back
    for (( i=0; i < ${#COMPREPLY[@]}; i++ )); do
        COMPREPLY[i]=-${COMPREPLY[i]}
    done

    return 0
}
complete -F _find find

#-------end

#autocomplit for `configure`:
_longopt_func ()
{
    case "$2" in
    -*) ;;
    *)  return ;;
    esac

    case "$1" in
    \~*)    eval cmd=$1 ;;
    *)  cmd="$1" ;;
    esac
    COMPREPLY=( $("$cmd" --help | sed  -e '/--/!d' -e 's/.*--\([^ ]*\).*/--\1/'| \
grep ^"$2" |sort -u) )
}

complete  -o default -F _longopt_func wget bash configure
#--------end;






