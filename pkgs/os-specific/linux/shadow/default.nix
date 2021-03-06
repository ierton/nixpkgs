{ stdenv, fetchurl, pam ? null, glibcCross ? null }:

let

  glibc =
    if stdenv ? cross
    then glibcCross
    else assert stdenv ? glibc; stdenv.glibc;

in

stdenv.mkDerivation rec {
  name = "shadow-4.1.5.1";

  src = fetchurl {
    url = "http://pkg-shadow.alioth.debian.org/releases/${name}.tar.bz2";
    sha256 = "1yvqx57vzih0jdy3grir8vfbkxp0cl0myql37bnmi2yn90vk6cma";
  };

  buildInputs = stdenv.lib.optional (pam != null && stdenv.isLinux) pam;

  patches = [ ./keep-path.patch ];

  # Assume System V `setpgrp (void)', which is the default on GNU variants
  # (`AC_FUNC_SETPGRP' is not cross-compilation capable.)
  preConfigure = "export ac_cv_func_setpgrp_void=yes";

  preBuild = assert glibc != null;
    ''
      substituteInPlace lib/nscd.c --replace /usr/sbin/nscd ${glibc}/sbin/nscd
    '';

  # Don't install ‘groups’, since coreutils already provides it.
  postInstall =
    ''
      rm $out/bin/groups $out/share/man/man1/groups.*
    '';

  meta = {
    homepage = http://pkg-shadow.alioth.debian.org/;
    description = "Suite containing authentication-related tools such as passwd and su";
  };
}
