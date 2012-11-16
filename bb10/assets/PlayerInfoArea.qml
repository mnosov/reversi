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
import bb.cascades 1.0
import Reversi 1.0

Container {
    id: playerCountInfo
    property int color: Defs.White
    preferredHeight: 130
    layout: DockLayout{}
    Label {
        id: playerTitle
        verticalAlignment: VerticalAlignment.Top
        //topPadding: 20
        horizontalAlignment: HorizontalAlignment.Center
        text: rootWindow.getShortStringForSkill(playerCountInfo.color == Defs.White? gameEngine.isWhiteHuman: gameEngine.isBlackHuman,
                                                playerCountInfo.color == Defs.White? gameEngine.whiteSkill: gameEngine.blackSkill)
        textStyle {
            color: playerCountInfo.pressed? Color.Gray: Color.White
            base: SystemDefaults.TextStyles.BodyText
            textAlign: TextAlign.Left
        }
        //font.pixelSize: 19*UI.PLATFORM_SCALE_FACTOR
        //color: marea.pressed? "grey": "white"
    }
    ContainerBorder {
        visible: gameEngine.curPlayer == playerCountInfo.color
        leftPadding: 30
        rightPadding: 30
        borderSize: 2
    }
    /*Container {
        anchors.bottom: countInfo.bottom
        anchors.top: playerTitle.top
        anchors.left: playerTitle.width > countInfo.width? playerTitle.left: countInfo.left
        anchors.right: playerTitle.width > countInfo.width? playerTitle.right: countInfo.right
        anchors.margins: -5*UI.PLATFORM_SCALE_FACTOR
        color: "#00000000"
        border.color: "black"
        visible: gameEngine.curPlayer == playerCountInfo.color
    }*/ //TODO: draw rectangle for current player

    Container {
        id: countInfo
        //width: playerInfo.width + imgContent.width + 5
        //height: imgContent.height
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Bottom
        preferredHeight: 50+14
        bottomPadding: 14
        layout: DockLayout {}
        Container {
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            leftPadding: 10
            layout: DockLayout{}
            ImageView {
                id: imgContent
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Left
                imageSource: playerCountInfo.color == Defs.White? "asset:///images/bw12.png": "asset:///images/bw1.png"
                //source: playerCountInfo.color == Defs.White? "qrc:/resources/bw12.png": "qrc:/resources/bw1.png"
            }
        }
        Container {
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            leftPadding: 10+56+15
            layout: DockLayout{}
            Label {
                id: playerInfo
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Left
                text: {
                    return playerCountInfo.color == Defs.White? gameEngine.whiteCount: gameEngine.blackCount;
                }
                textStyle {
                    color: playerCountInfo.pressed? Color.Gray: Color.White
                    base: SystemDefaults.TextStyles.BodyText
                    textAlign: TextAlign.Left
                }
                //font.pixelSize: 20*UI.PLATFORM_SCALE_FACTOR
                //color: marea.pressed? "grey": "white"
            }
        }
    }

    property bool pressed: false
    property int lastPressedWindowX: 0
    property int lastPressedWindowY: 0
    onTouch: {
        if (event.touchType == TouchType.Down) {
            pressed = true;
            lastPressedWindowX = event.windowX
            lastPressedWindowY = event.windowY
        } else if (event.touchType != TouchType.Move) {
            pressed = false;
        }
    }

/*
    MouseArea {
        id: marea
        anchors.fill: parent
        onClicked: {
            console.log("Change player type");
            var obj = mapToItem(selectSkill, mouseX, mouseY);
            rootWindow.showSelectionDialog(playerCountInfo.color, obj.x, obj.y);
        }
    }
    */
    gestureHandlers: [
        TapHandler {
            onTapped: {
                console.log("Change player type");
                //var obj = mapToItem(selectSkill, mouseX, mouseY);
                rootWindow.showSelectionDialog(playerCountInfo.color, playerCountInfo.lastPressedWindowX, playerCountInfo.lastPressedWindowY);
            }
        }
    ]
}
