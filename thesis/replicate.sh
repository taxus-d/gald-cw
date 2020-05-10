#!/bin/sh

[ -z "$GIT" ] && GIT=true
[ -x "$(which git)" ] || GIT=false

FONTDIR=fonts
PACKAGEDIR=packages

usepdflatex=true
downloadfonts=false

source "$(dirname $0)/replicate.lib.sh"

$GIT && git_prepare

# пакеты. 
# можно добавить нужные через fetch_package $url $name && unpack_package $name
# или выкачать с github
fetch_package_githubfallback 'https://github.com/taxus-d' tarantas master


read -p "Вы используете pdflatex? [Y/n] " $response
[ "$response" == 'n' ] && usepdflatex=false

$usepdflatex && patch -p0 <pdflatex.patch

# шрифты. Можно убирать/добавлять, он скачает
$downloadfonts && {
    fetch_font \
        https://github.com/alexeiva/NunitoFont/releases/download/v3.502/Nunito.zip \
        Nunito && unpack_font Nunito
    
    fetch_font \
        https://github.com/alexeiva/NunitoSans/releases/download/v2.500/NunitoSans.zip \
        NunitoSans && unpack_font NunitoSans

    fetch_font \
        https://www.fontsquirrel.com/fonts/download/pt-serif \
        PTSerif && unpack_font PTSerif

    fetch_font \
        https://github.com/stipub/stixfonts/raw/master/OTF/STIX2Math.otf \
        STIX
    
    fetch_font \
        https://github.com/alif-type/xits/raw/master/XITSMath-Regular.otf \
        XITS
}


$GIT && git_finish

[ -x `which latexmk` ] || echo "No latexmk found, install it or have a nice evening with kpsewhich et al"

cat <<EOF

собирать через можно через latexmk main.tex

Если вы пользуетесь средой разработки (Тexmaker и тд), не забудьте указать ему в качестве сборщика latexmk.
Если же вы используете теховский плагин для любимого редактора, наверное вы лучше знаете где там что править :)

Если что-то не так, описание полей, шрифта и прочего лежит в lyt/thesis.lyt, добро пожаловать. 
                                                                                                    @taxuswc
EOF
