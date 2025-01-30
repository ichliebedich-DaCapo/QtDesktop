// modules/AlarmClock/AlarmClockCtrl.cpp
#include "AlarmClockCtrl.h"
#include <QDebug>
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

// 在构造函数添加类型注册
AlarmClockCtrl::AlarmClockCtrl(QObject *parent) : QObject(parent), m_timer(new QTimer(this))
{
    qRegisterMetaType<Alarm>("Alarm");

    // 连接定时器的 timeout() 信号到 checkAlarms 槽
    connect(m_timer, &QTimer::timeout, this, &AlarmClockCtrl::checkAlarms);

    // 设置定时器间隔为1秒（1000毫秒）
    m_timer->start(1000);

    // 获取Beep
    Beep::instance()->acquire();
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
    QTime currentTime = QTime::currentTime();
    QDate currentDate = QDate::currentDate();

    for (const Alarm &alarm : m_alarms) {
        if (!alarm.active) continue;

        // 获取当前是星期几（Qt 中周日是 7，周一到周六分别是 1-6）
        int currentDayOfWeek = currentDate.dayOfWeek();

        // 检查是否在 repeatDays 中
        bool isRepeatDay = false;
        for (const QVariant &day : alarm.repeatDays) {
            if (day.toInt() == currentDayOfWeek - 1) { // 因为你的 repeatDays 是从 0 开始的
                isRepeatDay = true;
                break;
            }
        }

        if (isRepeatDay && alarm.time.hour() == currentTime.hour()
            && alarm.time.minute() == currentTime.minute()) {
            triggerAlarm(alarm); // 触发闹钟响铃
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


AlarmClockCtrl::~AlarmClockCtrl()
{
    // 确保在析构时停止并删除定时器
    if (m_timer)
    {
        m_timer->stop();
        delete m_timer;
    }

    // 释放Beep
    Beep::instance()->release();
}