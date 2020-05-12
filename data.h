#ifndef DATA_H
#define DATA_H
#include <QObject>
#include <QSql>
#include <QSqlDatabase>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>
#include <string>




class Data : public QObject
{
private:
    Q_OBJECT
    static QSqlDatabase db;
    void set_id(int id);

protected:
    int id;
    static std::vector<std::vector<QString>> db_connect(const QString query_string);
    template<class T>
    void set_new_id();

public:
    static QString table_name;
    explicit Data(const int id = 0);
    virtual Data* create(QString* attr) = 0;
    int get_id() const;
    template<class T>
    static std::shared_ptr<T> find(const int id);
    template<class T>
    static QVector<std::shared_ptr<T>> get(QString condition = "");
    void _delete(const QString table);
};

#endif
