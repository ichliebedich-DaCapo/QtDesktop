// modules/AlarmClock/AlarmClockCtrl.cpp
#include "AlarmClockCtrl.h"
#include <QDebug>
#include <QJsonArray>
#include <QFile>
#include "./core/drivers/beep.h"

QVariantList AlarmClockCtrl::alarms() const
{
    QVariantList list;
    for (const auto &alarm: m_alarms)
    {
        list.append(QVariant::fromValue(alarm));
    }
    return list;
}

AlarmClockCtrl::AlarmClockCtrl(QObject *parent) : QObject(parent)
{
    qRegisterMetaType<Alarm>("Alarm");
    loadAlarms(); // 加载保存的闹钟

    Beep::instance()->acquire();// 获取Beep实例,为了确保在闹钟开启时可以关闭蜂鸣器
}

AlarmClockCtrl::~AlarmClockCtrl()
{
    Beep::instance()->setState(false);
    Beep::instance()->release();
}

QString AlarmClockCtrl::getAlarmsFilePath() const {
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(path);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    return path + "/alarms.json";
}

void AlarmClockCtrl::saveAlarms() {
    QVariantList alarmsList;
    for (const auto &alarm : m_alarms) {
        QVariantMap alarmMap;
        alarmMap["time"] = alarm.time.toString("hh:mm");
        alarmMap["active"] = alarm.active;
        alarmMap["repeatDays"] = alarm.repeatDays;
        alarmMap["label"] = alarm.label;
        alarmsList.append(alarmMap);
    }

    QFile file(getAlarmsFilePath());
    if (file.open(QIODevice::WriteOnly)) {
        QJsonDocument doc(QJsonArray::fromVariantList(alarmsList));
        file.write(doc.toJson());
        file.close();
    }
}

void AlarmClockCtrl::loadAlarms() {
    QFile file(getAlarmsFilePath());
    if (!file.exists()) return;

    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "Failed to open alarms file";
        return;
    }

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(file.readAll(), &parseError);
    file.close();

    if (parseError.error != QJsonParseError::NoError) {
        qDebug() << "JSON parse error:" << parseError.errorString();
        return;
    }

    if (!doc.isArray()) return;

    m_alarms.clear();
    QVariantList alarmsList = doc.array().toVariantList();
    for (const QVariant &var : alarmsList) {
        QVariantMap alarmMap = var.toMap();
        Alarm alarm;
        alarm.time = QTime::fromString(alarmMap["time"].toString(), "hh:mm");
        if (!alarm.time.isValid()) continue;
        alarm.active = alarmMap.value("active", true).toBool();
        alarm.repeatDays = alarmMap.value("repeatDays").toList();
        alarm.label = alarmMap.value("label").toString();
        m_alarms.append(alarm);
    }
    emit alarmsChanged();
}

void AlarmClockCtrl::addAlarm(QString time, QVariantList repeatDays, QString label)
{
//    qDebug() << "addAlarm" << time << repeatDays << label;

    Alarm alarm;
    alarm.time = parseTime(time);
    alarm.active = true;
    alarm.repeatDays = repeatDays;
    alarm.label = label;

    m_alarms.append(alarm);
    emit alarmsChanged();
    saveAlarms();
}

void AlarmClockCtrl::removeAlarm(int index)
{
    if (index >= 0 && index < m_alarms.size())
    {
        m_alarms.removeAt(index);
        emit alarmsChanged();
        saveAlarms();
    }
}

void AlarmClockCtrl::toggleAlarm(int index)
{
    if (index >= 0 && index < m_alarms.size())
    {
        m_alarms[index].active = !m_alarms[index].active;
        if(!m_alarms[index].active)
        {
            // 关闭蜂鸣器，确保不会在响的时候停不下来
            Beep::instance()->setState(false);
        }
        emit alarmsChanged();
        saveAlarms();
    }
}

void AlarmClockCtrl::checkAlarms() {
    QDateTime currentDateTime = QDateTime::currentDateTime();
    QTime currentTime = currentDateTime.time();
    QDate currentDate = currentDateTime.date();

    for (const Alarm &alarm : m_alarms) {
        if (!alarm.active) continue;

        bool shouldTrigger = false;

        if (alarm.repeatDays.isEmpty()) {
            // 非重复闹钟：检查当前时间是否匹配
            shouldTrigger = (alarm.time.hour() == currentTime.hour()
                             && alarm.time.minute() == currentTime.minute());
        } else {
            // 重复闹钟：原有逻辑
            int currentDayOfWeek = currentDate.dayOfWeek();
            bool isRepeatDay = false;
            for (const QVariant &day : alarm.repeatDays) {
                if (day.toInt() == currentDayOfWeek - 1) {
                    isRepeatDay = true;
                    break;
                }
            }
            shouldTrigger = isRepeatDay
                            && alarm.time.hour() == currentTime.hour()
                            && alarm.time.minute() == currentTime.minute();
        }

        if (shouldTrigger) {
            triggerAlarm(alarm);
        }
    }
}

void AlarmClockCtrl::triggerAlarm(const Alarm &alarm)
{
    qDebug() << "Alarm triggered: " << alarm.label;

    static bool isAlarmTriggered = false;
    isAlarmTriggered = !isAlarmTriggered;
    Beep::instance()->setState(isAlarmTriggered);

    // 如果是非重复闹钟，触发后自动禁用
    if (alarm.repeatDays.isEmpty()) {
        const_cast<Alarm&>(alarm).active = false;  // 注意：需要移除const修饰
        emit alarmsChanged();
        saveAlarms();
    }
}

QDateTime AlarmClockCtrl::getNextTriggerTimeForAlarm(const Alarm &alarm) const {
    if (!alarm.active) return QDateTime();

    QDateTime now = QDateTime::currentDateTime();
    QTime alarmTime = alarm.time;

    // 处理非重复闹钟
    if (alarm.repeatDays.isEmpty()) {
        QDateTime todayAlarm(now.date(), alarmTime);
        return (todayAlarm > now) ? todayAlarm : QDateTime();
    }

    // 处理重复闹钟
    for (int i = 0; i <= 7; ++i) { // 最多检查7天
        QDate checkDate = now.date().addDays(i);
        int dayOfWeek = checkDate.dayOfWeek() - 1; // 转换为0-based (0=周一)

        if (alarm.repeatDays.contains(dayOfWeek)) {
            QDateTime candidate(checkDate, alarmTime);
            if (candidate >= now) {
                return candidate;
            }
        }
    }
    return QDateTime();
}

QDateTime AlarmClockCtrl::getNextTriggerTime() const {
    QDateTime nextTrigger;
    for (const Alarm &alarm : m_alarms) {
        if (!alarm.active) continue;
        QDateTime triggerTime = getNextTriggerTimeForAlarm(alarm);
        if (triggerTime.isValid() && (!nextTrigger.isValid() || triggerTime < nextTrigger)) {
            nextTrigger = triggerTime;
        }
    }
    return nextTrigger;
}