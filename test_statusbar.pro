QT += widgets gui core
CONFIG += c++17

TARGET = test_statusbar
TEMPLATE = app

SOURCES += test_main_statusbar.cpp

# Include paths
INCLUDEPATH += ui/src
INCLUDEPATH += engine/src

# Library paths and linking
LIBS += -L$$PWD/ui/src -lqlcplusui
LIBS += -L$$PWD/engine/src -lqlcplusengine

# Make sure libraries are found at runtime
QMAKE_RPATHDIR += $$PWD/ui/src
QMAKE_RPATHDIR += $$PWD/engine/src
