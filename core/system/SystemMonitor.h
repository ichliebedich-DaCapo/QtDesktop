#ifndef SYSTEMMONITOR_H
#define SYSTEMMONITOR_H

#include <QObject>
#include <QTimer>
#include <QmlTypeAndRevisionsRegistration>

class SystemMonitor : public QObject
{
Q_OBJECT
    Q_PROPERTY(QString cpuTemp READ cpuTemp NOTIFY cpuTempChanged)
    QML_SINGLETON // 声明为单例

public:
    explicit SystemMonitor(QObject *parent = nullptr);

    QString cpuTemp() const;

    // 提供单例实例的静态方法
    static SystemMonitor *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine);

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