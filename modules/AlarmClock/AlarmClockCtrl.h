// modules/AlarmClock/AlarmClockCtrl.h
#pragma once
#include <QObject>
#include <QVector>
#include <QTime>

struct Alarm {
    QTime time;
    bool active;
    QVector<int> repeatDays;
    QString label;
};

class AlarmClockCtrl : public QObject {
Q_OBJECT
    Q_PROPERTY(QVector<Alarm> alarms READ alarms NOTIFY alarmsChanged)
public:
    explicit AlarmClockCtrl(QObject *parent = nullptr);

    Q_INVOKABLE void addAlarm(QString time, QVariantList repeatDays, QString label);
    Q_INVOKABLE void removeAlarm(int index);
    Q_INVOKABLE void toggleAlarm(int index);

    QVector<Alarm> alarms() const { return m_alarms; }

signals:
    void alarmsChanged();

private:
    QVector<Alarm> m_alarms;
};