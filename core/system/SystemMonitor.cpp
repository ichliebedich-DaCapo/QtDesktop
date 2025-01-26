#include "SystemMonitor.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <unistd.h>
#include <fcntl.h>

SystemMonitor::SystemMonitor(QObject *parent) : QObject(parent)
{
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &SystemMonitor::updateCpuTemp);
    m_timer->start(1000); // 每秒更新一次
}

QString SystemMonitor::cpuTemp() const
{
    return m_cpuTemp;
}

void SystemMonitor::updateCpuTemp()
{
    QString temp = readCpuTemp();
    if (temp != m_cpuTemp) {
        m_cpuTemp = temp;
        emit cpuTempChanged();
    }
}

QString SystemMonitor::readCpuTemp()
{
    const char *filename = "/sys/class/hwmon/hwmon0/temp1_input";
    int fd = open(filename, O_RDONLY);
    if (fd < 0) {
        qWarning() << "Failed to open file:" << filename;
        return "N/A";
    }

    char buf[10];
    int err = read(fd, buf, sizeof(buf));
    close(fd);

    if (err < 0) {
        qWarning() << "Failed to read file:" << filename;
        return "N/A";
    }

    QString tempValue = QString::fromUtf8(buf).trimmed();
    double temp_data = tempValue.toDouble() / 1000;
    return QString::number(temp_data, 'f', 2) + "°C";
}