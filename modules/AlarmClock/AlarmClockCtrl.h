// modules/AlarmClock/AlarmClockCtrl.h
#pragma once
#include <QObject>
#include <QVariant>
#include <QVector>
#include <QTime>
#include <QTimer>

class Alarm {
Q_GADGET
    Q_PROPERTY(QTime time MEMBER time)
    Q_PROPERTY(bool active MEMBER active)
    Q_PROPERTY(QVariantList repeatDays MEMBER repeatDays)
    Q_PROPERTY(QString label MEMBER label)
public:
    QTime time;
    bool active = true;
    QVariantList repeatDays;  // 改为QVariantList
    QString label;
};
Q_DECLARE_METATYPE(Alarm)

class AlarmClockCtrl : public QObject {
Q_OBJECT
    Q_PROPERTY(QVariantList alarms READ alarms NOTIFY alarmsChanged) // 改为QVariantList
public:
    explicit AlarmClockCtrl(QObject *parent = nullptr);
    ~AlarmClockCtrl(); // 析构函数

    Q_INVOKABLE void addAlarm(QString time, QVariantList repeatDays, QString label);
    Q_INVOKABLE void removeAlarm(int index);
    Q_INVOKABLE void toggleAlarm(int index);

    // 辅助方法：将 "hh:mm" 字符串转为 QTime
    Q_INVOKABLE QTime parseTime(const QString &timeStr) {
        return QTime::fromString(timeStr, "hh:mm");
    }

    // 辅助方法：将 QTime 转为 "hh:mm" 字符串供 QML 显示
    Q_INVOKABLE QString formatTime(const QTime &time) {
        return time.toString("hh:mm");
    }

    QVariantList alarms() const;

public slots:
    void checkAlarms();
    void triggerAlarm(const Alarm &alarm); // 假设你已经实现了这个方法

signals:
    void alarmsChanged();

private:
    QVector<Alarm> m_alarms;
    QTimer* m_timer; // 添加一个定时器成员变量
};