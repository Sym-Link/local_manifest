#!/bin/bash

now=$(date +"%m-%d_%H%M")

echo -n "jfltetmo, d2tmo or grouper? (0 = jfltetmo, 1 = d2tmo, 2 = grouper, 3 = jfltetmo and d2tmo, 4 = All): "
read -e DEVICE

if [ $DEVICE -ne 2 ]; then
echo -n "Copy to Drive? (0 = No, 1 = Yes): "
read -e DRIVE
fi

if [ $DEVICE -eq 0 -o $DEVICE -eq 3 -o $DEVICE -eq 4 ]; then
# echo -n "Copy to NAS? (0 = No, 1 = Yes): "
# read -e NAS
echo -n "Apply IR Patches? (0 = No, 1 = Yes): "
read -e PATCHES
fi

cd ~/Desktop
rm -rf Build*

if [ $DEVICE -eq 0 -o $DEVICE -eq 3 -o $DEVICE -eq 4 ]; then
cd ~/android/cm
make clobber
curl https://raw.github.com/Sym-Link/local_manifest/master/d2tmo.xml > ~/android/cm/.repo/local_manifests/roomservice.xml
repo sync -j8
if [ $PATCHES -eq 1 ]; then
cp ~/android/0001-Irda-Add-Irda-System-Service-Samsung-devices.patch ~/android/cm/frameworks/base/
cp ~/android/0001-Irda-Added-IrDA-HAL-Library.patch ~/android/cm/hardware/libhardware/
cp ~/android/0001-Irda-Enable-Irda-service-via-overlay-and-HAL.patch ~/android/cm/device/samsung/jf-common/
cp ~/android/0001-Expose-Irda-feature.patch ~/android/cm/device/samsung/jf-common/
cd ~/android/cm/frameworks/base/
git apply 0001-Irda-Add-Irda-System-Service-Samsung-devices.patch
cd ~/android/cm/hardware/libhardware/
git apply 0001-Irda-Added-IrDA-HAL-Library.patch
cd ~/android/cm/device/samsung/jf-common/
git apply 0001-Irda-Enable-Irda-service-via-overlay-and-HAL.patch
git apply 0001-Expose-Irda-feature.patch
fi
cd ~/android/cm
mkdir ~/Desktop/Build_jfltetmo_cm_$now
. build/envsetup.sh && brunch jfltetmo
cp ~/android/cm/out/target/product/jfltetmo/cm-10*.zip ~/Desktop/Build_jfltetmo_cm_$now/cm_jfltetmo-$now.zip
# if [ $NAS -eq 1 ]; then
# cp -r ~/Desktop/Build_jfltetmo_cm_$now/ /media/NAS/
# fi
if [ $PATCHES -eq 1 ]; then
cd ~/android/cm/frameworks/base/
git apply -R 0001-Irda-Add-Irda-System-Service-Samsung-devices.patch
cd ~/android/cm/hardware/libhardware/
git apply -R 0001-Irda-Added-IrDA-HAL-Library.patch
cd ~/android/cm/device/samsung/jf-common/
git apply -R 0001-Expose-Irda-feature.patch
git apply -R 0001-Irda-Enable-Irda-service-via-overlay-and-HAL.patch
rm ~/android/cm/frameworks/base/0001-Irda-Add-Irda-System-Service-Samsung-devices.patch
rm ~/android/cm/hardware/libhardware/0001-Irda-Added-IrDA-HAL-Library.patch
rm ~/android/cm/device/samsung/jf-common/0001-Irda-Enable-Irda-service-via-overlay-and-HAL.patch
rm ~/android/cm/device/samsung/jf-common/0001-Expose-Irda-feature.patch
fi
if [ $DRIVE -eq 1 ]; then
cp ~/Desktop/Build_jfltetmo_cm_$now/cm_jfltetmo-$now.zip ~/GoogleDrive/jflte/cm_jfltetmo-$now.zip
fi
fi

if [ $DEVICE -eq 1 -o $DEVICE -eq 3 -o $DEVICE -eq 4 ]; then
cd ~/android/cm
make clobber
curl https://raw.github.com/Sym-Link/local_manifest/master/d2tmo.xml > ~/android/cm/.repo/local_manifests/roomservice.xml
repo sync -j8
mkdir ~/Desktop/Build_d2tmo_cm_$now
. build/envsetup.sh && brunch d2tmo
cp ~/android/cm/out/target/product/d2tmo/cm-10*.zip ~/Desktop/Build_d2tmo_cm_$now/cm_d2tmo-$now.zip
if [ $DRIVE -eq 1 ]; then
cp ~/Desktop/Build_d2tmo_cm_$now/cm_d2tmo-$now.zip ~/GoogleDrive/d2tmo/cm_d2tmo-$now.zip
fi
fi

if [ $DEVICE -eq 2 -o $DEVICE -eq 4 ]; then
cd ~/android/cm
make clobber
curl https://raw.github.com/Sym-Link/local_manifest/master/d2tmo.xml > ~/android/cm/.repo/local_manifests/roomservice.xml
repo sync -j8
mkdir ~/Desktop/Build_grouper_cm_$now
. build/envsetup.sh && brunch grouper
cp ~/android/cm/out/target/product/grouper/cm-10*.zip ~/Desktop/Build_grouper_cm_$now/cm_grouper-$now.zip
fi

echo "Builds finished and located in time stamped folders on desktop"
