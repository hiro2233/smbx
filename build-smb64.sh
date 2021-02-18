#!/bin/sh

rm -rf render_model
rm -rf Habla_Mario_64_V3
rm -rf sound_pack
rm -rf pootis
rm -rf 8bit_music_pack

mkdir -p render_model
mkdir -p sound_pack
mkdir -p pootis
mkdir -p 8bit_music_pack

if [ ! -e RENDER96_V1.3.7z ] ; then
    wget -q --show-progress -c https://cdn.discordapp.com/attachments/727722992137666573/745038574918828112/RENDER96_V1.3.7z -O RENDER96_V1.3.7z
fi
if [ -e RENDER96_V1.3.7z ] ; then
    cd render_model
    7z x ../RENDER96_V1.3.7z
    cd ..
fi


if [ ! -e Habla_Mario_64_V3.zip ] ; then
    wget -q --show-progress -c https://cdn.discordapp.com/attachments/716459185230970880/781357039653748736/Habla_Mario_64_V3.zip -O Habla_Mario_64_V3.zip
fi
if [ -e Habla_Mario_64_V3.zip ] ; then
    unzip Habla_Mario_64_V3.zip
fi


if [ ! -e sound_pack.zip ] ; then
    ./mediafire-dl http://www.mediafire.com/file/v2yfyofhgjc6vgx/Niplob+Sound+Pack+v0.2.zip
    mv -f niplob_sound_pack_v0.2.zip sound_pack.zip
fi
if [ -e sound_pack.zip ] ; then
    cd sound_pack
    unzip ../sound_pack.zip
    cd ..
fi

if [ "x$EXPERIMENTAL" != "x" ] ; then
    if [ ! -e pootis.zip ] ; then
        ./download_gdfile.sh 1hm4X766X6yB_oMAuxebv1ThVjycYWhe1 pootis.zip
    fi
    if [ -e pootis.zip ] ; then
        cd pootis
        unzip ../pootis.zip
        cd ..
    fi

    if [ ! -e 8bit_music_pack.zip ] ; then
        ./mediafire-dl http://www.mediafire.com/file/l2ol3xgv23fz782/8bit+Music+Pack.zip/file
    fi
    if [ -e 8bit_music_pack.zip ] ; then
        cd 8bit_music_pack
        unzip ../8bit_music_pack.zip
        cd ..
    fi
fi

git clone -b nightly https://github.com/hiro2233/sm64ex.git 2>/dev/null
git clone https://github.com/hiro2233/sm64redrawn.git 2>/dev/null
git clone https://github.com/hiro2233/Cleaner-Aesthetics.git 2>/dev/null
git clone https://github.com/hiro2233/sm64-pc-hq-sounds.git 2>/dev/null

cd sm64ex
git remote add render https://github.com/Render96/Render96ex.git
git fetch render
git checkout 536ff9020347e73085e9437d3be97698dafc63cc
git checkout -B alpha-render96

mkdir -p levels
mkdir -p textures
mkdir -p sound/samples
mkdir -p sound/sequences/us
mkdir -p build/us_pc/res/

# sounds fx
cp -rf "../sm64-pc-hq-sounds/Sounds for building/"* sound/samples/
cp -rf ../sound_pack/res build/us_pc/
cp -rf ../sound_pack/res/sound build/us_pc/

# render models
cp -rf ../render_model/actors/warp_pipe actors/
cp -rf ../render_model/actors/mario* actors/
cp -rf ../render_model/actors/peach actors/
cp -rf ../render_model/actors/lakitu_* actors/

