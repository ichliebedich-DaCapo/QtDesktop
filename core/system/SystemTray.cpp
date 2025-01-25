//
// Created by fairy on 2025/1/25 11:17.
//
#include "SystemTray.h"
SystemTray::SystemTray(QObject *parent) : QObject(parent) {
    connect(&m_monitorTimer, &QTimer::timeout, this, &SystemTray::updateSystemStatus);
    m_monitorTimer.start(5000); // 5秒更新一次
}

void SystemTray::updateSystemStatus() {
    // 实际嵌入式系统调用示例
//    m_battery = readBatteryLevel();  // 调用底层驱动
//    m_network = checkNetworkStatus();
//
//    emit batteryChanged(m_battery);
//    emit networkChanged(m_network);
}
