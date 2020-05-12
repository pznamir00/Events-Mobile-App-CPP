#include "data.h"
#include <QSqlRecord>
#include <QSqlDriver>
#include "event.h"
#include "location.h"
#include "category.h"
#include "user.h"

QSqlDatabase Data::db = QSqlDatabase::addDatabase("QSQLITE");
QString Data::table_name = "";





Data::Data(const int id)
{
    this->set_id(id);
}



//ustawia id
void Data::set_id(int id)
{
    this->id = id;
}



//pobiera id
int Data::get_id() const
{
    return this->id;
}



//zwraca wyniki zapytania jako tablicę (w przypadku gdy dokonujemy zapisania danych itd. - zwraca pustą tablicę)
std::vector<std::vector<QString>> Data::db_connect(const QString query_string)
{
    std::vector<std::vector<QString>> result;
    db.setDatabaseName("C:/sqlite3/db/4events.db");

    if( db.open() )
    {
        QSqlQuery query;
        if(query.exec(query_string)) {
            const int columns = query.record().count();
            while(query.next()){
                std::vector<QString> row;
                for(int i=0; i<columns; i++)
                    row.push_back(query.value(i).toString());
                result.push_back(row);
            }
        }
        else{
            qDebug()<<query.lastError();
        }
    } else {
        qDebug() << "Błąd połączenia";
    }

    db.close();
    return result;
}



//ustawia nowe id obiektu (dzięki tej metodzie nie ma konieczności pobierania najnowszego id z bazy danych)
template<class T>
void Data::set_new_id()
{
    int id = 0;

    QVector<std::shared_ptr<T>>* array = &T::current_state;
    foreach(auto i, *array)
    {
        if(i->get_id() > id)
            id = i->get_id();
    }

    this->set_id(id + 1);
}
template void Data::set_new_id<Event>();
template void Data::set_new_id<Location>();
template void Data::set_new_id<Category>();



//znajduje obiekt o podanym id w tablicy current_state
template<class T>
std::shared_ptr<T> Data::find(const int id)
{
    std::shared_ptr<T> response = nullptr;

    //szuka obiektu o podanym id
    QVector<std::shared_ptr<T>>* array = &T::current_state;
    for(auto object : *array)
    {
        if(object->get_id() == id){
            response = object;
            break;
        }
    }

    return response;
}
template std::shared_ptr<Event> Data::find(int id);
template std::shared_ptr<Location> Data::find(int id);
template std::shared_ptr<Category> Data::find(int id);



//pobiera i konwertuje dane na obiekty z bazy danych
template<class T>
QVector<std::shared_ptr<T>> Data::get(QString condition)
{
    if(condition != "")     condition = "WHERE " + condition;

    QString query = "SELECT * FROM " + T::table_name + " " + condition;
    const std::vector<std::vector<QString>> result = db_connect(query);
    QVector<std::shared_ptr<T>> response;

    for(auto i: result)
    {
        QString* attr = &i[0];
        T sample;
        Data* data = &sample;
        std::shared_ptr<T> object((T*)data->create(attr));
        response.push_back(object);
    }

    return response;
}
template QVector<std::shared_ptr<Event>> Data::get(QString condition);
template QVector<std::shared_ptr<Location>> Data::get(QString condition);
template QVector<std::shared_ptr<Category>> Data::get(QString condition);
template QVector<std::shared_ptr<User>> Data::get(QString condition);



//usuwanie obiektu z bazy danych
void Data::_delete(const QString table)
{
    QString query = QString("DELETE FROM " + table + " WHERE id=%1").arg(this->get_id());
    db_connect(query);
}












