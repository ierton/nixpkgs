{stdenv, fetchurl, glib, libglade, librsvg, cairo, gtk, pango,
    pkgconfig, intltool} :

stdenv.mkDerivation rec {

  src = fetchurl {
    url = "http://macslow.thepimp.net/projects/cairo-clock/cairo-clock_0.3.3-1.tar.gz";
    sha256 = "812ca12792940138ce4d154d1d0d7d1e37295cf06ac7caf02935d5ebf845dc4c";
  };

  buildInputs = [glib libglade librsvg cairo gtk pango 
    pkgconfig intltool];

  name = "cairoclock-0.3.3";

  meta = {
    description = "An analog clock displaying the system-time.";
	license = "GPL2";
  };
}
