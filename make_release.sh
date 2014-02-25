#!/bin/bash
source PKGBUILD
curdir=$PWD
cd $curdir
makepkg -g >> PKGBUILD
vim PKGBUILD
makepkg --source
if [ -v AUR_USER ];then
  aurupload $AUR_USER $(<~/.aurpass) system ${pkgname}-${pkgver}-${pkgrel}.src.tar.gz
else
  echo "Don't forget to upload to AUR"
fi

