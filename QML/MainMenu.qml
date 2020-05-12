import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls 2.0
import QtLocation 5.12
import QtPositioning 5.12
import "./Components" as Components



Page {
    width: 500
    height: 800
    id: page

    function mapUpdate()
    {
        //aktuaizacja mapy
        map.clearMapItems();
        loadAllLocations();

        //aktualizacja kategorii
        var categories = CatClass.get_all_titles();
        var list = [];
        categories.forEach(cat => list.push(cat));
        categoryBox.model = list;
    }

    function getDetails(id)
    {
        let id_str = '' + id;
        var data = EventClass.get_details(parseInt(id_str));
        var event = {
            id: data[0],
            title: data[1],
            description: data[2],
            add_time: data[3],
            event_time: data[4],
            category_id: data[5],
            author_id: data[6]
        }

        displayDetails(event);
    }

    function displayDetails(event)
    {
        eventDialog._title_ = event.title;
        eventDialog.description = event.description;
        eventDialog.addTime = event.add_time;
        eventDialog.eventTime = event.event_time;
        eventDialog.category = CatClass.get_title(event.category_id);
        eventDialog.author = "Autor: " + UserClass.get_username_by_id(event.author_id);
        eventDialog._id = event.id;
        eventDialog.deleteButton = EventClass.if_event_of_logged_user(parseInt(event.id));
        eventDialog.visible = true;
    }

    function deleteEvent(id)
    {
        EventClass.remove(id);
        eventDialog.visible = false;
        swipeView.update();
    }

    function filterEvents(categoryIndex){
        var selectedId = categoryIndex + 1;

        if(selectedId === 1){
            EventClass.filter_by_category();    //wszystkie wydarzenia
        }
        else{
            EventClass.filter_by_category(selectedId);  //przefiltrowane wydarzenia
        }
        swipeView.update();
    }

    function addMarker(location)
    {
        var Component = Qt.createComponent("qrc://views/QML/Components/Marker.qml");

        let event_id = location.get_event_id();
        let coords = location.get_coordinate();

        var item = Component.createObject(page, {
            "itemId": event_id,
            coordinate: QtPositioning.coordinate(coords[0], coords[1]),
        });

        item.clicked.connect(getDetails);
        map.addMapItem(item);
    }

    function loadAllLocations()
    {
        var locations = LocationClass.get_current_state();
        locations.forEach(location => addMarker(location));
    }


    Components.Map {
        id: map
        anchors.margins: 3
        anchors.topMargin: 20
        property var event

        Rectangle{
            width: 500
            height: 42
            z: 3
            Components.CategoriesComboBox{
                id: categoryBox
                x: 1
                y: -1
                onCurrentIndexChanged: {
                    filterEvents(currentIndex);
                }
            }
            Slider {
                id: slider
                value: 5
                from: 0
                to: 10
                stepSize: 1
                x: 150
                width: 336
                height: 40
                property var last: 5

                onMoved: {
                    if(value != last)
                    {
                        if(value > last)
                            map.zoomLevel += 1;
                        else
                            map.zoomLevel -= 1;

                        last = value;
                    }
                }
            }
        }

        Dialog{
            id: eventOfUserError
            title: "Nie możesz usunąć tego wydarzenia"
            standardButtons: Dialog.Ok|Dialog.Cancel
        }

        Rectangle{
            id: zoomController
            z: 1
            y: 540
            x: 10
        }
    }

    Components.EventDialog{
        id: eventDialog
    }

    Component.onCompleted: {
        page.loadAllLocations();
        categoryBox.load();
        swipeView.update.connect(mapUpdate);
    }
}
