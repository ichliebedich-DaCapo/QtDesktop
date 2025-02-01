#include "AlarmService.h"
#include <QCoreApplication>

AlarmService::AlarmService(QObject *parent)
        : QObject(parent),
          m_lock("qdesktop_alarm_service")
{
    // 确保单实例运行
    if(!m_lock.create(1)) {
        qDebug() << "Service already running, exiting...";
        QCoreApplication::exit(-1);
    }
}

void AlarmService::start() {
    m_alarmCtrl.loadAlarms();

    // 使用更长间隔降低CPU占用（嵌入式优化）
    m_checkTimer.setInterval(2000); // 30秒
    connect(&m_checkTimer, &QTimer::timeout, this, &AlarmService::onCheckAlarms);
    m_checkTimer.start();

    qDebug() << "AlarmService started in background mode";
}

void AlarmService::stop() {
    m_checkTimer.stop();
    m_lock.unlock();
}

void AlarmService::onCheckAlarms() {
    // 直接调用原有检查逻辑
    m_alarmCtrl.checkAlarms();

//    // 嵌入式设备优化：每分钟校准时间
//    static int counter = 0;
//    if(++counter % 2 == 0) { // 每60秒校准
//        QTime current = QTime::currentTime();
//        if(current.second() > 50) {
//            m_checkTimer.setInterval(1000); // 最后10秒切到1秒精度
//        } else {
//            m_checkTimer.setInterval(30000);
//        }
//    }
}