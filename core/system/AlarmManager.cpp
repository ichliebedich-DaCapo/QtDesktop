// AlarmManager.cpp
#include "AlarmManager.h"

AlarmManager::AlarmManager(QObject *parent)
        : QObject(parent), m_settings("MyCompany", "AlarmApp") {
    loadAlarms();
}

void AlarmManager::addAlarm(const QTime &time, const QString &label) {
    // 检查 label 是否为空
    QString alarmLabel = label.isEmpty() ? "未命名" : label;

    AlarmItem newAlarm{
            true,
            time,
            "Once",
            alarmLabel, // 确保 label 不为空
            static_cast<int>(QDateTime::currentSecsSinceEpoch())
    };
    m_alarms.append(newAlarm);
    saveAlarms();
    emit alarmsChanged();
}

void AlarmManager::removeAlarm(int id) {
    m_alarms.erase(std::remove_if(m_alarms.begin(), m_alarms.end(),
                                  [id](const AlarmItem &a) { return a.id == id; }),
                   m_alarms.end());
    saveAlarms();
    emit alarmsChanged(); // 只在数据变化时触发信号
}

void AlarmManager::toggleAlarm(int id, bool enabled) {
    for (auto &alarm : m_alarms) {
        if (alarm.id == id) {
            alarm.enabled = enabled;
            break;
        }
    }
    saveAlarms();
    emit alarmsChanged(); // 只在数据变化时触发信号
}

QVariantList AlarmManager::alarms() const {
    QVariantList list;
    for (const auto &alarm : m_alarms) {
        list.append(alarm.toVariantMap());
    }
    return list;
}

void AlarmManager::loadAlarms() {
    int size = m_settings.beginReadArray("alarms");
    for (int i = 0; i < size; ++i) {
        m_settings.setArrayIndex(i);
        AlarmItem alarm;
        alarm.enabled = m_settings.value("enabled").toBool();
        alarm.time = QTime::fromString(m_settings.value("time").toString(), "hh:mm");
        alarm.repeat = m_settings.value("repeat").toString();
        alarm.label = m_settings.value("label").toString();
        alarm.id = m_settings.value("id").toInt();
        m_alarms.append(alarm);
    }
    m_settings.endArray();
}

void AlarmManager::saveAlarms() {
    m_settings.beginWriteArray("alarms");
    for (int i = 0; i < m_alarms.size(); ++i) {
        m_settings.setArrayIndex(i);
        m_settings.setValue("enabled", m_alarms[i].enabled);
        m_settings.setValue("time", m_alarms[i].time.toString("hh:mm"));
        m_settings.setValue("repeat", m_alarms[i].repeat);
        m_settings.setValue("label", m_alarms[i].label);
        m_settings.setValue("id", m_alarms[i].id);
    }
    m_settings.endArray();
}