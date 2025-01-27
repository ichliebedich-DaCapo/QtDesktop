#include "FileExplorerCtrl.h"
#include <QDir>
#include <QFileInfo>
#include <QDebug>

FileExplorerCtrl::FileExplorerCtrl(QObject *parent) : QObject(parent), currentDir(QDir::homePath()) {}

QVariantList FileExplorerCtrl::getFileModel() {
    QVariantList fileList;
    QStringList files = currentDir.entryList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);

    if (currentDir != QDir::homePath()) {
        fileList.append(QVariantMap{{"name", ".."}, {"type", "folder"}});  // 返回上一级
    }

    for (const QString &file : files) {
        QFileInfo fileInfo(currentDir, file);
        QString type = fileInfo.isDir() ? "folder" : "file";
        fileList.append(QVariantMap{{"name", file}, {"type", type}});
    }

    return fileList;
}

void FileExplorerCtrl::openFile(const QString &filePath) {
    QFileInfo fileInfo(currentDir, filePath);
    if (fileInfo.isDir()) {
        currentDir.cd(filePath);
        emit fileModelChanged();
    } else {
        qDebug() << "Opening file:" << fileInfo.absoluteFilePath();
    }
}

void FileExplorerCtrl::goUp() {
    if (currentDir.cdUp()) {
        emit fileModelChanged();
    }
}

QString FileExplorerCtrl::getCurrentPath() {
    return currentDir.absolutePath();
}

QString FileExplorerCtrl::getFileSize(const QString &fileName) {
    QFileInfo fileInfo(currentDir, fileName);
    if (fileInfo.isFile()) {
        return formatFileSize(fileInfo.size());
    }
    return "";
}

void FileExplorerCtrl::deleteFile(const QString &fileName) {
    QFile file(currentDir.filePath(fileName));
    if (file.remove()) {
        emit fileModelChanged();
    }
}

void FileExplorerCtrl::renameFile(const QString &oldName, const QString &newName) {
    QFile file(currentDir.filePath(oldName));
    if (file.rename(newName)) {
        emit fileModelChanged();
    }
}

QString FileExplorerCtrl::formatFileSize(qint64 bytes) {
    constexpr qint64 KB = 1024;
    constexpr qint64 MB = 1024 * KB;
    constexpr qint64 GB = 1024 * MB;

    if (bytes >= GB) {
        return QString("%1 GB").arg(QString::number(bytes / (double)GB, 'f', 2));
    } else if (bytes >= MB) {
        return QString("%1 MB").arg(QString::number(bytes / (double)MB, 'f', 1));
    } else if (bytes >= KB) {
        return QString("%1 KB").arg(QString::number(bytes / (double)KB, 'f', 0));
    } else {
        return QString("%1 B").arg(bytes);
    }
}