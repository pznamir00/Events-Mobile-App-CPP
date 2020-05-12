#include "category.h"



QString Category::table_name = "categories";
QVector<std::shared_ptr<Category>> Category::current_state;



Category::Category(int id, QString t) : Data(id)
{
    this->set_title(t);
}



//wirtualna funkcja create
Category* Category::create(QString* attr)
{
    Category* category = new Category(attr[0].toInt(), attr[1]);
    return category;
}



//ustawienie tytułu kategorii
void Category::set_title(QString title)
{
    this->title = title;
}



//zwraca tytuł kategorii
QString Category::get_title()
{
    return this->title;
}



//zwraca tytuł kategorii kategorii o podanym id
QString Category::get_title(const int id)
{
    QString resp = "";
    try {
        const std::shared_ptr<Category> category = Category::find<Category>(id);
        resp = category->get_title();
    } catch (int e) {
        qDebug()<<e;
    }

    return resp;
}



//zapisanie
void Category::save()
{
    const QString query = QString("INSERT INTO " + table_name + " (title) VALUES ('" + this->get_title() + "')");

    db_connect(query);
}



//utworzenie nowej kategorii w aplikacji (dodaje ją do current_state)
void Category::commit_new(const QString title)
{
    std::shared_ptr<Category> newCategory = std::make_shared<Category>(0, title);
    newCategory->save();
    newCategory->set_new_id<Category>();
    current_state.push_back(newCategory);
}



//zwraca tablice zawierającą wszystkie nazwy kategorii z tablicy current_state
QVector<QString> Category::get_all_titles()
{
    QVector<QString> response;

    auto add_title = [](QVector<QString>& resp, std::shared_ptr<Category> cat){ resp.push_back(cat->get_title()); };

    for(auto i : current_state)
        add_title(response, i);

    return response;
}



//sprawdza czy dane z formularza są prawidłowe
bool Category::validate(const QString title)
{
    auto exist = [](const QString tit){
        for(auto i : Category::current_state)
            if(i->get_title() == tit)   return true;
        return false;
    };

    if(title == "")
        return false;

    if(exist(title))
        return false;

    return true;
}



