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

Column {
    id: root
    property alias content: contentItem.children
    property string title: ""
    anchors.right: parent.right
    anchors.left: parent.left
    spacing: 3*UI.PLATFORM_SCALE_FACTOR
    Text {
        id: sectionTitle
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 12*UI.PLATFORM_SCALE_FACTOR
        anchors.rightMargin: 12*UI.PLATFORM_SCALE_FACTOR
        font.pixelSize: 23*UI.PLATFORM_SCALE_FACTOR
        font.bold: true
        font.underline: true
        wrapMode: Text.WordWrap
        visible: text != ""
        text: root.title != ""? (root.title + ":"): ""
        color: "white"
    }
    Item {
        id: contentItem
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 12*UI.PLATFORM_SCALE_FACTOR
        anchors.rightMargin: 12*UI.PLATFORM_SCALE_FACTOR
        height: childrenRect.height
    }
}
