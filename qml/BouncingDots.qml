pragma ComponentBehavior: Bound

import QtQuick
import xRumi.QWeather

Item {
    property int size: 15
    property int dotHeight: 50

    id: root
    anchors.centerIn: parent

    Row {
        spacing: 15
        anchors.centerIn: parent

        Repeater {
            model: 3
            delegate: Rectangle {
                required property int index

                id: delegate
                width: root.size
                height: root.size
                radius: root.size / 2
                antialiasing: true
                color: AppState.color?.text1 || "red"

                SequentialAnimation on y {
                    loops: Animation.Infinite
                    running: true

                    NumberAnimation {
                        to: -root.dotHeight
                        duration: 400 + 50 * delegate.index
                        easing.type: Easing.OutQuad
                    }
                    NumberAnimation {
                        to: 0
                        duration: 300
                        easing.type: Easing.InQuad
                    }
                }
            }
        }
    }
}
