#include "ServiceManager.h"
#include <QDebug>
#include "AlarmService.h"
ServiceManager& ServiceManager::instance() {
    static ServiceManager instance;
    return instance;
}

ServiceManager::ServiceManager() {
    // 初始化所有服务
    m_services.append(&m_alarmService);
}

void ServiceManager::startAll() {
    qDebug() << "Starting all services...";
    for(QObject* service : m_services) {
        if(auto alarmSvc = qobject_cast<AlarmService*>(service)) {
            alarmSvc->start();
        }
    }
}

void ServiceManager::stopAll() {
    qDebug() << "Stopping all services...";
    for(QObject* service : m_services) {
        if(auto alarmSvc = qobject_cast<AlarmService*>(service)) {
            alarmSvc->stop();
        }
    }
}