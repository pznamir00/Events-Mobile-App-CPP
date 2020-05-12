import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls 2.0




ComboBox{
    height: 42
    currentIndex: 1;
    model: []

    function load(){
        var categories = CatClass.get_all_titles();
        var list = [];
        for(let i=0; i<categories.length; i++){
            list.push(categories[i]);
        }

        categoryBox.model = list;
    }
}

