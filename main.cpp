/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   QDesktop
* @brief         main.cpp
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-07-31
*******************************************************************/
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "desktop/desktop.h"

#include "weather/weatherdata.h"
#include "weather/mymodel.h"

#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "music/lyricmodel.h"
#include "music/playlistmodel.h"

#include "media/mediaListModel.h"

#include "wireless/wirelessmodel.h"

#include "tcpclient/mytcpclient.h"

#include "tcpserver/mytcpserver.h"

#include "udpchat/udpreciver.h"
#include "udpchat/udpsender.h"

#include "photoview/photolistmodel.h"

#include "iotest/beep.h"

#include "sensor/ap3216c.h"
#include "sensor/icm20608.h"

#include "radio/radio.h"

#include "fileview/fileio.h"

#include "cameramedia/cameramedia.h"

// 计算器
#include "modules/Calculator/CalculatorCtrl.h"


#include <QDir>
#include <QApplication>

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);// 兼容高DPI屏幕

    QApplication app(argc, argv);

    QDir::setCurrent(QCoreApplication::applicationDirPath());// 设置当前工作目录

    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));// 设置编码格式

    qmlRegisterType<IndexData>("an.weather", 1, 0, "IndexData");
    qmlRegisterType<WeatherData>("an.weather", 1, 0, "WeatherData");
    qmlRegisterType<MyModel>("an.model", 1, 0, "MyModel");

    qmlRegisterType<lyricModel>("dataModel", 1, 0, "LyricModel");
    qmlRegisterType<playListModel>("dataModel", 1, 0, "PlayListModel");

    qmlRegisterType<mediaListModel>("mediaModel", 1, 0, "MediaListModel");

    qmlRegisterType<wirelessListModel>("wirelessModel", 1, 0, "WirelessListModel");

    qmlRegisterType<myTcpclient>("mytcpclient", 1, 0, "MyTcpclient");

    qmlRegisterType<myTcpserver>("mytcpserver", 1, 0, "MyTcpserver");

    qmlRegisterType<UdpSender>("udpsender", 1, 0, "UdpSender");
    qmlRegisterType<UdpReciver>("udpreciver", 1, 0, "UdpReciver");

    qmlRegisterType<Beep>("beep", 1, 0, "Beep");

    qmlRegisterType<Ap3216c>("ap3216c", 1, 0, "Ap3216c");
    qmlRegisterType<Icm20608>("icm20608", 1, 0, "Icm20608");


    qmlRegisterType<myRadio>("radio", 1, 0, "MyRadio");

    qmlRegisterType<MyDesktop>("myDesktop", 1, 0, "MyDesktop");

    qmlRegisterType<FileIO, 1>("fileIO", 1, 0, "FileIO");

    qmlRegisterType<CameraMedia, 1>("MyCameraMedia", 1, 0, "CameraMedia");

    // 我自己的应用
    // 注册CalculatorCtrl
    qmlRegisterType<CalculatorCtrl>("Calculator", 1, 0, "CalculatorCtrl");


    QQmlApplicationEngine engine;

#if WIN32
    engine.rootContext()->setContextProperty("WINenv", true);
#else
    engine.rootContext()->setContextProperty("WINenv", false);
#endif

    engine.rootContext()->setContextProperty("WINStyle", true);

    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());

    auto *myModel = new MyModel();
    auto *myDesktop = new MyDesktop();
    auto *myPhoto = new photoListModel();
    engine.rootContext()->setContextProperty("myPhoto", myPhoto);
    engine.rootContext()->setContextProperty("myModel", myModel);
    engine.rootContext()->setContextProperty("myDesktop", myDesktop);

    myPhoto->add(QCoreApplication::applicationDirPath() + "/src/images/");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return QApplication::exec();
}



//#include <QGuiApplication>
//#include <QQmlApplicationEngine>
//#include <QQmlContext>
//#include "core/SystemMonitor.h"
//#include "core/drivers/GpioDriver.h"
//
//int main(int argc, char *argv[])
//{
//    // 1. 嵌入式环境特殊配置
//    qputenv("QT_QUICK_BACKEND", "software"); // 强制软件渲染
//    qputenv("QT_QPA_PLATFORM", "linuxfb:fb=/dev/fb0"); // 指定显示设备
//
//    // 2. 应用初始化
//    QGuiApplication app(argc, argv);
//    app.setWindowIcon(QIcon(":/assets/icon.png"));
//
//    // 3. 注册C++类型到QML
//    qmlRegisterType<GpioDriver>("Embedded.Drivers", 1, 0, "GpioController");
//    qmlRegisterSingletonType<SystemMonitor>("Embedded.Core", 1, 0, "SysMonitor",
//                                            [](QQmlEngine *, QJSEngine *) -> QObject* {
//                                                return new SystemMonitor;
//                                            });
//
//    // 4. 配置QML引擎
//    QQmlApplicationEngine engine;
//    engine.addImportPath("qrc:/shared/components");
//
//    // 5. 注入全局对象
//    engine.rootContext()->setContextProperty("AppVersion", QVariant("1.2.0"));
//
//    // 6. 加载主QML文件
//    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
//
//    // 7. 硬件初始化延迟执行
//    QTimer::singleShot(500, [](){
//        GpioDriver::instance().initialize();
//    });
//
//    return app.exec();
//}