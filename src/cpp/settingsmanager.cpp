#include "settingsmanager.h"
#include <QCryptographicHash>
#include <QRandomGenerator>

SettingsManager::SettingsManager(QObject *parent)
    : QObject(parent)
    , m_settings("YourCompany", "WMS")
{
    // 检查是否存在已保存的密码
    if (m_settings.contains("hashedPassword")) {
        m_hashedPassword = m_settings.value("hashedPassword").toString();
    } else {
        // 如果没有，创建默认密码 "admin" 的哈希
        m_hashedPassword = hashPassword("admin");
        m_settings.setValue("hashedPassword", m_hashedPassword);
    }
}

QString SettingsManager::hashedPassword() const
{
    return m_hashedPassword;
}

void SettingsManager::setHashedPassword(const QString &password)
{
    if (m_hashedPassword != password) {
        m_hashedPassword = password;
        m_settings.setValue("hashedPassword", password);
        emit hashedPasswordChanged();
    }
}

QString SettingsManager::hashPassword(const QString &password, const QString &salt)
{
    // 使用更安全的哈希算法
    QString usedSalt = salt;
    if (usedSalt.isEmpty()) {
        // 生成随机盐值
        const quint32 value = QRandomGenerator::global()->generate();
        usedSalt = QString::number(value, 16);
    }
    
    // 使用PBKDF2算法的简化版本
    QByteArray passwordBytes = password.toUtf8();
    QByteArray saltBytes = usedSalt.toUtf8();
    
    // 迭代1000次
    QByteArray hash = passwordBytes + saltBytes;
    for (int i = 0; i < 1000; i++) {
        hash = QCryptographicHash::hash(hash, QCryptographicHash::Sha256);
    }
    
    return QString("1000:%1:%2").arg(usedSalt).arg(QString(hash.toHex()));
}

bool SettingsManager::verifyPassword(const QString &password, const QString &hashedPassword)
{
    QStringList parts = hashedPassword.split(':');
    if (parts.size() != 3) {
        return false;
    }
    
    QString salt = parts[1];
    QString calculatedHash = hashPassword(password, salt);
    
    return calculatedHash == hashedPassword;
} 