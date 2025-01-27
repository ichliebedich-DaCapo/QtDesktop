#include "FileExplorerCtrl.h"
#include <QDir>
#include <QFileInfo>

FileExplorerCtrl::FileExplorerCtrl(QObject *parent) : QObject(parent), currentDir(QDir::homePath()) {}

QVariantList FileExplorerCtrl::getFileModel() {
    QVariantList fileList;
    QStringList files = currentDir.entryList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);

    // 添加返回上一级的选项
    if (currentDir != QDir::homePath()) {
        fileList.append(QVariantMap{{"name", ".."}, {"type", "folder"}});
    }

    // 添加文件和文件夹
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
        // 如果是文件夹，进入该文件夹
        currentDir.cd(filePath);
        emit fileModelChanged(); // 通知 QML 更新文件列表
    } else {
        // 如果是文件，执行打开操作
//        qDebug() << "Opening file:" << fileInfo.absoluteFilePath();
        // 在这里实现打开文件的逻辑
    }
}

void FileExplorerCtrl::goUp() {
    if (currentDir.cdUp()) {
        emit fileModelChanged(); // 通知 QML 更新文件列表
    }
}

void FileExplorerCtrl::goHome() {
    currentDir.setPath(QDir::homePath()); // 设置当前目录为 Home 目录
    emit fileModelChanged(); // 通知 QML 更新文件列表
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
        emit fileModelChanged(); // 通知 QML 更新文件列表
    } else {
//        qDebug() << "Failed to delete file:" << file.errorString();
    }
}

void FileExplorerCtrl::renameFile(const QString &oldName, const QString &newName) {
    QString oldPath = currentDir.filePath(oldName);
    QString newPath = currentDir.filePath(newName);

    QFile file(oldPath);
    if (file.rename(newPath)) {
        emit fileModelChanged(); // 通知 QML 更新文件列表
    } else {
//        qDebug() << "Failed to rename file:" << file.errorString();
    }
}

QVariantList FileExplorerCtrl::searchFiles(const QString &keyword) {
    QVariantList result;
    QStringList files = currentDir.entryList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);

    for (const QString &file : files) {
        if (file.contains(keyword, Qt::CaseInsensitive)) {
            QFileInfo fileInfo(currentDir, file);
            QString type = fileInfo.isDir() ? "folder" : "file";
            result.append(QVariantMap{{"name", file}, {"type", type}});
        }
    }

    return result;
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