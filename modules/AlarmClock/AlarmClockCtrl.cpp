// modules/AlarmClock/AlarmClockCtrl.cpp
#include "AlarmClockCtrl.h"
#include <QTime>
#include <QVariant>  // 添加这行关键包含
QVariantList AlarmClockCtrl::alarms() const {
    QVariantList list;
    for(const auto& alarm : m_alarms) {
        list.append(QVariant::fromValue(alarm));
    }
    return list;
}

// 在构造函数添加类型注册
AlarmClockCtrl::AlarmClockCtrl(QObject *parent) : QObject(parent) {
    qRegisterMetaType<Alarm>("Alarm");
}

void AlarmClockCtrl::addAlarm(QString time, QVariantList repeatDays, QString label) {
    Alarm alarm;
    alarm.time = QTime::fromString(time, "hh:mm");
    alarm.active = true;
    alarm.repeatDays = repeatDays; // 直接使用QVariantList
    alarm.label = label;

    m_alarms.append(alarm);
    emit alarmsChanged();
}

void AlarmClockCtrl::removeAlarm(int index) {
    if(index >=0 && index < m_alarms.size()) {
        m_alarms.removeAt(index);
        emit alarmsChanged();
    }
}

void AlarmClockCtrl::toggleAlarm(int index) {
    if(index >=0 && index < m_alarms.size()) {
        m_alarms[index].active = !m_alarms[index].active;
        emit alarmsChanged();
    }
}