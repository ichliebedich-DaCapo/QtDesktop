#pragma once
#include <QObject>
#include <QVector>
#include "AlarmService.h"

class ServiceManager {
public:
    static ServiceManager& instance();

    void startAll();
    void stopAll();

private:
    QVector<QObject*> m_services;
    AlarmService m_alarmService; // 直接持有实例

    ServiceManager();
    Q_DISABLE_COPY(ServiceManager)
};