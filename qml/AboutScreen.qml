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

Dialog {
    id: rootDialog
    rejectOnOutsideClick: false
    content: Item {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "qrc:/resources/background.png"
            opacity: 0.5
        }
        Item {
            id: dialogTitle
            anchors.top: parent.top
            anchors.topMargin: 12
            width: parent.width
            height: titleImage.height + separator.height
            Image {
                id: titleImage
                anchors.left: parent.left
                anchors.leftMargin: 12
                source: "qrc:/resources/reversi.png"
            }
            Column {
                id: nameAndVersion
                anchors.verticalCenter: titleImage.verticalCenter
                anchors.left: titleImage.right
                anchors.leftMargin: 12
                spacing: 3
                Text {
                    id: name
                    color: "white"
                    font.pixelSize: 30
                    text: qsTr("Reversi")
                }
                Text {
                    id: version
                    color: "white"
                    font.pixelSize: 22
                    font.bold: true
                    text: qsTr("Version %1").arg("1.0")
                }
            }
            Button {
                width: 100
                text: qsTr("Back")
                anchors.verticalCenter: titleImage.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 12
                onClicked: {
                    rootDialog.reject();
                }
            }

            Rectangle {
                id: separator
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.bottom: parent.bottom
                color: "black"
                height: 1
            }
        }


        Flickable {
            anchors.top: dialogTitle.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            clip: true
            contentHeight: aboutContent.height + 12
            Column {
                id: aboutContent
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 5
                AboutSectionText {
                    title: qsTr("Game description and rules")
                    text: qsTr("A Reversi (or sometimes called Othello) game is a simple game between two players on 8x8 board. If a player's piece is captured by an opposing player, that piece is turned over to reveal the color of that player. A winner is declared when one player has more pieces of his own color on the board and there are no more possible moves.")
                }
                AboutSection {
                    title: qsTr("Authors")
                    content: Column {
                        width: parent.width
                        spacing: 5
                        SectionTextContent {
                            text: qsTr("This open source game is based on open source game KReversi for KDE <a href=\"http://games.kde.org/kreversi\">http://games.kde.org/kreversi</a><br>Source code and license details of this application is available on GitHub <a href=\"https://github.com/mnosov/reversi\">https://github.com/mnosov/reversi</a>")
                        }
                        SectionTextContent {
                            text: qsTr("Michael Nosov is an author of this application for Symbian^3 mobile devices. For bug reporting use this email &lt;Michael.Nosov@gmail.com&gt;")
                        }
                        SectionTextContent {
                            text: qsTr("For information about authors of original KReversi application for KDE4 please refer to application's source code on <a href=\"https://github.com/mnosov/reversi\">GitHub</a> or <a href=\"http://games.kde.org/kreversi\">The KDE Games Center</a>")
                        }
                    }
                }
            }
        }
    }
}
