#include "app.h"
#include <QFile>
#include <QQmlContext>





//wczytywanie informacji z pliku zewnętrnego
QString app::get_informations()
{
    QString response;

    QFile file("C:/Users/user/Documents/app/Files/aboutapp.txt");
    if(!file.open(QIODevice::ReadOnly)) {
        response = "Błąd " + file.errorString();
    }

    QTextStream in(&file);
    while(!in.atEnd()) {
        QString line = in.readLine();
        response += ("\n" + line);
    }

    file.close();
    return response;
}



//ustawia zmienne obiektów w QMLu
void app::set_qml_properties(QQmlApplicationEngine& engine, Event& e, Location& l, Category& c, User& u)
{
    QQmlContext* context = engine.rootContext();
    context->setContextProperty("CatClass", &c);
    context->setContextProperty("LocationClass", &l);
    context->setContextProperty("EventClass", &e);
    context->setContextProperty("UserClass", &u);
    context->setContextProperty("getInformations", get_informations());
}



//załadowanie do tablic wszystkich dynamicznych obiektów danej klasy z bazy danych
void app::prepare_array_pointers()
{
    Location::current_state = Location::get<Location>();
    Category::current_state = Category::get<Category>();
    Event::current_state = Event::get<Event>();
}
