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

Item {
    property int animDuration: 300
    id: rootDialog

    property alias content: contentItem.children

    function show(posX, posY) {
        console.log("show dialog: " + posX + " " + posY);
        innerItem.startX = posX
        innerItem.startY = posY
        innerItem.scale = 1;
    }

    function hide() {
        innerItem.scale = 0;
    }

    signal accepted
    signal rejected
    signal fullyActive
    signal fullyClosed

    function accept() {
        hide();
        accepted();
    }

    function reject() {
        hide();
        rejected();
    }

    Item {
        id: innerItem
        width: parent.width
        height: parent.height
        scale: 0
        visible: scale > 0.01
        property int startX: 0
        property int startY: 0
        opacity: scale

        x: (startX - width/2) * (1-scale)
        y: (startY - height/2) * (1-scale)

        Behavior on scale {
            NumberAnimation { duration: rootDialog.animDuration }
        }
        onOpacityChanged: {
            if (opacity == 1.0) {
                rootDialog.fullyActive();
            } else if (opacity == 0.0) {
                rootDialog.fullyClosed();
            }
        }

        Rectangle {
            id: background
            anchors.fill: parent
            color: "black"
            opacity: 0.9
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Pressed outside - reject dialog");
                rootDialog.reject();
            }
        }

        Item {
            id: contentItem
            anchors.fill: parent
        }
    }
}
