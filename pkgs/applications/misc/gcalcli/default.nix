{ stdenv, fetchurl, python, pythonPackages }:

stdenv.mkDerivation rec {
  name = "gcalcli-${version}";
  namePrefix = "";
  version = "2.4.2";

  src = fetchurl {
    url = "https://github.com/insanum/gcalcli/archive/v${version}.tar.gz";
    sha256 = "bcfaada7092fd988a23659cd285ec40919541bae2d9516daefcbd278f78bbc3b";
  };

  /* src = fetchgit { */
  /*   url = "https://github.com/insanum/gcalcli"; */
  /*   rev = "refs/tags/v${version}"; */
  /*   sha256 = "07saxansxlhp6m0mx2k129kak4z84dzlynh21wb0wvnrfi8zncpa"; */
  /* }; */

  buildInputs = [
    python pythonPackages.wrapPython
  ];

  pythonPath = [ pythonPackages.gdata pythonPackages.dateutil ];

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup
    
    unpackPhase
    cd gcalcli-*

    ls -l

    mkdir -pv $out/bin
    cp ./gcalcli $out/bin/gcalcli
    chmod +x $out/bin/gcalcli
    
    wrapPythonPrograms
  '';

  meta = {
    homepage = "https://github.com/insanum/gcalcli";
    description = "Google Calendar Command Line Interface";
  };
}

