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

RDialog {
    id: rootDialog
    rejectOnOutsideClick: false
    content: Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        layout: DockLayout {}
        ImageView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            imageSource: "asset:///images/background.png"
            opacity: 0.5
        }
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            layout: StackLayout {
            }
	        Container {
	            id: dialogTitle
	            //verticalAlignment: VerticalAlignment.Top
	            //topPadding: 0
	            horizontalAlignment: HorizontalAlignment.Fill
	            leftPadding: 24
	            rightPadding: 24
	            preferredHeight: 192
	            layout: DockLayout {}
	            ImageView {
	                horizontalAlignment: HorizontalAlignment.Left
	                verticalAlignment: VerticalAlignment.Top
	                imageSource: "asset:///images/reversi.png"
	            }
	            Container {
	                id: nameAndVersion
	                horizontalAlignment: HorizontalAlignment.Left
	                verticalAlignment: VerticalAlignment.Fill
	                leftPadding: 192
	                layout: DockLayout {}
	                Label {
	                    id: name
	                    text: qsTr("Reversi")
	                    horizontalAlignment: HorizontalAlignment.Left
	                    textStyle {
	                        color: Color.White
	                        base: SystemDefaults.TextStyles.TitleText
	                        textAlign: TextAlign.Left
	                        fontSize: FontSize.PointValue
	                        fontSizeValue: 60/4
	                    }
	                }
	                Label {
	                    id: version
	                    text: qsTr("Version %1").arg("1.1")
	                    horizontalAlignment: HorizontalAlignment.Left
	                    verticalAlignment: VerticalAlignment.Bottom
	                    textStyle {
	                        color: Color.White
	                        base: SystemDefaults.TextStyles.BodyText
	                        textAlign: TextAlign.Left
	                        fontWeight: FontWeight.Bold
	                        fontSize: FontSize.PointValue
	                        fontSizeValue: 44/4
	                    }
	                }
	            }
	            Container {
	                horizontalAlignment: HorizontalAlignment.Fill
	                verticalAlignment: VerticalAlignment.Fill
	                layout: DockLayout {}
	                RButton {
	                    preferredWidth: 200
	                    text: qsTr("Back")
	                    verticalAlignment: VerticalAlignment.Center
	                    horizontalAlignment: HorizontalAlignment.Right
	                    onClicked: {
	                        rootDialog.reject();
	                    }
	                }
	            }
	        }
	        Container {
	            id: separator
	            horizontalAlignment: HorizontalAlignment.Center
                preferredWidth: c3.screenWidth-12-12
	            //verticalAlignment: VerticalAlignment.Top
	            //topPadding: 192
	            rotationZ: 0.01
	            preferredHeight: 2
	            layout: DockLayout {
	                    }
	            touchPropagationMode: TouchPropagationMode.None
	            attachedObjects: [
	                Constants {
	                    id: c3
	                }
	            ]
	            Container {
	                horizontalAlignment: HorizontalAlignment.Fill
	                verticalAlignment: VerticalAlignment.Fill
	                background: Color.Black
	            }
	        }
	        ListView {
                rootIndexPath: [0]
                dataModel: XmlDataModel { source: "models/about.xml" }
                scrollIndicatorMode: ScrollIndicatorMode.None
		        listItemComponents: [
		            ListItemComponent {
			            type: "title"
			            Container {
			                id: listCont
                            preferredWidth: constants.screenWidth
			                layout: DockLayout {}
			                leftPadding: 24
			                rightPadding: 24
			                property string dt: ListItemData.data
			                attachedObjects: [
			                    Constants {
			                        id: constants
			                    }
			                ]
			                Label {
			                    horizontalAlignment: HorizontalAlignment.Fill
	                            textStyle {
	                                color: Color.White
	                                base: SystemDefaults.TextStyles.TitleText
	                                textAlign: TextAlign.Left
	                                fontSize: FontSize.PointValue
	                                fontSizeValue: 40/4
	                                fontWeight: FontWeight.Bold
	                            }
	                            multiline: true
	                            text: {
	                                //TODO: localize this
	                                if (listCont.dt == "rules") {
	                                    return "Game description and rules:"
	                                } else if (listCont.dt == "authors") {
	                                    return "Authors:"                                
	                                }
	                                return "";
	                            }
	                        }
	                    }
	                },
		            ListItemComponent {
			            type: "body"
			            Container {
			                id: listContBody
                            preferredWidth: constants2.screenWidth
			                layout: DockLayout {}
			                leftPadding: 24
			                rightPadding: 24
			                property string dt: ListItemData.data
                            attachedObjects: [
                                Constants {
                                    id: constants2
                                }
                            ]
                            Label {
			                    horizontalAlignment: HorizontalAlignment.Fill
	                            textStyle {
	                                color: Color.White
	                                base: SystemDefaults.TextStyles.BodyText
	                                textAlign: TextAlign.Left
	                                fontSize: FontSize.PointValue
	                                fontSizeValue: 32/4
	                            }
	                            multiline: true
	                            text: {
	                                //TODO: localize this
	                                if (listContBody.dt == "desc and rules") {
	                                    return "A Reversi (or sometimes called Othello) game is a simple game between two players on 8x8 board. If a player's piece is captured by an opposing player, that piece is turned over to reveal the color of that player. A winner is declared when one player has more pieces of his own color on the board and there are no more possible moves."
	                                } else if (listContBody.dt == "license") {
	                                    return "This open source game is based on open source game KReversi for KDE (http://games.kde.org/kreversi). Source code and license details of this application is available on GitHub (https://github.com/mnosov/reversi)"                                
	                                } else if (listContBody.dt == "nosov") {
	                                    return "Michael Nosov is an author of this application for BlackBerry 10, Symbian^3 and MeeGo mobile devices. For bug reporting use this email <Michael.Nosov@gmail.com>"
	                                } else if (listContBody.dt == "kde") {
	                                    return "For information about authors of original KReversi application for KDE4 please refer to application's source code on GitHub (https://github.com/mnosov/reversi) or The KDE Games Center (http://games.kde.org/kreversi)"
	                                }
	                                return "";
	                            }
	                        }
	                    }
	                }
	            ]
			}
	    }

