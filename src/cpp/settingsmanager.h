#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>
#include <QString>

class SettingsManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString hashedPassword READ hashedPassword WRITE setHashedPassword NOTIFY hashedPasswordChanged)

public:
    explicit SettingsManager(QObject *parent = nullptr);
    
    QString hashedPassword() const;
    void setHashedPassword(const QString &password);
    
    Q_INVOKABLE QString hashPassword(const QString &password, const QString &salt = QString());
    Q_INVOKABLE bool verifyPassword(const QString &password, const QString &hashedPassword);

signals:
    void hashedPasswordChanged();

private:
    QSettings m_settings;
    QString m_hashedPassword;
};

#endif // SETTINGSMANAGER_H 