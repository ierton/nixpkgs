{ stdenv, fetchgit, writeTextFile
, coreutils, gnumake, gcc, libtool, intltool, autoconf, automake, m4
, wget, gnutar, bzip2, gnugrep, gnused, gawk, patch, which
, bash, python
, gmp, mpfr, mpc
}:

stdenv.mkDerivation {
  name = "arm-gcc-sam";

  src = fetchgit {
    url = git://github.com/esden/summon-arm-toolchain.git;
    rev = "e80bd34562c5c42a026f7c86012825041a41dd75";
    sha256 = "1irjwg63zz80b4nl1wf0xv1vjsfzykw6ynn68vaahbkv5wk0xdsn";
  };

  tools_PATH = stdenv.lib.makeSearchPath "bin" [
    coreutils
    gnumake
    gnutar
    bzip2
    gnugrep
    gnused
    gawk
    patch
    python
    gcc
    which
    wget
  ];

  builder = writeTextFile {
    name = "arm-gcc-sam-builder";
    text =  ''
      . $stdenv/setup
      unpackPhase
      cd $sourceRoot

      export PATH="$tools_PATH:$PATH"
      export GCCFLAGS="--with-gmp=${gmp} --with-mpc=${mpc} --with-mpfr=${mpfr}"

      mkdir -pv "$out"
      export > env-vars
      ls -l
      ${bash}/bin/bash ./summon-arm-toolchain OOCD_EN=0 LIBOPENCM3_EN=0 PREFIX="$out"
    '';
  };

  meta = { 
    description = "FIXME";
    license =  ["GPL" "LGPL"];
    homepage = [];
  };
}
