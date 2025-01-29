// modules/AlarmClock/AlarmClockCtrl.cpp
#include "AlarmClockCtrl.h"
#include <QDebug>

QVariantList AlarmClockCtrl::alarms() const
{
    QVariantList list;
    for (const auto &alarm: m_alarms)
    {
        list.append(QVariant::fromValue(alarm));
    }
    return list;
}

// 在构造函数添加类型注册
AlarmClockCtrl::AlarmClockCtrl(QObject *parent) : QObject(parent), m_timer(new QTimer(this))
{
    qRegisterMetaType<Alarm>("Alarm");

    // 连接定时器的 timeout() 信号到 checkAlarms 槽
    connect(m_timer, &QTimer::timeout, this, &AlarmClockCtrl::checkAlarms);

    // 设置定时器间隔为1秒（1000毫秒）
    m_timer->start(1000);
}

void AlarmClockCtrl::addAlarm(QString time, QVariantList repeatDays, QString label)
{
    Alarm alarm;
    alarm.time = parseTime(time);
    alarm.active = true;
    alarm.repeatDays = repeatDays; // 直接使用QVariantList
    alarm.label = label;


    m_alarms.append(alarm);
    emit alarmsChanged();
}

void AlarmClockCtrl::removeAlarm(int index)
{
    if (index >= 0 && index < m_alarms.size())
    {
        m_alarms.removeAt(index);
        emit alarmsChanged();
    }
}

void AlarmClockCtrl::toggleAlarm(int index)
{
    if (index >= 0 && index < m_alarms.size())
    {
        m_alarms[index].active = !m_alarms[index].active;
        emit alarmsChanged();
    }
}

void AlarmClockCtrl::checkAlarms()
{
    QTime current = QTime::currentTime();
    for (const Alarm &alarm: m_alarms)
    {
        if (alarm.active && alarm.time.hour() == current.hour()
            && alarm.time.minute() == current.minute())
        {
            triggerAlarm(alarm); // 触发闹钟响铃
        }
    }
}

void AlarmClockCtrl::triggerAlarm(const Alarm &alarm)
{
    qDebug() << "Alarm triggered: " << alarm.label;
}


AlarmClockCtrl::~AlarmClockCtrl()
{
    // 确保在析构时停止并删除定时器
    if (m_timer)
    {
        m_timer->stop();
        delete m_timer;
    }
}