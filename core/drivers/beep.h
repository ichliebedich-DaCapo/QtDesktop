#ifndef BEEP_H
#define BEEP_H

#include <QObject>
#include <QMutex>
#include <QAtomicInteger>


/**
 * @brief Beep: 蜂鸣器控制类
 * @note acquire与release必须成对出现
 */
class Beep : public QObject
{
Q_OBJECT
public:
    static Beep* instance();

    // 应用组件调用接口
    void acquire();    // 申请蜂鸣器资源
    void release();    // 释放蜂鸣器资源
    bool setState(bool active); // 设置蜂鸣器状态

private:
    explicit Beep(QObject *parent = nullptr);
    ~Beep();

    bool openDevice();
    void closeDevice();

    static QMutex m_instanceMutex;
    static Beep* m_instance;

    QMutex m_operationMutex;
    QAtomicInteger<int> m_refCount = 0;
    int m_fd = -1;
    const QString m_brightnessFile = "/sys/devices/platform/leds/leds/beep/brightness";
};

#endif // BEEP_H