#/******************************************************************
#Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
#* @projectName   QDesktop
#* @brief         摘要
#* @author        Deng Zhimao
#* @email         1252699831@qq.com
#* @date          2020-06-01
#*******************************************************************/
QT += quick core qml network positioning widgets quickcontrols2 widgets multimedia
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS


# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    core/drivers/beep.cpp \
    core/system/SystemMonitor.cpp \
    modules/Calculator/CalculatorCtrl.cpp \
    modules/FileExplorer/FileExplorerCtrl.cpp   \
    modules/AlarmClock/AlarmClockCtrl.cpp


RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    core/system/SystemMonitor.h \
    core/drivers/beep.h \
    modules/Calculator/CalculatorCtrl.h \
    modules/FileExplorer/FileExplorerCtrl.h \
    modules/AlarmClock/AlarmClockCtrl.h




DISTFILES +=
