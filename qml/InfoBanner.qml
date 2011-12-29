import QtQuick 1.0

Rectangle {
    id: banner
    height: text.height + 24
    radius: 7
    color: "#E0000000"
    opacity: 0.0
    function show(txt) {
        text.text = txt;
        opacity = 1.0
        if (showTimer.running) {
            showTimer.restart();
        } else {
            showTimer.start();
        }
    }
    function hide() {
        opacity = 0.0
        showTimer.stop();
    }

    Behavior on opacity {
        NumberAnimation {duration: 300}
    }

    Text {
        id: text
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        width: parent.width - 24
        color: "white"
        font.pixelSize: 19
        wrapMode: Text.WordWrap

    }

    Timer {
        id: showTimer
        interval: 5000
        repeat: false
        onTriggered: {
            banner.hide();
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            banner.hide();
        }
    }
}
