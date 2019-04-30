#! /bin/bash

OS=$1

chmod 744 ./configure

args=(--prefix=$cur__install)
case $OS in
    windows)
        NASM=nasm-2.14.02
        ARCH=win64
        case $(uname -m) in
            "x86_64")
                ARCH=win64
                ;;
            "i686")
                ARCH=win32
                ;;
        esac
        ZIP_FILE="$NASM-$ARCH.zip"
        curl -O https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/$ARCH/$ZIP_FILE
        shasum -c "$ZIP_FILE.sha1" || { echo "Downloaded zipfile malformed"; exit -1; }
        unzip $ZIP_FILE
        cd $NASM
        cp nasm ndisasm $cur__install/bin/
        cp rdoff/* $cur__install/bin/
        cd ../
        ;;
    darwin)        
        NASM=nasm-2.14.02
        ZIP_FILE="$NASM-macosx.zip"
        curl -O https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/macosx/$ZIP_FILE
        shasum -c "$ZIP_FILE.sha1" || { echo "Downloaded zipfile malformed"; exit -1; }
        unzip $ZIP_FILE
        cd $NASM
        cp nasm ndisasm rdf2bin rdf2com rdf2ihx rdf2ith rdf2srec rdfdump rdflib rdx $cur__install/bin/
        cp -R man1 $cur__install/man/man1
        cd ../
        ;;
    linux)
        ./configure $args
        make
        make install
esac

