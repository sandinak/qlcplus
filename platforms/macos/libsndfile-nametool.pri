LIBSNDFILE_DIR      = $$system("pkg-config --variable libdir sndfile")
LIBSNDFILE_FILE     = libsndfile.1.dylib
LIBSNDFILE_FILEPATH = $$LIBSNDFILE_DIR/$$LIBSNDFILE_FILE

LIBOGG_FILE = libogg.0.dylib
LIBOGG_PATH = $$system("pkg-config --variable libdir ogg")
LIBOGG_FILEPATH = $$LIBOGG_PATH/$$LIBOGG_FILE
# Check for newer FLAC versions - libFLAC.14.dylib in newer Homebrew
LIBFLAC_FILE = $$system("ls $$system(pkg-config --variable libdir flac)/libFLAC.*.dylib 2>/dev/null | grep -v '++' | head -1 | xargs basename")
isEmpty(LIBFLAC_FILE): LIBFLAC_FILE = libFLAC.8.dylib
LIBFLAC_PATH = $$system("pkg-config --variable libdir flac")
LIBFLAC_FILEPATH = $$LIBFLAC_PATH/$$LIBFLAC_FILE
LIBVORBIS_FILE = libvorbis.0.dylib
LIBVORBIS_PATH = $$system("pkg-config --variable libdir vorbis")
LIBVORBIS_FILEPATH = $$LIBVORBIS_PATH/$$LIBVORBIS_FILE
LIBVORBISENC_FILE = libvorbisenc.2.dylib
LIBVORBISENC_PATH = $$system("pkg-config --variable libdir vorbisenc")
LIBVORBISENC_FILEPATH = $$LIBVORBISENC_PATH/$$LIBVORBISENC_FILE
LIBOPUS_FILE = libopus.0.dylib
LIBOPUS_PATH = $$system("pkg-config --variable libdir opus")
LIBOPUS_FILEPATH = $$LIBOPUS_PATH/$$LIBOPUS_FILE

LIBSNDFILE_INSTALL_NAME_TOOL = install_name_tool -change $$LIBSNDFILE_FILEPATH \
                @executable_path/../$$LIBSDIR/$$LIBSNDFILE_FILE
LIBOGG_INSTALL_NAME_TOOL = install_name_tool -change $$LIBOGG_FILEPATH \
                @executable_path/../$$LIBSDIR/$$LIBOGG_FILE
LIBFLAC_INSTALL_NAME_TOOL = install_name_tool -change $$LIBFLAC_FILEPATH \
                @executable_path/../$$LIBSDIR/$$LIBFLAC_FILE
LIBVORBIS_INSTALL_NAME_TOOL = install_name_tool -change $$LIBVORBIS_FILEPATH \
                @executable_path/../$$LIBSDIR/$$LIBVORBIS_FILE
LIBVORBISENC_INSTALL_NAME_TOOL = install_name_tool -change $$LIBVORBISENC_FILEPATH \
                @executable_path/../$$LIBSDIR/$$LIBVORBISENC_FILE
LIBOPUS_INSTALL_NAME_TOOL = install_name_tool -change $$LIBOPUS_FILEPATH \
                @executable_path/../$$LIBSDIR/$$LIBOPUS_FILE

contains(PKGCONFIG, sndfile) {
    !isEmpty(nametool.commands) {
        nametool.commands += "&&"
    }

    nametool.commands += $$LIBSNDFILE_INSTALL_NAME_TOOL $$OUTFILE
}

LIBSNDFILE.path   = $$INSTALLROOT/$$LIBSDIR
# Use cp -L to resolve symlinks when copying libraries
LIBSNDFILE.extra = cp -L $$LIBOGG_FILEPATH $$INSTALLROOT/$$LIBSDIR/$$LIBOGG_FILE && \
                   cp -L $$LIBFLAC_FILEPATH $$INSTALLROOT/$$LIBSDIR/$$LIBFLAC_FILE && \
                   cp -L $$LIBVORBISENC_FILEPATH $$INSTALLROOT/$$LIBSDIR/$$LIBVORBISENC_FILE && \
                   cp -L $$LIBVORBIS_FILEPATH $$INSTALLROOT/$$LIBSDIR/$$LIBVORBIS_FILE && \
                   cp -L $$LIBOPUS_FILEPATH $$INSTALLROOT/$$LIBSDIR/$$LIBOPUS_FILE && \
                   cp -L $$LIBSNDFILE_FILEPATH $$INSTALLROOT/$$LIBSDIR/$$LIBSNDFILE_FILE

LIBSNDFILE_INSTALL_NAME_TOOL_ID = install_name_tool -id @executable_path/../$$LIBSDIR/$$LIBSNDFILE_FILE \
                $$INSTALLROOT/$$LIBSDIR/$$LIBSNDFILE_FILE
LIBOGG_INSTALL_NAME_TOOL_ID = install_name_tool -id @executable_path/../$$LIBSDIR/$$LIBOGG_FILE \
                $$INSTALLROOT/$$LIBSDIR/$$LIBOGG_FILE
LIBFLAC_INSTALL_NAME_TOOL_ID = install_name_tool -id @executable_path/../$$LIBSDIR/$$LIBFLAC_FILE \
                $$INSTALLROOT/$$LIBSDIR/$$LIBFLAC_FILE
LIBVORBIS_INSTALL_NAME_TOOL_ID = install_name_tool -id @executable_path/../$$LIBSDIR/$$LIBVORBIS_FILE \
                $$INSTALLROOT/$$LIBSDIR/$$LIBVORBIS_FILE
LIBVORBISENC_INSTALL_NAME_TOOL_ID = install_name_tool -id @executable_path/../$$LIBSDIR/$$LIBVORBISENC_FILE \
                $$INSTALLROOT/$$LIBSDIR/$$LIBVORBISENC_FILE
LIBOPUS_INSTALL_NAME_TOOL_ID = install_name_tool -id @executable_path/../$$LIBSDIR/$$LIBOPUS_FILE \
                $$INSTALLROOT/$$LIBSDIR/$$LIBOPUS_FILE

LIBSNDFILE_ID.path     = $$INSTALLROOT/$$LIBSDIR
LIBSNDFILE_ID.commands = $$LIBSNDFILE_INSTALL_NAME_TOOL_ID && $$LIBOGG_INSTALL_NAME_TOOL_ID && \
                         $$LIBFLAC_INSTALL_NAME_TOOL_ID && $$LIBVORBIS_INSTALL_NAME_TOOL_ID && \
                         $$LIBVORBISENC_INSTALL_NAME_TOOL_ID && $$LIBOPUS_INSTALL_NAME_TOOL_ID
