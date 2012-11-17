#
# extract archives
#

extract ()
{
    if [ -f "$1" ]
        then
            case "$1" in
                 *.tar.bz2) tar xvjf "$1" ;;
                 *.tar.gz) tar xzvf "$1" ;;
                 *.bz2) bunzip2 -v "$1" ;;
                 *.deb) ar xv "$1" ;;
                 *.gz) gunzip -v "$1" ;;
                 *.rar) unrar xv "$1" ;;
                 *.rpm) rpm2cpio -v "$1" | cpio --quiet -i --make-directories ;;
                 *.tar) tar xfv "$1" ;;
                 *.tbz2) tar xjfv "$1" ;;
                 *.tgz) tar xzfv "$1" ;;
                 *.zip) unzip "$1" ;;
                 *.z) uncompress -v "$1" ;;
                 *.7z) 7z xv "$1" ;;
                 *) echo "'$1' cannot be extracted via extract" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
