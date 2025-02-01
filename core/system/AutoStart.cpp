#include "AutoStart.h"
#include <QFile>
#include <QStandardPaths>

void AutoStart::ensureService()
{
// 嵌入式系统建议使用systemd方案
    const QString desktopFile = "/opt/QDesktop";

    if (!QFile::exists(desktopFile))
    {
        QFile file(desktopFile);
        if (file.open(QIODevice::WriteOnly))
        {
            QString execPath = QCoreApplication::applicationFilePath();
            QString content =
                    "[Desktop Entry]\n"
                    "Type=Application\n"
                    "Name=QDesktop Service\n"
                    "Exec=" + execPath + " -service\n"
                                         "X-GNOME-Autostart-enabled=true\n";

            file.write(content.toUtf8());
            file.setPermissions(QFile::ReadOwner | QFile::WriteOwner | QFile::ExeOwner);
        }
    }
}