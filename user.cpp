#include "user.h"

QString User::table_name = "users";
std::unique_ptr<User> User::logged = nullptr;





User::User(int id, QString fN, QString lN, QString em, QString usn, QString pass) : Data(id)
{
    this->first_name = fN;
    this->last_name = lN;
    this->email = em;

    this->account = std::make_unique<Account>(usn, pass);
}



//konstruktor kopiujący
User::User(const std::shared_ptr<User> user)
    : User(user->get_id(), user->first_name, user->last_name, user->email, user->account->get_username(), user->account->get_password())
{}



//funkcja wirtualna create
User* User::create(QString* attr)
{
    User* user = new User(attr[0].toInt(), attr[1], attr[2], attr[3], attr[4], attr[5]);
    return user;
}



//zwraca pełne imię i nazwisko zalogowanego użytkownika
QString User::get_logged_full_name() const
{

    return User::logged->first_name + " " + User::logged->last_name;
}




//logowanie
bool User::login(const QString usern, const QString passw)
{
    const QVector<std::shared_ptr<User>> users = User::get<User>();

    foreach(auto user, users)
    {
        if(user->account->get_username() == usern && user->account->get_password() == passw)
        {
            User::logged = std::make_unique<User>(user);
            return true;
        }
    }

    return false;
}



//rejestracja
void User::_register(const QString fN, const QString lN, const QString em, const QString usn, const QString pass)
{
    std::unique_ptr<User> newUser = std::make_unique<User>(0, fN, lN, em, usn, pass);
    newUser->save();
}



//wylogowanie
void User::logout()
{
    User::logged = nullptr;
}



//zapisanie
void User::save()
{
    const QString query = "INSERT INTO " + table_name + " "
                "(first_name, last_name, email, username, password) VALUES ("
                "'" + this->first_name + "', "
                "'" + this->last_name + "', "
                "'" + this->email + "', "
                "'" + this->account->get_username() + "', "
                "'" + this->account->get_password() + ""
                "')";

    db_connect(query);
}



//sprawdza czy jest zalogowany użytkownik
bool User::check_authenticate()
{
    return User::logged == nullptr ? false : true;
}



//walidacja danych z formularza
bool User::validate(const QString fN, const QString lN, const QString em, const QString usn, const QString pass, const QString pass2)
{
    auto email_is_valid = [](const QString email) {
        const std::regex email_pattern("(\\w+)(\\.|_)?(\\w*)@(\\w+)(\\.(\\w+))+");
        const std::string email_std = email.toStdString();
        return std::regex_match(email_std, email_pattern);
    };

    auto exist = [](const QString usr, const QString em, QVector<std::shared_ptr<User>> users){
        for(auto i : users)
            if(i->account->get_username() == usr || i->email == em) return true;
        return false;
    };


    if(fN == "" || lN == "" || usn == "")
        return false;

    if(pass != pass2)
        return false;

    if(!email_is_valid(em))
        return false;

    QVector<std::shared_ptr<User>> users = User::get<User>();
    if(exist(usn, em, users))
        return false;

    return true;
}



//pobiera nazwę użytkownika po id
QString User::get_username_by_id(const int id)
{
    QString username;
    std::shared_ptr<User> this_user = User::get<User>(QString("id=%1").arg(id))[0];
    username = this_user->account->get_username();
    return username;
}



//pobiera dane o wydarzeniach zalogowanego użytkownika
QVariant User::get_events_of_logged()
{
    QVector<QVector<QString>> response;
    const int logged_id = User::logged->get_id();
    QVector<std::shared_ptr<Event>>* events = &Event::current_state;
    foreach(auto event, *events)
    {
        if(event->author_id == logged_id)
        {
            response.push_back({
                QString("%1").arg(event->get_id()),
                event->title,
                event->add_date,
                event->event_date
            });
        }
    }

    return QVariant::fromValue(response);
}



//Account --------------------------------------------------------
User::Account::Account(const QString usrn, const QString pass)
{
    this->username = usrn;
    this->password = pass;
}



//zwraca nazwę użytkownika
QString User::Account::get_username()
{
    return this->username;
}



//zwraca hasło użytkownika
QString User::Account::get_password()
{
    return this->password;
}
