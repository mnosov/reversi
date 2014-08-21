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
    id: chipRoot

    preferredWidth: 90
    preferredHeight: 90
    minHeight: 90
    maxHeight: 90
    minWidth: 90
    maxWidth: 90
    implicitLayoutAnimationsEnabled: false
    signal clicked
    //background: (curColor == Defs.White)? Color.Red: Color.Transparent

    //property int animDuration: 500 * (gameEngine.setupMode? 0.3: 1)
    property int curColor: Defs.NoColor
    property int appliedColor: Defs.NoColor
    property int imgIndex: ((curColor == Defs.White)? 12: 1)
    
    property bool isSetupMode: false
    property bool canMoveCurrent: false
    property bool showPossibleMoves: false
    property bool humanMove: false
    onCreationCompleted: {
        imgContent.imageSource = ((curColor == Defs.White)? "asset:///images/bw12.png": "asset:///images/bw1.png")
        appliedColor = curColor
    }
    onCurColorChanged: {
        if ((curColor == Defs.NoColor && appliedColor == Defs.NoColor) || curColor == appliedColor) {
            return;
        }
        console.log("Current color changed:" + appliedColor + " " + curColor + imgContent.imageSource);
        if (appliedColor != Defs.NoColor && curColor != Defs.NoColor && curColor != appliedColor) {
            if (curColor == Defs.White) {
                console.log("Start black->white")
                animTimer.stop();
                animTimer.current = 0
                animTimer.dest = 12
                animTimer.start();
            } else {
                console.log("Start white->black")
                animTimer.stop();
                animTimer.current = 13
                animTimer.dest = 1
                animTimer.start();
            }
        } else {
            animTimer.stop();
            imgContent.imageSource = ((curColor == Defs.White)? "asset:///images/bw12.png": "asset:///images/bw1.png")
        }
        appliedColor = curColor
    }
    layout: DockLayout {
                
            }
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        topPadding: 10
        bottomPadding: 10
        leftPadding: 10
        rightPadding: 10
        layout: DockLayout {      
        }
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            background: Color.Gray
            opacity: chipRoot.pressed? 1.0: 0.0
        }
    }

    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        background: Color.Gray
        opacity: 0.5
        visible: chipRoot.isSetupMode
    }

    ImageView {
        id: checkPlaceHolder
        visible: chipRoot.canMoveCurrent && chipRoot.showPossibleMoves && chipRoot.humanMove && !chipRoot.isSetupMode
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        imageSource: "asset:///images/check.png"
    }

    ImageView {
        id: imgContent
        implicitLayoutAnimationsEnabled: false
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        imageSource: ""
        opacity: (chipRoot.curColor == Defs.NoColor)? 0: 1
        scaleX: (chipRoot.curColor == Defs.NoColor)? 0: 1
        scaleY: (chipRoot.curColor == Defs.NoColor)? 0: 1
    }

    gestureHandlers: [
        TapHandler {
            onTapped: {
                chipRoot.clicked();
            }
        }
    ]
    
    attachedObjects: [
        Timer {
            id: animTimer
            property int current: 0
            property int dest: 0
            interval: 20
            onTimeout: {
                console.log("AnimTimer triggered:" + current + " " + dest)
                if (current < dest) {
                    current++
                } else if (current > dest) {
                    current--
                }
                imgContent.imageSource = "asset:///images/bw"+current+".png"
                if (current == dest) {
                    stop();
                }
            }
        }
    ]
    property bool pressed: false
    onTouch: {
        if (event.touchType == TouchType.Down) {
            pressed = true;
        } else if (event.touchType != TouchType.Move) {
            pressed = false;
        }
    }
}
