/*******************************************************************
 *
 * Copyright 2011-2012 Michael Nosov <Michael.Nosov@gmail.com>
 *
 * This file is part of the QML project "Reversi on QML"
 *
 * "Reversi on QML" is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * "Reversi on QML" is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with "Reversi on QML"; see the file COPYING.  If not, write to
 * the Free Software Foundation, 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 *
 ********************************************************************/
import QtQuick 1.0
import "UIConstants.js" as UI

Rectangle {
    id: banner
    height: text.height + 24*UI.PLATFORM_SCALE_FACTOR
    radius: 7*UI.PLATFORM_SCALE_FACTOR
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
        width: parent.width - 24*UI.PLATFORM_SCALE_FACTOR
        color: "white"
        font.pixelSize: 19*UI.PLATFORM_SCALE_FACTOR
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
