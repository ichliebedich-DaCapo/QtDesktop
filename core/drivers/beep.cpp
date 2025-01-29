// Beep.cpp 核心实现
#include "beep.h"
#include <fcntl.h>
#include <QDebug>


QMutex Beep::m_instanceMutex;
Beep* Beep::m_instance = nullptr;


Beep::Beep(QObject *parent)
        : QObject(parent),
          m_fd(-1)  // 显式初始化文件描述符为无效值
{
    // 注意：设备文件在首次acquire()时才会打开
    qDebug() << "Beep instance created";
}

Beep::~Beep()
{
    QMutexLocker locker(&m_operationMutex);

    // 安全关闭设备（即使有未释放的引用）
    if (m_fd != -1) {
        ::close(m_fd);  // 使用全局命名空间的close
        m_fd = -1;
        qDebug() << "Beep device force closed in destructor";
    }

    // 单例实例指针置空（重要！）
    QMutexLocker instanceLocker(&m_instanceMutex);
    m_instance = nullptr;

    qDebug() << "Beep instance destroyed";
}


Beep* Beep::instance()
{
    QMutexLocker locker(&m_instanceMutex);
    if (!m_instance) {
        m_instance = new Beep();
    }
    return m_instance;
}

void Beep::acquire()
{
    QMutexLocker locker(&m_operationMutex);
    if (m_refCount.fetchAndAddRelaxed(1) == 0) {
        openDevice();
    }
}

void Beep::release()
{
    QMutexLocker locker(&m_operationMutex);
    if (m_refCount.fetchAndSubRelaxed(1) == 1) {
        closeDevice();
    }
}

bool Beep::setState(bool active)
{
    QMutexLocker locker(&m_operationMutex);
    if (m_fd == -1) return false;

    const char value = active ? '1' : '0';
    if (write(m_fd, &value, 1) != 1) {
        qWarning() << "Failed to set beep state";
        return false;
    }
    return true;
}

bool Beep::openDevice()
{
    m_fd = open(m_brightnessFile.toUtf8().constData(), O_WRONLY);
    if (m_fd == -1) {
        qCritical() << "Failed to open beep device";
        return false;
    }
    return true;
}

void Beep::closeDevice()
{
    if (m_fd != -1) {
        close(m_fd);
        m_fd = -1;
    }
}