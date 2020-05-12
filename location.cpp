#include "location.h"




QString Location::table_name = "locations";
QVector<std::shared_ptr<Location>> Location::current_state;




Location::Location(int id, int ei, float lat, float lon) : Data(id)
{
    this->set_event_id(ei);
    this->coordinates["latitude"] = lat;
    this->coordinates["longitude"] = lon;
}




//operator [] zwraca współrzędną x lub y
float Location::operator() (const std::string coordinate)
{
    if(coordinate != "latitude" && coordinate != "longitude"){
        qDebug() << "Błędna współrzędna";
        return 0;
    }

    return this->coordinates[coordinate];
}



//funkcja wirtualna create
Location* Location::create(QString* attr)
{
    Location* location = new Location(attr[0].toInt(), attr[1].toInt(), attr[2].toFloat(), attr[3].toFloat());
    return location;
}




//ustawia event_id
void Location::set_event_id(const int _event_id)
{
    this->event_id = _event_id;
}



//zwraca event_id
int Location::get_event_id() const
{
    return this->event_id;
}



//utworzenie nowej lokalizacji
void Location::commit_new(const QString event_id, const QString x, const QString y)
{
    std::shared_ptr<Location> newLocation = std::make_shared<Location>(0, event_id.toInt(), x.toFloat(), y.toFloat());
    newLocation->save();
    newLocation->set_new_id<Location>();
    current_state.push_back(newLocation);
}




//zapisanie lokalizacji
void Location::save()
{
    const QString query = QString("INSERT INTO " + table_name + " (event_id, latitude, longitude) VALUES ('%1', '%2', '%3')")
            .arg(this->get_event_id())
            .arg((*this)("latitude"))
            .arg((*this)("longitude"));
    db_connect(query);
}



//pobiera współrzędne obiektu
QVector<qreal> Location::get_coordinate()
{
    const QVector<qreal> resp = {
        (*this)("latitude"),
        (*this)("longitude")
    };

    return resp;
}



//zwraca tablice current_state
QVariant Location::get_current_state()
{
    QVector<Location*> locations_raw;
    foreach(auto i, current_state){
        locations_raw.push_back(i.get());
    }
    return QVariant::fromValue(locations_raw);
}