/*
        Flickable {
            anchors.top: dialogTitle.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            clip: true
            contentHeight: aboutContent.height + 12*UI.PLATFORM_SCALE_FACTOR
            Column {
                id: aboutContent
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 5*UI.PLATFORM_SCALE_FACTOR
                AboutSectionText {
                    title: qsTr("Game description and rules")
                    text: qsTr("A Reversi (or sometimes called Othello) game is a simple game between two players on 8x8 board. If a player's piece is captured by an opposing player, that piece is turned over to reveal the color of that player. A winner is declared when one player has more pieces of his own color on the board and there are no more possible moves.")
                }
                AboutSection {
                    title: qsTr("Authors")
                    content: Column {
                        width: parent.width
                        spacing: 5*UI.PLATFORM_SCALE_FACTOR
                        SectionTextContent {
                            text: qsTr("This open source game is based on open source game KReversi for KDE <a href=\"http://games.kde.org/kreversi\">http://games.kde.org/kreversi</a><br>Source code and license details of this application is available on GitHub <a href=\"https://github.com/mnosov/reversi\">https://github.com/mnosov/reversi</a>")
                        }
                        SectionTextContent {
                            text: qsTr("Michael Nosov is an author of this application for BB10 mobile devices. For bug reporting use this email &lt;Michael.Nosov@gmail.com&gt;")
                        }
                        SectionTextContent {
                            text: qsTr("For information about authors of original KReversi application for KDE4 please refer to application's source code on <a href=\"https://github.com/mnosov/reversi\">GitHub</a> or <a href=\"http://games.kde.org/kreversi\">The KDE Games Center</a>")
                        }
                    }
                }
            }
        }*/
    }
}
