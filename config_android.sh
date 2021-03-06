#!/bin/sh
# Taken from:
# http://warpedtimes.wordpress.com/2010/02/03/building-open-source-libraries-with-android-ndk/

# -host=arm-eabi: This tells the configure script if the cross compilation is being done or not. It is also used as a prefix to some of the cross compiler tools like strip, nm etc.
# CC=arm-eabi-gcc: This tells which compiler should be used for building.
# CPPFLAGS: This tells the location where the header files should be searched which were specified in configure.ac with AC_CHECK_HEADER macro.
# CFLAGS="-nostdlib" passes the option to build some test programs during configure process run.
#  If you don’t pass this the compiler would link the standard C library of the host system which wouldn’t be compatible with the C library of the target system.
# LIBS="-lc": This option tells that it should explicitly link to a library called libc.so which is present in the location specified using the -L in the LDFLAGS option.
#  If you are wondering that usually to build a C executable one doesn’t need to provide -lc as libc is automatically linked, then why do we need to specify this here?
#  The answer lies in -nostdlib flag, which instructs not to link with the standard C library on the build system.
# LDFLAGS: This option is also passed to build some test programs during configure process run.
#  If you don’t pass the -Wl,-rpath-link option, then linker does not know where do the libraries dependent on the library specific using LIBS reside.
#  If you don’t pass the -L option then the linker doesn’t know where do the libraries specified in LIBS reside.

# Debugging
# set -x

# Cleanup previous configuration
if [ -f Makefile ]; then
make distclean
fi

# Set this to your NDK location
#export ANDROID_NDK_ROOT=/home/yossi/Android/android-ndk-r8
# REMEMBER TO ./build/envsetup.sh && lunch N
export ANDROID_NDK_ROOT=$ANDROID_BUILD_TOP/prebuilt/ndk/android-ndk-r7


# See: http://developer.android.com/guide/appendix/api-levels.html
export ANDROID_API_LEVEL="android-8"

# Run configure script
export PATH=$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin:$PATH
./configure -host=arm-eabi \
            CC=arm-linux-androideabi-gcc \
            CPPFLAGS="-I$ANDROID_NDK_ROOT/platforms/$ANDROID_API_LEVEL/arch-arm/usr/include/" \
            CFLAGS="-nostdlib" \
            LDFLAGS="-Wl,-rpath-link=$ANDROID_NDK_ROOT/platforms/$ANDROID_API_LEVEL/arch-arm/usr/lib/ -L$ANDROID_NDK_ROOT/platforms/$ANDROID_API_LEVEL/arch-arm/usr/lib/" \
            LIBS="-lc" \
            --disable-fortran \
            --disable-alloca

mv config.h config.h.android
#make distclean
mv config.h.android config.h
