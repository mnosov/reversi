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
    property int animDuration: 300
    id: rootDialog

    property alias content: contentItem.controls
    property bool rejectOnOutsideClick: true
    layout: AbsoluteLayout {
    }
    function show(posX, posY) {
        console.log("show dialog: " + posX + " " + posY);
        innerItem.startX = posX
        innerItem.startY = posY
        innerItem.scaleX = 1;
        visible = true;
        
        fadeTransition.fromOpacity = 0.0
        fadeTransition.toOpacity = 1.0
        scaleTransition.fromX = 0.0
        scaleTransition.toX = 1.0
        scaleTransition.fromY = 0.0
        scaleTransition.toY = 1
        translateTransition.fromX = posX - containerWidth/2
        translateTransition.toX = 0
        translateTransition.fromY = posY - containerHeight/2
        translateTransition.toY = 0
        anim.stop();
        anim.play();
    }

    function hide() {
        fadeTransition.fromOpacity = 1.0
        fadeTransition.toOpacity = 0.0
        scaleTransition.fromX = 1.0
        scaleTransition.toX = 0.0
        scaleTransition.fromY = 1.0
        scaleTransition.toY = 0
        translateTransition.toX = innerItem.startX - containerWidth/2
        translateTransition.fromX = 0
        translateTransition.toY = innerItem.startY - containerHeight/2
        translateTransition.fromY = 0
        anim.stop();
        anim.play();
    }

    visible: false

    signal accepted
    signal rejected
    signal fullyActive
    signal fullyClosed

    function accept() {
        hide();
        accepted();
    }

    function reject() {
        hide();
        rejected();
    }

    Container {
        id: innerItem
        preferredWidth: rootDialog.containerWidth
        preferredHeight: rootDialog.containerHeight
        scaleX: 0
        scaleY: scaleX
        visible: scaleX > 0.01
        property int startX: 0
        property int startY: 0
        opacity: scaleX

        translationX: (startX - preferredWidth/2) * (1-scaleX)
        translationY: (startY - preferredHeight/2) * (1-scaleY)
        layout: DockLayout {
                }
        attachedObjects: [
            ImplicitAnimationController {
                enabled: false
            }
        ]

        animations: [
            ParallelAnimation {
                id: anim
                ScaleTransition {
                    id: scaleTransition
                    duration: rootDialog.animDuration
                }
                FadeTransition {
                    id: fadeTransition
                    duration: rootDialog.animDuration
                    easingCurve: StockCurve.Linear
                }
                TranslateTransition {
                    id: translateTransition
                    duration: rootDialog.animDuration
                }
                onEnded: {
                    if (innerItem.opacity == 1.0) {
                        console.log("Dialog fully active")
                        rootDialog.fullyActive();
                    } else if (innerItem.opacity == 0.0) {
                        console.log("Dialog fully closed")
                        rootDialog.fullyClosed();
                        rootDialog.visible = false
                    }
                }
            }
        ]

        Container {
            id: background
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            background: Color.Black
            opacity: 0.9
        }

        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            gestureHandlers: [
                TapHandler {
                    onTapped: {
                        if (rootDialog.rejectOnOutsideClick) {
                            console.log("Pressed outside - reject dialog");
                            rootDialog.reject();
                        }
                    }
                }
            ]
        }

        Container {
            id: contentItem
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            touchPropagationMode: TouchPropagationMode.PassThrough
            overlapTouchPolicy: OverlapTouchPolicy.Allow
            layout: DockLayout {
                        
                    }
        }
    }
}
