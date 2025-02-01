#pragma once
#include <QCoreApplication>
#include <QFile>
#include <QStandardPaths>
#include <QDir>

class AutoStart {
public:
    static void ensureService();
};