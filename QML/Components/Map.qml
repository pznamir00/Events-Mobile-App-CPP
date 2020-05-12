import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls 2.0
import QtLocation 5.12
import QtPositioning 5.12



Map
{
    id: map
    anchors.fill: parent
    center: QtPositioning.coordinate(53.4, 14.55)
    zoomLevel: 12

    plugin: Plugin {
        id: osmMapPlugin
        name: "osm"
        PluginParameter {
            name: "osm.mapping.custom.host"
            value: "http://localhost/osm/"
        }
        PluginParameter{
            name: "osm.mapping.providersrepository.disabled"
            value: true
        }
    }
}
