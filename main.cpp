#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "event.h"
#include "location.h"
#include "category.h"
#include "user.h"
#include "app.h"
using namespace app;


#include <algorithm>
#include <cmath>




int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/QML/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);



    prepare_array_pointers();

    //zmienne używane w QML
    Category category_instance;
    Event event_instance;
    Location location_instance;
    User user_instance;
    set_qml_properties(engine, event_instance, location_instance, category_instance, user_instance);
    engine.load(url);

    //start aplikacji
    return app.exec();;
}
