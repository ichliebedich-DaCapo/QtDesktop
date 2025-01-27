#ifndef FILEEXPLORERCTRL_H
#define FILEEXPLORERCTRL_H

#include <QObject>
#include <QDir>
#include <QVariantList>

class FileExplorerCtrl : public QObject {
Q_OBJECT
public:
    explicit FileExplorerCtrl(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getFileModel();
    Q_INVOKABLE void openFile(const QString &filePath);
    Q_INVOKABLE void goUp();
    Q_INVOKABLE QString getCurrentPath();
    Q_INVOKABLE QString getFileSize(const QString &fileName);
    Q_INVOKABLE void deleteFile(const QString &fileName);
    Q_INVOKABLE void renameFile(const QString &oldName, const QString &newName);

signals:
    void fileModelChanged();

private:
    QDir currentDir;
    QString formatFileSize(qint64 bytes);  // 格式化文件大小
};

#endif // FILEEXPLORERCTRL_H