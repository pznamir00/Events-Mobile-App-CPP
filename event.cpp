#include "event.h"
#include <QDateTime>




QString Event::table_name = "events";
QVector<std::shared_ptr<Event>> Event::current_state;




Event::Event(int id, QString t, QString d, QString at, QString et, int c, int a)
    : Data(id)
{
    this->title = t;
    this->description = d;
    this->add_date = at;
    this->event_date = et;
    this->author_id = a;

    this->set_category(c);
    this->set_location();
}



//konstruktor delegujący
Event::Event() : Event(0, "", "", "", "", 0, 0) {}



//destruktor
Event::~Event()
{
    if(this->location != nullptr){
        int i = 0;
        for(auto location : Location::current_state){
            if(location == this->location)
                Location::current_state.erase(Location::current_state.begin() + i);
            i++;
        }
    }
}



//przeciążony operator
Event::operator QString()
{
    return QString("%1").arg(this->get_id());
}



//zabezpieczenie aplikacji przed przypisaniem złego atrybutu
std::shared_ptr<Location> Event::operator= (const std::shared_ptr<Location> loc)
{
    std::shared_ptr<Location> final_location = nullptr;
    if(loc->get_event_id() == this->get_id()){
        final_location = loc;
    }

    return final_location;
}



//ustawia lokalizację na podstawia Location::current_state
void Event::set_location()
{   
    for(auto i : Location::current_state)
    {
        if(i->get_event_id() == this->get_id()){
            this->location = i;
            break;
        }
    }
}



//ustawia wskaźnik na kategorię o podanym id
void Event::set_category(const int category_id)
{
    const std::shared_ptr<Category> cat = Category::find<Category>(category_id);
    this->category = cat;
}



//funkcja wirtualna create
Event* Event::create(QString* attr)
{
    Event* event = new Event(attr[0].toInt(), attr[1], attr[2], attr[3], attr[4], attr[5].toInt(), attr[6].toInt());
    return event;
}



//usunięcie wydarzenia
void Event::remove(const int id)
{
    const std::shared_ptr<Event> ev = Event::find<Event>(id);
    ev->_delete(Event::table_name);
    ev->location->_delete(Location::table_name);

    int i = 0;
    for(auto e : current_state){
        if(e == ev)
            current_state.erase(current_state.begin() + i);
        i++;
    }

    qDebug() << "Zniszczono wydarzenie o id: " << *ev;
}



//zapisanie
void Event::save()
{
    const QString query = QString("INSERT INTO " + table_name + " (title, description, add_time, event_time, category_id, author_id) VALUES ("
             "'" + this->title + "', "
             "'" + this->description + "', "
             "'" + this->add_date + "', "
             "'" + this->event_date + "', "
             "%1, "
             "%2"
             ")").arg(this->category->get_id()).arg(this->author_id);
    db_connect(query);
}



//pobiera atrybuty obiektu jako tablicę do formularza w QML
QVariant Event::get_details(const int id)
{
    const std::shared_ptr<Event> event = Event::find<Event>(id);
    QVector<QString> response = {
        QString("%1").arg(event->get_id()),
        QString(event->title),
        QString(event->description),
        QString(event->add_date),
        QString(event->event_date),
        QString("%1").arg(event->category->get_id()),
        QString("%1").arg(event->author_id)
    };

    return QVariant::fromValue(response);
}



//zwraca tytuł po id obiektu
QString Event::get_title_by_id(const int id)
{
    const std::shared_ptr<Event> e = Event::find<Event>(id);
    return e.get()->title;
}



//zwraca tytuł kategorii
QString Event::get_category_title()
{
    return this->category->get_title();
}



//filtruje obiekty na mapie (wczytuje wszystkie) <- funkcja przeładowana
void Event::filter_by_category()
{
    Location::current_state.clear();
    current_state.clear();

    Location::current_state = Location::get<Location>();
    current_state = Event::get<Event>();
}



//filtruje obiekty na mapie (wczytuje o konkretnej kategorii) <- funkcja przeładowana
void Event::filter_by_category(const int cat_id)
{
    Location::current_state.clear();
    current_state.clear();

    current_state = Event::get<Event>( QString("category_id=%1").arg(cat_id) );
    for(auto i : current_state) {
        Location::current_state.push_back( Location::get<Location>( QString("event_id=%1").arg(i->get_id()) )[0] );
        i->set_location();
    }
}



//tworzy nowy obiekt event w Qmlu
void Event::commit_new(const QString t, const QString d, const QString ed, const QString c, const QString x, const QString y)
{
    std::shared_ptr<Event> new_event = std::make_shared<Event>(0, t, d, "", ed, c.toInt(), User::logged->get_id());
    new_event->add_date = QDateTime::currentDateTime().toString();
    new_event->save();
    new_event->set_new_id<Event>();
    current_state.push_back(new_event);

    //zapisanie lokalizacji
    Location::commit_new(QString("%1").arg(new_event->get_id()), x, y);

    new_event->set_location();
    qDebug() << "Utworzono wydarzenie o id: " << *new_event;
}



//sprawdza poprawność danych z formularza
bool Event::validate(const QString tit, const QString desc, const QString dat)
{
    auto check_date = [](const QString date){ return QDateTime::fromString(date, "dd.MM.yyyy hh:mm").isValid(); };

    if(tit=="" || desc=="")
        return false;

    if(!check_date(dat))
        return false;

    return true;
}



//sprawdza czy wydarzenie należy do zalogowanego użytkownika
bool Event::if_event_of_logged_user(const int id)
{
    auto check = [](const int e, const int u) -> bool { return e == u; };

    if(User::check_authenticate()){
        std::shared_ptr<Event> e = Event::find<Event>(id);
        if( check(e->author_id, User::logged->get_id()) )
            return true;
    }

    return false;
}





