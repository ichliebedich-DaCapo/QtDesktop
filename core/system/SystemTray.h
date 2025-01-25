#include <QObject>
#include <QTimer>

class SystemTray : public QObject {
Q_OBJECT
    Q_PROPERTY(int batteryLevel READ batteryLevel NOTIFY batteryChanged)
    Q_PROPERTY(QString networkStatus READ networkStatus NOTIFY networkChanged)

public:
    explicit SystemTray(QObject *parent = nullptr);

    int batteryLevel() const { return m_battery; }
    QString networkStatus() const { return m_network; }

public slots:
//    void showWarning(const QString &msg);

signals:
    void batteryChanged(int level);
    void networkChanged(QString status);

private:
    QTimer m_monitorTimer;
    int m_battery = 100;
    QString m_network = "4G";

    void updateSystemStatus();
};