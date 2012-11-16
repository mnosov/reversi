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
    id: selectionRootDialog

    property alias model: listView.dataModel

    property int visibleItems: 8
    property int itemHeight: 140

    property int selectedIndex: -1

    function doShow(stX, stY) {
        if (selectedIndex >= 0) {
            //listView.positionViewAtIndex(selectedIndex, ListView.Center);
        }
        show(stX, stY)
    }

    content: ListView {
        id: listView
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center
        preferredHeight: selectionRootDialog.itemHeight * selectionRootDialog.visibleItems
        preferredWidth: selectionRootDialog.containerWidth
        rootIndexPath: [0]
        property int selectedIndexProxy: selectedIndex
        function setSelectedIndex(ind) {
            selectedIndex = ind
            selectionRootDialog.accept()
        }
        function rejectProxy() {
            selectionRootDialog.reject()
        }
        listItemComponents: ListItemComponent {
            type: "sk"
            Container {
                id: listCont
                preferredWidth: 768
                preferredHeight: 140
                property int index: ListItem.indexInSection
                property int selectedIndexProxy: ListItem.view.selectedIndexProxy
                function setSelectedIndex(ind) {
                    ListItem.view.setSelectedIndex(ind)
                }
                function rejectProxy() {
                    ListItem.view.rejectProxy()
                }
                layout: DockLayout {
                            
                        }
                Container {
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                listCont.rejectProxy();
                            }
                        }
                    ]
                }
                property bool pressed: false
                Container {
                    preferredWidth: Math.max(700 + 40, 200)
                    preferredHeight: 140
                    horizontalAlignment: HorizontalAlignment.Center
                    layout: DockLayout {
                                
                            }
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                        background: (listCont.selectedIndexProxy == listCont.index)? (listCont.pressed? Color.create("#808080"): Color.create("#404040")): (listCont.pressed? Color.create("#808080"): Color.Transparent)
                    }

                    Label {
                        id: txt
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Center
                        text: qsTr(ListItemData.data)
                        textStyle {
                            color: (listCont.selectedIndexProxy == listCont.index)? Color.Blue: Color.White
                            base: SystemDefaults.TextStyles.BigText
                            textAlign: TextAlign.Left
                        }
                        //font.pixelSize: 26*UI.PLATFORM_SCALE_FACTOR
                    }
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                listCont.setSelectedIndex(listCont.index)
                            }
                        }
                    ]
                }
            }
        }
    }
}
