QT       += core gui widgets network

CONFIG   += c++17
CONFIG += sdk_no_version_check

# Source files
SOURCES += \
    src/ServerManager.cpp \
    src/animation.cpp \
    src/block.cpp \
    src/bomb.cpp \
    src/breakableblock.cpp \
    src/explosioneffect.cpp \
    src/game.cpp \
    src/gameobject.cpp \
    src/gameview.cpp \
    src/hud.cpp \
    src/main.cpp \
    src/maploader.cpp \
    src/player.cpp \
    src/settingsdialog.cpp \
    src/udpmanager.cpp \


# Header files
HEADERS += \
    include/ServerManager.h \
    include/animation.h \
    include/block.h \
    include/bomb.h \
    include/breakableblock.h \
    include/explosioneffect.h \
    include/game.h \
    include/gameobject.h \
    include/gameview.h \
    include/hud.h \
    include/maploader.h \
    include/player.h \
    include/settingsdialog.h \
    include/udpmanager.h \


# Resource file
RESOURCES += \
    resources/resources.qrc

# Default deployment rules
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
