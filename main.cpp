#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTextCodec>


// 计算器
#include "./modules/Calculator/CalculatorCtrl.h"
#include "./core/system/SystemMonitor.h"
#include "modules/FileExplorer/FileExplorerCtrl.h"
#include "modules/AlarmClock/AlarmCtrl.h"

#include <QDir>
#include <QApplication>

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);// 兼容高DPI屏幕

    QApplication app(argc, argv);

    QDir::setCurrent(QCoreApplication::applicationDirPath());// 设置当前工作目录

    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));// 设置编码格式

    // 注册CalculatorCtrl
    qmlRegisterType<CalculatorCtrl>("Calculator", 1, 0, "CalculatorCtrl");

    // 注册 SystemMonitor 为单例
    qmlRegisterSingletonType<SystemMonitor>("com.qdesktop.core.system", 1, 0, "SystemMonitor", SystemMonitor::singletonProvider);

    qmlRegisterType<FileExplorerCtrl>("com.qdesktop.modules.FileExplorer", 1, 0, "FileExplorerCtrl");

    // 注册 AlarmManager
    qmlRegisterType<AlarmCtrl>("Alarm", 1, 0, "AlarmCtrl");



    QQmlApplicationEngine engine;
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