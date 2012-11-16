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
    id: banner
//    height: text.height + 24*UI.PLATFORM_SCALE_FACTOR
    preferredWidth: 768-48
    minWidth: preferredWidth
    maxWidth: preferredWidth
    background: Color.Black //TODO: opacity and round corners
    opacity: 0.0
    visible: opacity > 0.1
    layout: DockLayout {}
    function show(txt) {
        text.text = txt;
        opacity = 1.0
        if (showTimer.running) {
            showTimer.stop();
            showTimer.start();
        } else {
            showTimer.start();
        }
    }
    function hide() {
        opacity = 0.0
        showTimer.stop();
    }
    topPadding: 24
    bottomPadding: 24
    Label {
        id: text
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center
        touchPropagationMode: TouchPropagationMode.None
        textStyle {
            color: Color.White
            base: SystemDefaults.TextStyles.BodyText
            textAlign: TextAlign.Center
        }
        maxWidth: 768 - 48 - 48
        multiline: true
    }
    attachedObjects: [
        Timer {
            id: showTimer
            interval: 5000
            onTimeout: {
                banner.hide();
            }
        }
    ]

    gestureHandlers: [
        TapHandler {
            onTapped: {
                banner.hide();
            }
        }
    ]
}
