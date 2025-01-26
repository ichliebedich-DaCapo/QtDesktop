#ifndef SYSTEMMONITOR_H
#define SYSTEMMONITOR_H

#include <QObject>
#include <QTimer>

class SystemMonitor : public QObject
{
Q_OBJECT
    Q_PROPERTY(QString cpuTemp READ cpuTemp NOTIFY cpuTempChanged)

public:
    explicit SystemMonitor(QObject *parent = nullptr);

    QString cpuTemp() const;

signals:
    void cpuTempChanged();

private slots:
    void updateCpuTemp();

private:
    QString readCpuTemp();

    QString m_cpuTemp;
    QTimer *m_timer;
};

#endif // SYSTEMMONITOR_H