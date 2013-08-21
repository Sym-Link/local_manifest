#!/bin/bash

## cd /home/grendel/android/android_packages_apps_Phone
## git fetch cm
## git merge cm/cm-10.1
## git push origin cm-10.1

cd /home/grendel/android/cm

# echo -n "Stock or Faux kernel? (0 = Stock, 1 = Faux): "
# read -e REPO1
# if [ $REPO1 -eq 1 ]; then
# curl https://raw.github.com/Sym-Link/local_manifest/master/d2tmofaux.xml > ~/android/cm/.repo/local_manifests/roomservice.xml
# else
curl https://raw.github.com/Sym-Link/local_manifest/master/d2tmo.xml > ~/android/cm/.repo/local_manifests/roomservice.xml
# fi


repo sync -j8
