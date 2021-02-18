#!/bin/sh

wget -c https://cdn.discordapp.com/attachments/727722992137666573/745038574918828112/RENDER96_V1.3.7z -O RENDER96_V1.3.7z
wget -c https://cdn.discordapp.com/attachments/716459185230970880/781357039653748736/Habla_Mario_64_V3.zip -O Habla_Mario_64_V3.zip
wget -c http://download1072.mediafire.com/6vg908zw2heg/i2j0jng59qfc100/Niplob+Sound+Pack+v0.1.zip -O sound_pack.zip
./download_gdfile.sh 1hm4X766X6yB_oMAuxebv1ThVjycYWhe1

rm -rf render_model
rm -rf Habla_Mario_64_V3
rm -rf sound_pack
rm -rf pootis

mkdir -p render_model
mkdir -p sound_pack
mkdir -p pootis

cd render_model
p7zip -d ../RENDER96_V1.3.7z
cd ..

cd sound_pack
unzip ../sound_pack.zip
cd ..

unzip Habla_Mario_64_V3.zip

git clone -b nightly https://github.com/hiro2233/sm64ex.git 2>/dev/null

git checkout 536ff9020347e73085e9437d3be97698dafc63cc


git clone https://github.com/hiro2233/sm64redrawn.git 2>/dev/null
git clone https://github.com/hiro2233/Cleaner-Aesthetics.git 2>/dev/null
git clone https://github.com/hiro2233/sm64-pc-hq-sounds.git 2>/dev/null

cd sm64ex

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

# hd menu and fonts
cp -rf ../sm64redrawn/gfx/levels/menu levels/
cp -rf ../sm64redrawn/gfx/textures/segment2 textures/

# voices and text
find ../Habla_Mario_64_V3 -type d -name "Trad*" | xargs -I {} cp -rf {}/include .
find ../Habla_Mario_64_V3 -type d -name "Trad*" | xargs -I {} cp -rf {}/src .
find ../Habla_Mario_64_V3 -type d -name "Trad*" | xargs -I {} cp -rf {}/text .
cp -rf ../Habla_Mario_64_V3/Voces/sound .

# apply patches
#git apply --reject enhancements/60fps_ex.patch
git apply --reject ../patches/000*

make -j6 $1 $2 NOEXTRACT=1 TOUCH_CONTROLS=0 LEGACY_RES=1 TEXTURE_FIX=0 EXTERNAL_DATA=1  DEBUG=0 ENABLE_SDL_AUDIO=0 ENABLE_OPENGL=1 VERSION=us
#cp -rf ../sound_pack/res build/us_pc/

cd ..
