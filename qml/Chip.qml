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
import Qt 4.7
import Reversi 1.0
import "UIConstants.js" as UI

Item {
    id: chipRoot

    width: rootWindow.chipWidth
    height: rootWindow.chipHeight
    signal clicked

    property int animDuration: moveAnimationDuration * (gameEngine.setupMode? 0.3: 1)
    property int curColor: Defs.NoColor
    property int imgIndex: ((curColor == Defs.White)? 12: 1)
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: "grey"
        opacity: mouseArea.pressed? 1:0
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: "grey"
        opacity: 0.5
        visible: gameEngine.setupMode
    }

    Image {
        id: imgContent
        anchors.centerIn: parent
        source: ":/resources/bw"+chipRoot.imgIndex+".png"
        opacity: (chipRoot.curColor == Defs.NoColor)? 0: 1
        //property real scaleFactor: (gameEngine.setupMode? 1.15: 1)
        //scale: opacity * scaleFactor
        Behavior on opacity {
            NumberAnimation { duration: chipRoot.animDuration }
        }
        /*Behavior on scaleFactor {
            NumberAnimation { duration: moveAnimationDuration }
        }*/
    }

    Behavior on imgIndex {
        NumberAnimation { duration: chipRoot.animDuration }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            chipRoot.clicked();
        }
    }
}
