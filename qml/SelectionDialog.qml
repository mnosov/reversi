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

Dialog {
    id: selectionRootDialog
    property alias model: listView.model

    property int visibleItems: isInPortrait? 8: 5
    property int itemHeight: 60*UI.PLATFORM_SCALE_FACTOR

    property int selectedIndex: -1

    function doShow(stX, stY) {
        if (selectedIndex >= 0) {
            listView.positionViewAtIndex(selectedIndex, ListView.Center);
        }
        show(stX, stY)
    }

    content: ListView {
        id: listView
        anchors.centerIn: parent
        height: selectionRootDialog.itemHeight * selectionRootDialog.visibleItems
        width: parent.width

        delegate: Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: selectionRootDialog.itemHeight
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Pressed outside2 - reject dialog");
                    reject();
                }
            }
            Item {
                width: Math.max(txt.paintedWidth + 20*UI.PLATFORM_SCALE_FACTOR, 100*UI.PLATFORM_SCALE_FACTOR)
                height: selectionRootDialog.itemHeight
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    anchors.fill: parent
                    color: selectedIndex == index? (marea.pressed? "#808080": "#404040"): (marea.pressed? "#808080": "#00000000")
                }

                Text {
                    id: txt
                    anchors.centerIn: parent
                    text: model.data
                    font.pixelSize: 26*UI.PLATFORM_SCALE_FACTOR
                    color: {
                        if (selectedIndex == index) {
                            return "blue"
                        } else {
                            return "white"
                        }
                    }
                }
                MouseArea {
                    id: marea
                    anchors.fill: parent
                    onClicked: {
                        selectedIndex = index;
                        accept();
                    }
                }
            }
        }
    }
}
