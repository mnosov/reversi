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

ContainerLH {
    id: root
    preferredWidth: 200
    maxWidth: preferredWidth
    minWidth: preferredWidth
    preferredHeight: 100
    signal clicked(int mouseWindowX, int mouseWindowY)
    property bool buttonEnabled: true
    property alias text: textBlock.text
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
        background: pressed? Color.create("#80ccb872"): Color.create("#ccb872")
        touchPropagationMode: TouchPropagationMode.None
    }
    ContainerBorder {
        borderSize: 1
    }
    layout: DockLayout{}
    bottomPadding: pressed? 0: 0
    Label {
        id: textBlock
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        //anchors.centerIn: parent
        maxWidth: root.containerWidth - 20
        multiline: true
        touchPropagationMode: TouchPropagationMode.None
        textStyle {
            color: root.buttonEnabled? (root.pressed? Color.create("#404040"): Color.Black): Color.create("#404040")
            base: SystemDefaults.TextStyles.BodyText
            textAlign: TextAlign.Left
        }
        //verticalAlignment: Text.AlignVCenter
        //horizontalAlignment: Text.AlignHCenter
        //anchors.verticalCenterOffset: marea.pressed? -1: 0
        //font.pixelSize: 17*UI.PLATFORM_SCALE_FACTOR
        //color: root.enabled? (marea.pressed? "#404040": "black"): "#404040"
    }

    gestureHandlers: [
        TapHandler {
            onTapped: {
                if (root.buttonEnabled) {
                    root.clicked(root.lastPressedWindowX, root.lastPressedWindowY)
                }
            }
        }
    ]
}
