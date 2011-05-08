export NDK=/home/jer/Projet_android/android-ndk-r5
export TOOLCHAIN=/home/jer/standalone-toolchain
export AOSP=/home/jer/cm7
export PRODUCT=vision
export PATH=$TOOLCHAIN/bin/:$PATH

export CC=arm-linux-androideabi-gcc
export CFLAGS="-march=armv7-a -mfloat-abi=softfp -DANDROID"
export CPPFLAGS=$CFLAGS
export LDFLAGS="-Wl,--fix-cortex-a8 -lsupc++ -L$AOSP/out/target/product/$PRODUCT/system/lib"
export LIBS="$TOOLCHAIN/arm-linux-androideabi/lib/libstdc++.a"

#rm -rf $TOOLCHAIN
#$NDK/build/tools/make-standalone-toolchain.sh --platform=android-9 --install-dir=$TOOLCHAIN

mkdir m4
autoreconf
automake --add-missing
./configure --host=arm-linux-androideabi --prefix=$AOSP/out/target/product/$PRODUCT/build
sed -i 's/soname_spec="\\${libname}\\${release}\\${shared_ext}\\$major"/soname_spec="\\${libname}\\${release}\\${shared_ext}"/' libtool
# Need to build magic.mgc using host build prior to building for android
git checkout magic/magic.mgc
make -j2
arm-linux-androideabi-strip src/.libs/libmagic.so.1.0.0
make install
