#include "SystemMonitor.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <unistd.h>
#include <fcntl.h>

// 静态单例实例
static SystemMonitor *s_instance = nullptr;

SystemMonitor::SystemMonitor(QObject *parent) : QObject(parent)
{
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &SystemMonitor::updateCpuTemp);
    m_timer->start(1500); // 每1.5秒更新一次
}

QString SystemMonitor::cpuTemp() const
{
    return m_cpuTemp;
}

void SystemMonitor::updateCpuTemp()
{
    QString temp = readCpuTemp();
    if (temp != m_cpuTemp)
    {
        m_cpuTemp = temp;
        emit cpuTempChanged();
    }
}

QString SystemMonitor::readCpuTemp()
{
    const char *filename = "/sys/class/hwmon/hwmon0/temp1_input";
    int fd = open(filename, O_RDONLY);
    if (fd < 0)
    {
        qWarning() << "Failed to open file:" << filename;
        return "N/A";
    }

    char buf[10];
    int err = read(fd, buf, sizeof(buf));
    close(fd);

    if (err < 0)
    {
        qWarning() << "Failed to read file:" << filename;
        return "N/A";
    }

    QString tempValue = buf;
    double temp_data = tempValue.split("\n")[0].toDouble() / 1000.0f;
    return QString::number(temp_data, 'f', 2) + "°C";
}

// 实现单例实例的静态方法
SystemMonitor *SystemMonitor::instance()
{
    if (!s_instance)
    {
        s_instance = new SystemMonitor();
    }
    return s_instance;
}

// 提供单例实例的静态方法，用于 QML 注册
QObject *SystemMonitor::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(qmlEngine);
    Q_UNUSED(jsEngine);
    return SystemMonitor::instance();
}