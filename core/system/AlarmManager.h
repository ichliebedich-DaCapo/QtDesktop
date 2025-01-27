// AlarmManager.h
#pragma once
#include <QObject>
#include <QVariantList>
#include <QTime>
#include <QSettings>

struct AlarmItem {
    bool enabled;
    QTime time;
    QString repeat;
    QString label;
    int id;

    // 将 AlarmItem 转换为 QVariantMap，供 QML 使用
    QVariantMap toVariantMap() const {
        return {
                {"enabled", enabled},
                {"time", time.toString("hh:mm")},
                {"repeat", repeat},
                {"label", label},
                {"id", id}
        };
    }
};



class AlarmManager : public QObject {
Q_OBJECT
public:
    explicit AlarmManager(QObject *parent = nullptr);

    Q_PROPERTY(QVariantList alarms READ alarms NOTIFY alarmsChanged)

    Q_INVOKABLE void addAlarm(const QTime &time, const QString &label);
    Q_INVOKABLE void removeAlarm(int id);
    Q_INVOKABLE void toggleAlarm(int id, bool enabled);

    QVariantList alarms() const;

signals:
    void alarmsChanged();
    void alarmTriggered(int id);

private:
    void loadAlarms();
    void saveAlarms();

    QVector<AlarmItem> m_alarms;
    QSettings m_settings;
};