#ifndef CATEGORY_H
#define CATEGORY_H
#include <QObject>
#include <QQmlEngine>
#include "data.h"





class Category : public Data
{
private:
    Q_OBJECT
    QString title;
    void save();
    void set_title(QString title);

public:
    static QVector<std::shared_ptr<Category>> current_state;
    static QString table_name;
    Category(int id = 0, QString t = "");
    Category* create(QString* attr);

public slots:
    void commit_new(const QString title);
    QString get_title();
    QString get_title(const int id);
    static QVector<QString> get_all_titles();
    bool validate(const QString title);
};




#endif // CATEGORY_H
