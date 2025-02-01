#pragma once
#include <QObject>
#include <QTimer>
#include <QSharedMemory>
#include "modules/AlarmClock/AlarmClockCtrl.h"

class AlarmService : public QObject {
Q_OBJECT
public:
    explicit AlarmService(QObject *parent = nullptr);
    void start();
    void stop();

private slots:
    void onCheckAlarms();

private:
    AlarmClockCtrl m_alarmCtrl;
    QTimer m_checkTimer;
    QSharedMemory m_lock; // 防止多实例
};