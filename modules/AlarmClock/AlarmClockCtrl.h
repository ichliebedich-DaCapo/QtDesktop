// modules/AlarmClock/AlarmClockCtrl.h
#pragma once
#include <QObject>
#include <QVariant>
#include <QVector>
#include <QTime>


struct Alarm {
Q_GADGET
    Q_PROPERTY(QString timeStr READ timeStr)  // 确保存在该属性
    Q_PROPERTY(bool active MEMBER active)
    Q_PROPERTY(QVariantList repeatDays MEMBER repeatDays)
    Q_PROPERTY(QString label MEMBER label)

public:
    QTime time;
    bool active = true;
    QVariantList repeatDays;
    QString label;

    // 确保该方法实际存在且正确实现
    QString timeStr() const {
        return time.isValid() ? time.toString("hh:mm") : "--:--";
    }
};
Q_DECLARE_METATYPE(Alarm)

class AlarmClockCtrl : public QObject {
Q_OBJECT
    Q_PROPERTY(QVariantList alarms READ alarms NOTIFY alarmsChanged) // 改为QVariantList
public:
    explicit AlarmClockCtrl(QObject *parent = nullptr);

    Q_INVOKABLE void addAlarm(QString time, QVariantList repeatDays, QString label);
    Q_INVOKABLE void removeAlarm(int index);
    Q_INVOKABLE void toggleAlarm(int index);

    QVariantList alarms() const;

signals:
    void alarmsChanged();

private:
    QVector<Alarm> m_alarms;
};