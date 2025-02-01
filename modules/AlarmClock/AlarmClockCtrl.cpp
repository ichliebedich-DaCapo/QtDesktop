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

AlarmClockCtrl::AlarmClockCtrl(QObject *parent) : QObject(parent), m_timer(new QTimer(this))
{
    qRegisterMetaType<Alarm>("Alarm");
    loadAlarms(); // 加载保存的闹钟

    connect(m_timer, &QTimer::timeout, this, &AlarmClockCtrl::checkAlarms);
    m_timer->start(1000);
    Beep::instance()->acquire();
}

AlarmClockCtrl::~AlarmClockCtrl()
{
    if (m_timer)
    {
        m_timer->stop();
        delete m_timer;
    }
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
    qDebug() << "addAlarm" << time << repeatDays << label;

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
            Beep::instance()->setState(false);
        }
        emit alarmsChanged();
        saveAlarms();
    }
}

void AlarmClockCtrl::checkAlarms()
{
    QTime currentTime = QTime::currentTime();
    QDate currentDate = QDate::currentDate();

    for (const Alarm &alarm : m_alarms) {
        if (!alarm.active) continue;

        int currentDayOfWeek = currentDate.dayOfWeek();
        bool isRepeatDay = false;
        for (const QVariant &day : alarm.repeatDays) {
            if (day.toInt() == currentDayOfWeek - 1) {
                isRepeatDay = true;
                break;
            }
        }

        if (isRepeatDay && alarm.time.hour() == currentTime.hour()
            && alarm.time.minute() == currentTime.minute()) {
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
}