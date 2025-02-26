#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "settingsmanager.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    // 创建设置管理器实例
    SettingsManager settingsManager;

    QQmlApplicationEngine engine;

    // 将设置管理器暴露给QML
    engine.rootContext()->setContextProperty("settingsManager", &settingsManager);

    const QUrl url(QStringLiteral("qrc:/src/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
