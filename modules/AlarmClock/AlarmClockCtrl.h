// modules/AlarmClock/AlarmClockCtrl.h
#pragma once
#include <QObject>
#include <QVariant>
#include <QVector>
#include <QTime>
#include <QTimer>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QDir>

struct Alarm {
Q_GADGET
    Q_PROPERTY(QString timeStr READ timeStr CONSTANT)
    Q_PROPERTY(bool active MEMBER active)
    Q_PROPERTY(QVariantList repeatDays MEMBER repeatDays)
    Q_PROPERTY(QString label MEMBER label)

public:
    QTime time;
    bool active = true;
    bool isTriggered = false;// 是否触发过
    QVariantList repeatDays;
    QString label;

    QString timeStr() const {
        return time.isValid() ? time.toString("hh:mm") : "--:--";
    }
};
Q_DECLARE_METATYPE(Alarm)



class AlarmClockCtrl : public QObject {
Q_OBJECT
    Q_PROPERTY(QVariantList alarms READ alarms NOTIFY alarmsChanged)
public:
    explicit AlarmClockCtrl(QObject *parent = nullptr);
    ~AlarmClockCtrl();

    Q_INVOKABLE void addAlarm(QString time, QVariantList repeatDays, QString label);
    Q_INVOKABLE void removeAlarm(int index);
    Q_INVOKABLE void toggleAlarm(int index);

    Q_INVOKABLE QTime parseTime(const QString &timeStr) {
        return QTime::fromString(timeStr, "hh:mm");
    }

    Q_INVOKABLE QString formatTime(const QTime &time) {
        return time.toString("hh:mm");
    }

    QVariantList alarms() const;

    void closeAlarm(Alarm& alarm);
    void saveAlarms();
    void loadAlarms();
    QDateTime getNextTriggerTime() const;
    QDateTime getNextTriggerTimeForAlarm(const Alarm &alarm) const;

public slots:
    void checkAlarms();
    void triggerAlarm(const Alarm &alarm);

signals:
    void alarmsChanged();

private:
    QString getAlarmsFilePath() const;

    QVector<Alarm> m_alarms;
};