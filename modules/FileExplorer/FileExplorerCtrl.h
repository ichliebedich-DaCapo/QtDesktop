#ifndef FILEEXPLORERCTRL_H
#define FILEEXPLORERCTRL_H

#include <QObject>
#include <QDir>
#include <QVariantList>
#include <QFileInfo>


class FileExplorerCtrl : public QObject {
Q_OBJECT
public:
    explicit FileExplorerCtrl(QObject *parent = nullptr);

    // 获取文件列表
    Q_INVOKABLE QVariantList getFileModel();

    // 打开文件或文件夹
    Q_INVOKABLE void openFile(const QString &filePath);

    // 返回上一级目录
    Q_INVOKABLE void goUp();

    // 回到 Home 目录
    Q_INVOKABLE void goHome();

    // 获取当前路径
    Q_INVOKABLE QString getCurrentPath();

    // 获取文件大小
    Q_INVOKABLE QString getFileSize(const QString &fileName);

    // 删除文件
    Q_INVOKABLE void deleteFile(const QString &fileName);

    // 重命名文件
    Q_INVOKABLE void renameFile(const QString &oldName, const QString &newName);

    // 搜索文件
    Q_INVOKABLE QVariantList searchFiles(const QString &keyword);

signals:
    // 文件列表更新信号
    void fileModelChanged();

private:
    QDir currentDir; // 当前目录

    // 格式化文件大小
    QString formatFileSize(qint64 bytes);
};

#endif // FILEEXPLORERCTRL_H