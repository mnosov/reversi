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

Rectangle {
    id: root
    width: checkbox.width + textBlock.width + 5*3
    height: 40
    signal clicked
    property bool enabled: true
    property alias text: textBlock.text
    radius: 3
    border.color: "black"
    gradient: Gradient {
        GradientStop {position: 0.0; color: marea.pressed? "#ccb872": "#ecdeac"}
        GradientStop {position: 1.0; color: marea.pressed? "#ecdeac": "#ccb872"}
    }

    Rectangle {
        anchors.fill: parent
        radius: 3
        border.color: "black"
        color: "gray"
        opacity: 0.5
        visible: root.enabled
    }

    Image {
        id: checkbox
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: marea.pressed? -1: 0
        anchors.left: parent.left
        anchors.leftMargin: 5
        source: "qrc:/resources/check.png"
    }
    Text {
        id: textBlock
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: checkbox.right
        anchors.leftMargin: 5
        anchors.verticalCenterOffset: marea.pressed? -1: 0
        font.pixelSize: 18
        color: marea.pressed? "#404040": "black"
    }

    MouseArea {
        id: marea
        anchors.fill: parent
        onClicked: {
            root.clicked();
        }
    }
}
