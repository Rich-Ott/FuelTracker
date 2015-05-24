# Config.pri file version 2.0. Auto-generated by IDE. Any changes made by user will be lost!
BASEDIR = $$quote($$_PRO_FILE_PWD_)

device {
    CONFIG(debug, debug|release) {
        profile {
            INCLUDEPATH += $$quote(${QNX_TARGET}/usr/include/bb/system)

            DEPENDPATH += $$quote(${QNX_TARGET}/usr/include/bb/system)

            LIBS += -lbbsystem

            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        } else {
            INCLUDEPATH += $$quote(${QNX_TARGET}/usr/include/bb/system)

            DEPENDPATH += $$quote(${QNX_TARGET}/usr/include/bb/system)

            LIBS += -lbbsystem

            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }

    }

    CONFIG(release, debug|release) {
        !profile {
            INCLUDEPATH += $$quote(${QNX_TARGET}/usr/include/bb/system)

            DEPENDPATH += $$quote(${QNX_TARGET}/usr/include/bb/system)

            LIBS += -lbbsystem

            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }
    }
}

simulator {
    CONFIG(debug, debug|release) {
        !profile {
            INCLUDEPATH += $$quote(${QNX_TARGET}/usr/include/bb/system)

            DEPENDPATH += $$quote(${QNX_TARGET}/usr/include/bb/system)

            LIBS += -lbbsystem

            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }
    }
}

config_pri_assets {
    OTHER_FILES += \
        $$quote($$BASEDIR/assets/FuelTransactionPage/FuelTransactionPage.qml) \
        $$quote($$BASEDIR/assets/data/v100.db) \
        $$quote($$BASEDIR/assets/images/add.png) \
        $$quote($$BASEDIR/assets/images/delete.png) \
        $$quote($$BASEDIR/assets/images/edit.png) \
        $$quote($$BASEDIR/assets/main.qml)
}

config_pri_source_group1 {
    SOURCES += \
        $$quote($$BASEDIR/src/FuelTrackerApp.cpp) \
        $$quote($$BASEDIR/src/main.cpp)

    HEADERS += $$quote($$BASEDIR/src/FuelTrackerApp.h)
}

CONFIG += precompile_header

PRECOMPILED_HEADER = $$quote($$BASEDIR/precompiled.h)

lupdate_inclusion {
    SOURCES += \
        $$quote($$BASEDIR/../src/*.c) \
        $$quote($$BASEDIR/../src/*.c++) \
        $$quote($$BASEDIR/../src/*.cc) \
        $$quote($$BASEDIR/../src/*.cpp) \
        $$quote($$BASEDIR/../src/*.cxx) \
        $$quote($$BASEDIR/../assets/*.qml) \
        $$quote($$BASEDIR/../assets/*.js) \
        $$quote($$BASEDIR/../assets/*.qs) \
        $$quote($$BASEDIR/../assets/FuelTransactionPage/*.qml) \
        $$quote($$BASEDIR/../assets/FuelTransactionPage/*.js) \
        $$quote($$BASEDIR/../assets/FuelTransactionPage/*.qs) \
        $$quote($$BASEDIR/../assets/data/*.qml) \
        $$quote($$BASEDIR/../assets/data/*.js) \
        $$quote($$BASEDIR/../assets/data/*.qs) \
        $$quote($$BASEDIR/../assets/images/*.qml) \
        $$quote($$BASEDIR/../assets/images/*.js) \
        $$quote($$BASEDIR/../assets/images/*.qs)

    HEADERS += \
        $$quote($$BASEDIR/../src/*.h) \
        $$quote($$BASEDIR/../src/*.h++) \
        $$quote($$BASEDIR/../src/*.hh) \
        $$quote($$BASEDIR/../src/*.hpp) \
        $$quote($$BASEDIR/../src/*.hxx)
}

TRANSLATIONS = $$quote($${TARGET}.ts)