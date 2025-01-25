cmake_minimum_required(VERSION 3.30)

project(QtDesktop)
set(CMAKE_CXX_STANDARD 11)

#打开全局moc
set(CMAKE_AUTOMOC ON)
#打开全局uic
set(CMAKE_AUTOUIC ON)
#打开全局rcc，如果没有使用qrc，此句可以去掉
set(CMAKE_AUTORCC ON)

#设置工程包含当前目录，使用*.ui文件时，需要加上这句，否则找不到头文件
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# 手动指定Qt的安装路径
set(QT_INSTALL_PATH "E:/Tools/Develop/Embedded/Qt/5.15.2/mingw81_64")

# ---------添加头文件目录----------
#include_directories(
#        cameramedia
#        fileview
#        weather
#        music
#        media
#        wireless
#        tcpclient
#        desktop
#        udpchat
#        photoview
#        iotest
#        sensor
#        iotest
#        radio
#)


# ---------添加资源文件----------
file(GLOB_RECURSE SRC
        "main.cpp"
        "qml.qrc"

        "cameramedia/*.cpp"
        "cameramedia/*.h"
        "desktop/*.cpp"
        "desktop/*.h"
        "fileview/*.cpp"
        "fileview/*.h"
        "iotest/*.cpp"
        "iotest/*.h"
        "media/*.cpp"
        "media/*.h"
        "music/*.cpp"
        "music/*.h"
        "photoview/*.cpp"
        "photoview/*.h"
        "radio/*.cpp"
        "radio/*.h"
        "sensor/*.cpp"
        "sensor/*.h"
        "tcpclient/*.cpp"
        "tcpclient/*.h"
        "tcpserver/*.cpp"
        "tcpserver/*.h"
        "udpchat/*.cpp"
        "udpchat/*.h"
        "weather/*.cpp"
        "weather/*.h"
        "wireless/*.cpp"
        "wireless/*.h"
        "core/*.cpp"
        "core/*.h"

        "modules/*.h"
        "modules/*.cpp"
)

# 定义 Qt 模块名称
#set(QT_MODULES
#        Core Gui Widgets
#        Multimedia
#        Qml Network
#)

# ------------查找Qt库------------
set(CMAKE_PREFIX_PATH "E:/Tools/Develop/Embedded/Qt/5.15.2/mingw81_64")
find_package(Qt5 REQUIRED COMPONENTS
        Core Gui Widgets
        Multimedia
        Qml Network
)
# ------------添加可执行文件------------
add_executable(${PROJECT_NAME} ${SRC})
# ------------链接Qt库------------
#set(QT_LIBRARIES)
#foreach(modules ${QT_MODULES})
#    list(APPEND QT_LIBRARIES "Qt5::${MODULE}")
#endforeach()
target_link_libraries(${PROJECT_NAME}
        Qt5::Core Qt5::Gui Qt5::Widgets
        Qt5::Multimedia
        Qt5::Qml Qt5::Network
)
