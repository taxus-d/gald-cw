git_prepare() {
    local inrepo; inrepo=false
    
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 && inrepo=true
    $inrepo && read -p "found existing git repository; create a fresh one? [Y/n] " response
    $inrepo && [ "$response" != 'n' ] && git init
    $inrepo || git init

    git add .gitignore
    git commit -a -m "add gitignore"
    git add *
    git commit -a -m "initiate!"
}

fetch_package_githubfallback() { # url repo branch
    local savepath; savepath="$PACKAGEDIR/$2-$3"
    if $GIT; then
        git remote add -f "$2" "$1/$2".git
        git subtree add --prefix "$savepath" "$2" "$3" --squash
    else
        local url; url="$1/$2/archive/$3.zip" 
        [ -d "$savepath" ] || mkdir -p "$savepath"
        fetchin "$PACKAGEDIR" "$url" "$2-$3" && {
            unzip -u "$savepath/$3.zip" -d "$PACKAGEDIR"
        }
    fi
}

git_finish() {
    $downloadfonts && git add fonts
    git commit -a -m "add fonts and packages"
}

fetchin() { # prefix url name
    local savepath; savepath="$1/$3"
    [ -d "$savepath" ] || mkdir -p "$savepath"
    wget --no-clobber "$2" -P "$savepath"
}

isziparchive() { [[ `file -b --mime-type "$1"` =~ 'application/zip' ]]; }

unpackall() { # prefix name
    savepath="$1/$2"
    for f in "$savepath"/*; do 
        isziparchive "$f" && unzip -u "$f" -d "$savepath"
    done
}

fetch_font()     { fetchin "$FONTDIR" "$@"; }
fetch_package()  { fetchin "$PACKAGEDIR" "$@"; }
unpack_font()    { unpackall "$FONTDIR" "$@"; }
unpack_package() { unpackall "$PACKAGEDIR" "$@"; }
