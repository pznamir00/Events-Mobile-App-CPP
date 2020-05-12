#ifndef EVENT_H
#define EVENT_H
#include <vector>
#include <QObject>
#include "data.h"
#include "location.h"
#include "category.h"
#include "user.h"



class Event : public Data
{
private:
    Q_OBJECT
    void save();
    std::shared_ptr<Location> location;
    std::shared_ptr<Category> category;
    void set_location();
    void set_category(const int category_id);
    operator QString();
    std::shared_ptr<Location> operator= (const std::shared_ptr<Location> loc);

public:
    static QString table_name;
    static QVector<std::shared_ptr<Event>> current_state;
    QString title;
    QString description;
    QString add_date;
    QString event_date;
    int author_id;
    Event(int id, QString t, QString d, QString et, QString at, int c, int a);
    Event();
    ~Event();
    Event* create(QString* attr);

public slots:
    void commit_new(QString t, QString d, QString e, QString c, QString x, QString y);
    bool validate(const QString tit, const QString desc, const QString dat); //nie zmienia stanu obiektu
    QVariant get_details(const int id); //nie zmienia stanu obiektu
    QString get_title_by_id(const int id);
    QString get_category_title(); //nie zmienia stanu obiektu
    static void filter_by_category();
    static void filter_by_category(const  int cat_id);
    bool if_event_of_logged_user(const int id);
    void remove(int id);
};

#endif // EVENT_H