# base resources:
# actors
cp -rf ../Cleaner-Aesthetics/gfx/* .
#cp -rf ../Cleaner-Aesthetics/gfx/actors/lakitu_* actors/
#cp -rf ../Cleaner-Aesthetics/gfx/actors/peach actors/
#cp -rf ../Cleaner-Aesthetics/gfx/actors/mario* actors/
#cp -rf ../Cleaner-Aesthetics/gfx/actors/tree actors/
#cp -rf ../Cleaner-Aesthetics/gfx/actors/star actors/
#cp -rf ../Cleaner-Aesthetics/gfx/actors/coin actors/
#cp -rf ../Cleaner-Aesthetics/gfx/actors/power_meter actors/

# levels
#cp -rf ../Cleaner-Aesthetics/gfx/levels/castle_grounds levels/
#cp -rf ../Cleaner-Aesthetics/gfx/levels/castle_inside levels/
#cp -rf ../Cleaner-Aesthetics/gfx/levels/intro levels/
#cp -rf ../Cleaner-Aesthetics/gfx/levels/ending levels/

# textures
#cp -rf ../Cleaner-Aesthetics/gfx/textures/inside textures/
##cp -rf ../Cleaner-Aesthetics/gfx/textures/outside textures/
#cp -rf ../Cleaner-Aesthetics/gfx/textures/intro_raw textures/
#cp -rf ../Cleaner-Aesthetics/gfx/textures/sky* textures/
#cp -rf ../Cleaner-Aesthetics/gfx/textures/title_screen_bg textures/

TEXTURES_MISSING=$(find textures/special/ -type f)
mkdir temp
cd temp
printf "%s\n" "downloading missing textures..."
for textures in $TEXTURES_MISSING
do
    if [ ! -e  ../$textures ] ; then
        wget -q --show-progress https://raw.githubusercontent.com/hiro2233/RENDER96-HD-TEXTURE-PACK/master/gfx/$textures
    fi
done
cd ..
cp -rf temp/* textures/special/

# voices and text
#find ../Habla_Mario_64_V3 -type d -name "Trad*" | xargs -I {} cp -rf {}/include .
find ../Habla_Mario_64_V3 -type d -name "Trad*" | xargs -I {} cp -rf {}/src/game/area.c src/game/
find ../Habla_Mario_64_V3 -type d -name "Trad*" | xargs -I {} cp -rf {}/text .
cp -rf ../Habla_Mario_64_V3/Voces/sound .

git log -1 --pretty=tformat:"%H" > issue.txt
git config --global user.name  >> issue.txt
git config --global user.email >> issue.txt
date >> issue.txt
pango-view --dpi=300 --background=transparent --foreground=white --font=mono -qo issue.png issue.txt
cp issue.png levels/intro/4_issue.rgba16.png

# apply patches
#git apply --reject enhancements/60fps_ex.patch

#git add .
#git commit -m "all: added by build."

#git apply --reject ../patches/render96-alpha/00*
git apply ../patches/render96-alpha/0001-build-added-cross-compiler-suppport.patch
git apply ../patches/render96-alpha/0002-goddard-revert-to-standard-mario-head.patch
git apply ../patches/render96-alpha/0004-all-disabled-demos.patch
git apply ../patches/render96-alpha/0005-all-restored-mario64-intro-and-added-issue-intro.patch
git apply ../patches/render96-alpha/0011-build-added-checking-if-NOEXTRACT-on-pack-audio.patch
git apply ../patches/render96-alpha/0013-pc-added-joystick-macros-defines-if-missing.patch

git apply ../patches/render96-alpha/0006-actors-warp_pipe-remove-inc.c-extension.patch
git apply ../patches/render96-alpha/0007-actors-mario-removed-inc.c-extension.patch
git apply ../patches/render96-alpha/0008-actors-lakitus-removed-inc.c-extensions.patch
git apply ../patches/render96-alpha/0009-actors-peach-removed-inc.c-extensions.patch

git apply ../patches/0001-actors-added-includes-actors-on-common1.patch

git apply ../patches/render96-alpha/0014-all-added-issue-sprite-segment.patch

make -j6 $1 $2 NOEXTRACT=1 TOUCH_CONTROLS=0 LEGACY_RES=0 TEXTURE_FIX=0 EXTERNAL_DATA=1  DEBUG=0 ENABLE_SDL_AUDIO=0 ENABLE_OPENGL=1 VERSION=us
cp -rf ../sound_pack/res build/us_pc/

# hd menu and fonts
cp -rf ../sm64redrawn/gfx/levels/menu build/us_pc/res/gfx/levels/
cp -rf ../sm64redrawn/gfx/textures/segment2 build/us_pc/res/gfx/textures/
cp -rf ../sm64redrawn/gfx/textures/skyboxes build/us_pc/res/gfx/textures/

cd ..
