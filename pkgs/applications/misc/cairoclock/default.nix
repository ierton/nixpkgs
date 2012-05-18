{stdenv, fetchurl, glib, libglade, librsvg, cairo, gtk, pango,
    pkgconfig, intltool} :

stdenv.mkDerivation rec {

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/c/cairo-clock/cairo-clock_0.3.4.orig.tar.gz";
    sha256 = "f310de5bc03473a190d691679a831cd305351744ccf6eb7701f43dda6cd98a8d";
  };

  patches = [ ./ldflags.patch ];

  buildInputs = [glib libglade librsvg cairo gtk pango
    pkgconfig intltool];

  name = "cairoclock-0.3.4";

  meta = {
    description = "An analog clock displaying the system-time.";
	license = "GPL2";
  };
}
