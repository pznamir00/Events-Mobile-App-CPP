#ifndef LOCATION_H
#define LOCATION_H
#include <QObject>
#include "data.h"




class Location : public Data
{
private:
    Q_OBJECT
    friend class Event;
    int event_id;
    std::map<std::string, float> coordinates = {
        {"latitude", 0},
        {"longitude", 0}
    };
    void set_event_id(const int _event_id);
    void save();
    float operator() (const std::string coordinate);

public:
    static QString table_name;
    static QVector<std::shared_ptr<Location>> current_state;
    Location(int id = 0, int ei = 0, float lat = 0.0, float lon = 0.0);
    Location* create(QString* attr);

public slots:
    int get_event_id() const;
    static QVariant get_current_state();
    QVector<qreal> get_coordinate();
    static void commit_new(const QString event_id, const QString x, const QString y);
};

#endif // LOCATION_H
