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
import Reversi 1.0

Item {
    id: playerCountInfo
    property int color: Defs.White
    height: 68
    Text {
        id: playerTitle
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: rootWindow.getShortStringForSkill(playerCountInfo.color == Defs.White? gameEngine.isWhiteHuman: gameEngine.isBlackHuman,
                                                playerCountInfo.color == Defs.White? gameEngine.whiteSkill: gameEngine.blackSkill)
        font.pixelSize: 19
        color: marea.pressed? "grey": "white"
    }
    Rectangle {
        anchors.bottom: countInfo.bottom
        anchors.top: playerTitle.top
        anchors.left: playerTitle.width > countInfo.width? playerTitle.left: countInfo.left
        anchors.right: playerTitle.width > countInfo.width? playerTitle.right: countInfo.right
        anchors.margins: -5
        color: "#00000000"
        border.color: "black"
        visible: gameEngine.curPlayer == playerCountInfo.color
    }

    Row {
        id: countInfo
        //width: playerInfo.width + imgContent.width + 5
        height: imgContent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 7
        spacing: 5
        Image {
            id: imgContent
            source: playerCountInfo.color == Defs.White? ":/resources/bw12.png": ":/resources/bw1.png"
        }
        Text {
            id: playerInfo
            anchors.verticalCenter: imgContent.verticalCenter
            text: {
                return playerCountInfo.color == Defs.White? gameEngine.whiteCount: gameEngine.blackCount;
            }

            font.pixelSize: 20
            color: marea.pressed? "grey": "white"
        }
    }



    MouseArea {
        id: marea
        anchors.fill: parent
        onClicked: {
            console.log("Change player type");
            var obj = mapToItem(selectSkill, mouseX, mouseY);
            rootWindow.showSelectionDialog(playerCountInfo.color, obj.x, obj.y);
        }
    }
}
