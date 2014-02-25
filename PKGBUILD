# Maintainer: TJ Vanderpoel <tj@rubyists.com>
pkgname=lighttpd2-git
pkgver=20110413
pkgrel=1
pkgdesc="The new Lighty: A small, secure, scalable, flexible webserver"
arch=(i686 x86_64)
url="http://redmine.lighttpd.net/wiki/lighttpd2/"
license=('MIT')
depends=(libev ragel lua zlib bzip2 openssl glib2 runit runit-services)
optdepends=("valgrind: for deep debuggins")
makedepends=(pkg-config musl)
backup=('etc/lighttpd2/lighttpd.conf' 'etc/lighttpd2/angel.conf' 'etc/lighttpd2/mimetypes.conf')
install=lighttpd2.install
source=("README")
md5sums=('18c5a930998b90a76e85389d73ecd639')

_gitroot="git://git.lighttpd.net/lighttpd/lighttpd2.git"
_gitname="lighttpd"

build() {
  cd "$srcdir"
  msg "Connecting to GIT server...."

  if [ -d $_gitname ] ; then
    cd $_gitname && git pull origin
    msg "The local files are updated."
  else
    git clone $_gitroot $_gitname
  fi

  msg "GIT checkout done or server timeout"
  msg "Starting make..."

  rm -rf "$srcdir/$_gitname-build"
  git clone "$srcdir/$_gitname" "$srcdir/$_gitname-build"
  cd "$srcdir/$_gitname-build"

  #
  # BUILD HERE
  #

  CC=musl-gcc ./autogen.sh
  CC=musl-gcc ./configure --prefix=/usr --with-lua --with-openssl --with-kerberos5 --with-zlib --with-bzip2 --includedir=/usr/include/lighttpd-2.0.0
  CC=musl-gcc make
  sed -i -e 's/^docroot "\/var\/www";/docroot "\/srv\/http";/' contrib/lighttpd.conf
}

package() {
  cd "$srcdir/$_gitname-build"
  make DESTDIR="$pkgdir/" install
  install -D -m0755 -d "$pkgdir/usr/share/doc/lighttpd2"
  cp -a doc/* "$pkgdir/usr/share/doc/lighttpd2/"
  install -D -d "$pkgdir/etc/sv/lighttpd2"
  install -D -d "$pkgdir/var/log/lighttpd2"
  cp -a contrib/service/* "$pkgdir/etc/sv/lighttpd2/"
  rm "$pkgdir/etc/sv/lighttpd2/log/run"
  ln -s /usr/bin/rsvlog "$pkgdir/etc/sv/lighttpd2/log/run"
  ln -s /run/runit/sv/lighttpd2 "$pkgdir/etc/sv/lighttpd2/supervise"
  ln -s /run/runit/sv/lighttpd2.log "$pkgdir/etc/sv/lighttpd2/log/supervise"

  install -D -m0644 contrib/lighttpd.conf "$pkgdir/etc/lighttpd2/lighttpd.conf"
  install -D -m0644 contrib/angel.conf "$pkgdir/etc/lighttpd2/angel.conf"
  install -D -m0644 contrib/mimetypes.conf "$pkgdir/etc/lighttpd2/mimetypes.conf"
} 
