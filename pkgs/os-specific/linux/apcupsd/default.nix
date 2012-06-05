{ stdenv, fetchurl, libtool, gettext, pkgconfig, upstart, sysvtools,
  utillinux, man }:

stdenv.mkDerivation rec {

  name = "apcupsd-3.14.10";

  src = fetchurl {
    url = "mirror://sourceforge/apcupsd/${name}.tar.gz";
    sha256 = "0707b5ec9916fbde9e44eb8d18037c8d8f75dfd6aeef51aba5487e189eef2032";
  };

  buildInputs = [ libtool gettext pkgconfig upstart sysvtools utillinux man ];

  configurePhase = ''
    export PATH=${upstart}/sbin:$PATH

    ./configure \
      --prefix=$out \
      --sbindir=$out/sbin \
      --sysconfdir=$out/etc/apcupsd \
      --with-halpolicydir=$out/share/hal \
      --with-pwrfail-dir=$out/etc/apcupsd \
      --datadir=$out/share \
      --mandir=$out/man \
      --with-nis-port=3551
  '';

  installPhase = ''
    make install exec-prefix=$out
  '';

  meta = {
    description = "APC UPS daemon with integrated tcp/ip remote shutdown";
    platforms = stdenv.lib.platforms.linux;
  };
}

