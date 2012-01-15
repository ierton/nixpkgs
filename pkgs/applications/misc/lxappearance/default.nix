{stdenv, fetchurl, libX11, gtk, perl, intltool, gettext, pkgconfig }:

stdenv.mkDerivation rec {
  name = "lxappearance-0.5.1";

  src = fetchurl {
    url = "http://sourceforge.net/projects/lxde/files/LXAppearance/${name}.tar.gz";
    sha256 = "74e638257092201a572f1fcd4eb93c195c9fa75e27602662de542b002e6deade";
  };

  buildInputs = [ libX11 perl gtk intltool gettext pkgconfig ];

  meta = { 
      description = "LXAppearance is the standard theme switcher of LXDE. Users are able to change the theme, icons, and fonts used by applications easily.";
      homepage = http://lxde.org;
      license = "GPL2";
  };
}

