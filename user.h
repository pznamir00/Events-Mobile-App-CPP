#ifndef USER_H
#define USER_H
#include <regex>
#include "data.h"
#include "event.h"




class User : public Data
{
private:
    class Account
    {
    private:
        QString username;
        QString password;
    public:
        Account(const QString usrn, const QString pass);
        QString get_username();
        QString get_password();
    };

    Q_OBJECT;
    QString first_name;
    QString last_name;
    QString email;
    std::unique_ptr<Account> account;
    void save();

public:
    static QString table_name;
    static std::unique_ptr<User> logged;
    User(int id = 0, QString fN = "", QString lN = "", QString em = "",
         QString usn = "", QString pass = "");
    User(const std::shared_ptr<User> user);
    User* create(QString* attr);

public slots:
    static bool login(const QString usern, const QString passw);
    static void _register(const QString fN, const QString lN, const QString em, const QString usn, const QString pass);
    void logout();
    QString get_logged_full_name() const;
    static bool check_authenticate();
    bool validate(const QString fN, const QString lN, const QString em, const QString usn, const QString pass, const QString pass2);
    QString get_username_by_id(const int id);
    static QVariant get_events_of_logged();
};

#endif // USER_H
