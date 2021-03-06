{ stdenv, fetchsvn, dbus, dbus_cplusplus, expat, glibmm, libconfig
, libavc1394, libiec61883, libraw1394, libxmlxx, makeWrapper, pkgconfig
, pyqt4, python, pythonDBus, qt4, scons }:

stdenv.mkDerivation rec {
  name = "libffado-svn-1995";

  src = fetchsvn {
    url = "http://subversion.ffado.org/ffado/trunk/libffado";
    rev = "1995";
  };

  buildInputs =
    [ dbus dbus_cplusplus expat glibmm libavc1394 libconfig
      libiec61883 libraw1394 libxmlxx makeWrapper pkgconfig pyqt4
      python pythonDBus qt4 scons
    ];

  patches = [ ./enable-mixer-and-dbus.patch ];

  preBuild = "export PYLIBSUFFIX=lib/${python.libPrefix}/site-packages";

  # TODO fix ffado-diag, it doesn't seem to use PYPKGDIR
  buildPhase = "scons PYPKGDIR=$out/$PYLIBSUFFIX";
  installPhase = ''
    scons PREFIX=$out LIBDIR=$out/lib SHAREDIR=$out/share/libffado \
      PYPKGDIR=$out/$PYLIBSUFFIX install

    sed -e "s#/usr/local#$out#g" -i $out/bin/ffado-diag

    PYDIR=$out/$PYLIBSUFFIX
    wrapProgram $out/bin/ffado-mixer --prefix PYTHONPATH : \
      $PYTHONPATH:$PYDIR:${pyqt4}/$LIBSUFFIX:${pythonDBus}/$LIBSUFFIX:
    wrapProgram $out/bin/ffado-diag --prefix PYTHONPATH : \
      $PYTHONPATH:$PYDIR:$out/share/libffado/python:${pyqt4}/$LIBSUFFIX:${pythonDBus}/$LIBSUFFIX:
    '';

  meta = with stdenv.lib; {
    homepage = http://www.ffado.org;
    description = "FireWire audio drivers";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
  };
}
