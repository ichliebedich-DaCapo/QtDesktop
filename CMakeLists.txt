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

# ---------添加资源文件----------
file(GLOB_RECURSE SRC
        "main.cpp"
        "qml.qrc"

        "core/*.cpp"
        "core/*.h"

        "modules/*.h"
        "modules/*.cpp"
)


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
target_link_libraries(${PROJECT_NAME}
        Qt5::Core Qt5::Gui Qt5::Widgets
        Qt5::Multimedia
        Qt5::Qml Qt5::Network
)
