{ stdenv, fetchurl, lua, python, scons }:
let
  version = "1.0.93";
in stdenv.mkDerivation rec {

  name = "tolua-${version}";
  
  src = fetchurl {
    url = "http://www.codenix.com/~tolua/tolua++-${version}.tar.bz2";
    sha256 = "90df1eeb8354941ca65663dcf28658b67d3aa41daa71133bdd20c35abb1bcaba";
  };

  buildInputs = [ python scons lua stdenv ] ;
    
  buildPhase = ''
    # Pass build environment to scons
    sed -i 's@tools = tools@tools = tools, ENV = os.environ@' SConstruct

    cat >config_linux.py <<EOF
    CCFLAGS = ['-I{lua}/include', '-O2', '-ansi', '-Wall']
    LINKFLAGS = ['-L${lua}/lib']
    LIBS = ['lua','dl','m']
    prefix = '/'
    EOF

    scons
  '';

  installPhase = ''
    ensureDir $out/bin
    ensureDir $out/lib
    ensureDir $out/include
    
    cp -v bin/tolua* $out/bin
    cp -v lib/libtolua* $out/lib
    cp -v include/tolua* $out/include
  '';

  meta = {
    homepage = http://www.codenix.com/~tolua;
    description = "Lua C++ wrappers";
    license = "MIT";
  };
}

