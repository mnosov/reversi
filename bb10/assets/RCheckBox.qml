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

Container {
    id: root
    preferredWidth: 400 + 44 + 5*3*2
    preferredHeight: 100
    signal clicked
    property bool buttonEnabled: true
    property alias text: textBlock.text
    layout: DockLayout {
            }
    ContainerBorder {
        borderSize: 2
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

    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        background: root.pressed? Color.create("#80ccb872"): Color.create("#ccb872")
    }

    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        background: Color.Gray
        opacity: 0.5
        visible: root.buttonEnabled
    }

    Container {
        id: imgCont
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Left
        leftPadding: 10
        ImageView {
            id: checkbox
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
            imageSource: "asset:///images/check.png"
            opacity: root.buttonEnabled? 1.0: 0.3
        }
    }
    Container {
        id: labelCont
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Left
        leftPadding: 10 + 44 + 10
        layout: DockLayout {
        }
        clipContentToBounds: false
        topPadding: 10
        bottomPadding: 10
        Label {
            id: textBlock
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
            textStyle {
                color: root.pressed? Color.create("#404040"): Color.Black
                base: SystemDefaults.TextStyles.BodyText
                textAlign: TextAlign.Left
            }
            attachedObjects: [
                LayoutUpdateHandler {
                    id: handler
                }
            ]
        }
    }

    gestureHandlers: [
        TapHandler {
            onTapped: {
                root.clicked();
            }
        }
    ]
}
