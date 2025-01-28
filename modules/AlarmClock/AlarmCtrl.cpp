#include "AlarmCtrl.h"

AlarmCtrl::AlarmCtrl(QObject *parent)
        : QObject(parent), m_settings("MyCompany", "AlarmApp") {
    loadAlarms();
}

void AlarmCtrl::addAlarm(int hours, int minutes, const QString &days, const QString &label) {
    m_alarms.append({true, QTime(hours, minutes), days, label});
    saveAlarms();
    emit alarmsChanged();
}

void AlarmCtrl::removeAlarm(int index) {
    if (index >= 0 && index < m_alarms.size()) {
        m_alarms.removeAt(index);
        saveAlarms();
        emit alarmsChanged();
    }
}

void AlarmCtrl::toggleAlarm(int index, bool enabled) {
    if (index >= 0 && index < m_alarms.size()) {
        m_alarms[index].enabled = enabled;
        saveAlarms();
        emit alarmsChanged();
    }
}

void AlarmCtrl::loadAlarms() {
    int size = m_settings.beginReadArray("alarms");
    for (int i = 0; i < size; ++i) {
        m_settings.setArrayIndex(i);
        AlarmItem item;
        item.enabled = m_settings.value("enabled").toBool();
        item.time = m_settings.value("time").toTime();
        item.days = m_settings.value("days").toString();
        item.label = m_settings.value("label").toString();
        m_alarms.append(item);
    }
    m_settings.endArray();
}

void AlarmCtrl::saveAlarms() {
    m_settings.beginWriteArray("alarms");
    for (int i = 0; i < m_alarms.size(); ++i) {
        m_settings.setArrayIndex(i);
        m_settings.setValue("enabled", m_alarms[i].enabled);
        m_settings.setValue("time", m_alarms[i].time);
        m_settings.setValue("days", m_alarms[i].days);
        m_settings.setValue("label", m_alarms[i].label);
    }
    m_settings.endArray();
}