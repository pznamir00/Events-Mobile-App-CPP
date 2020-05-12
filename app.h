#ifndef APPLICATION_H
#define APPLICATION_H
#include <QQmlApplicationEngine>
#include "event.h"
#include "location.h"
#include "category.h"
#include "user.h"




namespace app
{
    QString get_informations();

    void set_qml_properties(QQmlApplicationEngine& engine, Event& e, Location& l, Category& c, User& u);

    void prepare_array_pointers();
}

#endif // APPLICATION_H
