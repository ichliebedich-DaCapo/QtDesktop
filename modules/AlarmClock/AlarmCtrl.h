#pragma once
#include <QObject>
#include <QTime>
#include <QVector>
#include <QSettings>

struct AlarmItem {
    bool enabled;
    QTime time;
    QString days;
    QString label;
};

class AlarmCtrl : public QObject {
Q_OBJECT
public:
    explicit AlarmCtrl(QObject *parent = nullptr);

    Q_INVOKABLE void addAlarm(int hours, int minutes, const QString &days, const QString &label);
    Q_INVOKABLE void removeAlarm(int index);
    Q_INVOKABLE void toggleAlarm(int index, bool enabled);

    const QVector<AlarmItem>& alarms() const { return m_alarms; }

signals:
    void alarmsChanged();

private:
    void loadAlarms();
    void saveAlarms();

    QVector<AlarmItem> m_alarms;
    QSettings m_settings;
};