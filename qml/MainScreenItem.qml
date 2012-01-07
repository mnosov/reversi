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
import Reversi 1.0
import "UIConstants.js" as UI

Item {
    id: rootWindow

    property int chipWidth: 45*UI.PLATFORM_SCALE_FACTOR
    property int chipHeight: 45*UI.PLATFORM_SCALE_FACTOR
    property int topOffset: 0
    property int leftOffset: 0

    property bool isInPortrait: (rootWindow.width < rootWindow.height)? true: false

    property int moveAnimationDuration: 500

    property bool undoing: false
    property bool humanMove: ((gameEngine.curPlayer == Defs.White && gameEngine.isWhiteHuman) ||
            (gameEngine.curPlayer == Defs.Black && gameEngine.isBlackHuman))


    property bool showPossibleMoves: false

    property bool isLastGameClear: true //this means that you didn't change level, moved back, or setup position during the game
    property bool isPendingNew: false
/*    onCurrentMoveChanged: {
        gameModel.updateMovePossibity();
    }*/

    Image {
        anchors.fill: parent
        source: "qrc:/resources/background.png"
    }

    Image {
        anchors.left: parent.left
        anchors.top: parent.top
        source: "qrc:/resources/boardbig.png"
    }

    Timer {
        id: proxyTimer
        interval: 10
        repeat: false
        onTriggered: {
            proxyTimer.interval = 10;
            moveTimer.restart();
        }
    }

    Timer {
        id: moveTimer
        interval: moveAnimationDuration
        repeat:  false
        onTriggered: {
            console.log("Timer triggered: game over = " + gameEngine.isGameOver());
            checkMove();
        }
    }

    Timer {
        id: undoTimer
        interval: moveAnimationDuration
        repeat: true
        running: undoing
        property bool lastUndo: false
        onTriggered: {
            console.log("Undo timer triggered");
            if (gameEngine.setupMode) {
                return;
            }

            if (lastUndo) {
                undoing = false;
                return;
            }

            if (gameEngine.canUndo()) {
                lastUndo = !gameEngine.undo();
            }
        }
    }

    GridView {
        id: chipGrid
        anchors.top: parent.top
        anchors.topMargin: rootWindow.topOffset
        anchors.left: parent.left
        anchors.leftMargin: rootWindow.leftOffset
        width: cellWidth * 8
        height: cellHeight * 8
        cellWidth: rootWindow.chipWidth
        cellHeight: rootWindow.chipHeight
        model: gameModel
        interactive: false
        delegate: Chip {
            id: chip
            property bool isChipWhite: isWhite
            property bool isChipBlack: isBlack
            curColor: {
                //console.log("Getcur color: " + Defs.White + " " +   Defs.Black + " " + Defs.NoColor);
                return isChipWhite? Defs.White: (isChipBlack? Defs.Black: Defs.NoColor)
            }
            onIsChipWhiteChanged: {
                console.log("White changed for " + index);
            }
            onIsChipBlackChanged: {
                console.log("Black changed for " + index);
            }

            onClicked: {
                if (gameEngine.setupMode) {
                    gameEngine.changeColor(index);
                    return;
                }

                if (rootWindow.humanMove && !moveTimer.running && !proxyTimer.running) {
                    if (canMoveCurrent) {
                        gameEngine.makeMove(index);
//                        currentMove = computerColor;
                        restartTimer();
                    }
                } else {
                    console.log("Please wait");
                }
            }
        }
    }

    InfoBanner {
        id: infoBanner
        z: 2
        anchors.top: infoArea.top
        anchors.topMargin: 10*UI.PLATFORM_SCALE_FACTOR
        width: infoArea.width - 30 * 2*UI.PLATFORM_SCALE_FACTOR
        anchors.horizontalCenter: infoArea.horizontalCenter
    }

    Item {
        id: infoArea
        anchors.top: isInPortrait? chipGrid.bottom: parent.top
        anchors.bottom: parent.bottom
        anchors.left: isInPortrait? parent.left: chipGrid.right
        anchors.right: parent.right

        Item {
            id: countInfo
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: playerCountInfo.height
            PlayerInfoArea {
                id: playerCountInfo
                width: parent.width/2
                color: Defs.White

            }
            PlayerInfoArea {
                id: compCountInfo
                width: parent.width/2
                color: Defs.Black
                anchors.left: playerCountInfo.right
            }
        }

        Item {
            id: buttonsRow
            anchors.top: countInfo.bottom
            anchors.topMargin: 10*UI.PLATFORM_SCALE_FACTOR
            anchors.leftMargin: 10*UI.PLATFORM_SCALE_FACTOR
            anchors.left: parent.left
            anchors.rightMargin: 10*UI.PLATFORM_SCALE_FACTOR
            anchors.right: parent.right
            property int buttonWidth: width/3 - 4*UI.PLATFORM_SCALE_FACTOR
            height: undoButton.height
            Button {
                id: undoButton
                width:buttonsRow.buttonWidth
                anchors.left: parent.left
                text: qsTr("Undo")
                enabled: !gameEngine.setupMode
                onClicked: {
                    if (gameEngine.canUndo()) {
                        interruptCurrentThinking();
                        undoTimer.lastUndo = false;
                        undoing = true;
                        undoTimer.lastUndo = !gameEngine.undo();
                        isLastGameClear = false; //if player wins with "undo" - it is not a clear victory
                    }
                }
            }
            Button {
                text: qsTr("New")
                width:buttonsRow.buttonWidth
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: !gameEngine.setupMode
                onClicked: {
                    if (gameEngine.isComputerThinking()) {
                        isPendingNew = true;
                        interruptCurrentThinking();
                    } else {
                        gameEngine.restartGame();
                        isLastGameClear = true;
                        checkMove();
                    }
                }
            }

            Button {
                text: gameEngine.setupMode? qsTr("Done"): isInPortrait? qsTr("Setup"): qsTr("Setup_short")
                enabled: true
                width:buttonsRow.buttonWidth
                anchors.right: parent.right
                onClicked: {
                    interruptCurrentThinking();
                    if (!gameEngine.setupMode) {
                        gameEngine.setupMode = true;
                    } else {
                        gameEngine.setupMode = false;
                        gameEngine.clearUndoStack();
                        gameModel.updateMovePossibity();
                        if (gameEngine.isInitialPosition()) {
                            isLastGameClear = true;
                        } else {
                            isLastGameClear = false; //if player wins after setup position - it is not a clear victory
                        }

                        if (!gameEngine.isGameOver()) {
                            checkMove();
                        }
                    }
                }
            }
        }

        CheckBox {
            anchors.top: buttonsRow.bottom
            anchors.topMargin: 10*UI.PLATFORM_SCALE_FACTOR
            anchors.left: parent.left
            anchors.leftMargin: 10*UI.PLATFORM_SCALE_FACTOR
            text: qsTr("Show possible moves")
            enabled: rootWindow.showPossibleMoves
            onClicked: {
                rootWindow.showPossibleMoves = !rootWindow.showPossibleMoves
            }
        }

        Button {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15*UI.PLATFORM_SCALE_FACTOR
            anchors.left: parent.left
            anchors.leftMargin: 10*UI.PLATFORM_SCALE_FACTOR
            width: 100*UI.PLATFORM_SCALE_FACTOR
            height: 60*UI.PLATFORM_SCALE_FACTOR
            text: qsTr("Exit")
            visible: UI.PLATFORM_SHOW_EXIT
            onClicked: {
                interruptCurrentThinking();
                Qt.quit();
            }
        }
        Button {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15*UI.PLATFORM_SCALE_FACTOR
            anchors.right: parent.right
            anchors.rightMargin: 10*UI.PLATFORM_SCALE_FACTOR
            text: qsTr("About")
            width: 120*UI.PLATFORM_SCALE_FACTOR
            onClicked: {
                var obj = mapToItem(aboutScreen, mouseX, mouseY);
                interruptCurrentThinking();
                aboutScreen.show(obj.x, obj.y);
            }
        }
    }

    function showSelectionDialog(playerColor, startX, startY) {
        interruptCurrentThinking();
        selectSkill.showFor(playerColor, startX, startY)
    }

    SelectionDialog {
        id: selectSkill
        anchors.fill: parent
        property int destColor: Defs.White
        function showFor (playerColor, stX, stY) {
            destColor = playerColor;
            if (destColor == Defs.White) {
                if (gameEngine.isWhiteHuman) {
                    selectedIndex = 0;
                } else {
                    selectedIndex = gameEngine.whiteSkill
                }
            } else {
                if (gameEngine.isBlackHuman) {
                    selectedIndex = 0;
                } else {
                    selectedIndex = gameEngine.blackSkill
                }
            }

            doShow(stX, stY);
        }

        model: ListModel {
            id: skillModel
        }

        onAccepted: {
            isLastGameClear = gameEngine.isInitialPosition(); //if player changes skill during play - it is not clear victory
            if (destColor == Defs.White) {
                if (selectedIndex == 0) {
                    gameEngine.isWhiteHuman = true;
                } else {
                    gameEngine.isWhiteHuman = false;
                    gameEngine.whiteSkill = selectedIndex;
                }
            } else {
                if (selectedIndex == 0) {
                    gameEngine.isBlackHuman = true;
                } else {
                    gameEngine.isBlackHuman = false;
                    gameEngine.blackSkill = selectedIndex;
                }
            }
            //TODO: pause active thinking
            if (!gameEngine.isGameOver()) {
                checkMove();
            }
        }
        onRejected: {
            if (!gameEngine.isGameOver()) {
                checkMove();
            }
        }
    }

    WinScreen {
        id: winScreen
        anchors.fill: parent
    }

    AboutScreen {
        id: aboutScreen
        anchors.fill: parent
        onRejected: {
            if (!gameEngine.isGameOver()) {
                checkMove();
            }
        }
    }

    Connections {
        target: gameEngine
        onComputerMoved: {
            console.log("computer moved");
            //gameEngine.curPlayer = gameEngine.opponentColor(gameEngine.curPlayer);
            restartTimer();
        }
    }

    function restartTimer() {
        proxyTimer.restart();
    }

    function interruptCurrentThinking() {
        gameEngine.interrupt();
        proxyTimer.stop();
        proxyTimer.interval = 10;
        moveTimer.stop();
    }

    function checkMove() {
        if (gameEngine.setupMode) {
            return;
        }
        if (gameEngine.isGameOver()) {
            console.log("Game over");
            infoBanner.hide();
            winScreen.activate(isLastGameClear);
            return;
        }
        if (gameEngine.isComputerThinking()) {
            console.log("CheckMove - computer is currently thinking")
            return; //avoid any messages or moves when computer is thinking
        }

        if (rootWindow.humanMove) {
            console.log("Check move - human: " + gameEngine.curPlayer);
            if (!gameEngine.isAnyMovePossible(gameEngine.curPlayer)) {
                gameEngine.curPlayer = gameEngine.opponentColor(gameEngine.curPlayer);
                if (gameEngine.curPlayer == Defs.White) {
                    infoBanner.show(qsTr("Black can't move. White will move once again"));
                } else {
                    infoBanner.show(qsTr("White can't move. Black will move once again"));
                }

                gameModel.updateMovePossibity();
                if (!rootWindow.humanMove) {
                    gameEngine.makeComputerMove();
                    if (isPendingNew) {
                        isPendingNew = false;
                        gameEngine.restartGame();
                        isLastGameClear = true;
                        checkMove();
                    }
                }
            }
        } else {
            console.log("Check move - computer");
            var success = gameEngine.makeComputerMove();
            if (isPendingNew) {
                isPendingNew = false;
                gameEngine.restartGame();
                isLastGameClear = true;
                checkMove();
                return;
            }
            if (!success && !gameEngine.isAnyMovePossible(gameEngine.curPlayer)) {
                gameEngine.curPlayer = gameEngine.opponentColor(gameEngine.curPlayer);
                if (gameEngine.curPlayer == Defs.White) {
                    infoBanner.show(qsTr("Black can't move. White will move once again"));
                } else {
                    infoBanner.show(qsTr("White can't move. Black will move once again"));
                }
                gameModel.updateMovePossibity();
                if (!rootWindow.humanMove) {
                    gameEngine.makeComputerMove();
                    if (isPendingNew) {
                        isPendingNew = false;
                        gameEngine.restartGame();
                        isLastGameClear = true;
                        checkMove();
                    }
                }
            }
        }
    }

    function getStringForSkill(isHuman, skill) {
        if (isHuman) {
            return qsTr("Human_long")
        } else if (skill == 1) {
            return qsTr("Computer - Elementary")
        } else if (skill == 2) {
            return qsTr("Computer - Easy")
        } else if (skill == 3) {
            return qsTr("Computer - Medium")
        } else if (skill == 4) {
            return qsTr("Computer - Difficult")
        } else if (skill == 5) {
            return qsTr("Computer - Hard")
        } else if (skill == 6) {
            return qsTr("Computer - Very hard")
        } else if (skill == 7) {
            return qsTr("Computer - Impossible")
        }
        return qsTr("Skill %1").arg(skill);
    }

    function getShortStringForSkill(isHuman, skill) {
        if (isHuman) {
            return qsTr("Human")
        } else if (skill == 1) {
            return qsTr("Elementary")
        } else if (skill == 2) {
            return qsTr("Easy")
        } else if (skill == 3) {
            return qsTr("Medium")
        } else if (skill == 4) {
            return qsTr("Difficult")
        } else if (skill == 5) {
            return qsTr("Hard")
        } else if (skill == 6) {
            return qsTr("Very hard")
        } else if (skill == 7) {
            return qsTr("Impossible")
        }
        return qsTr("Skill %1").arg(skill)
    }

    Component.onCompleted: {
        console.log("Main item loaded:"+rootWindow.width+"x"+rootWindow.height);
        skillModel.append({"data": getStringForSkill(true, -1), "skill": -1});
        for (var i = 1; i <= 7; i++) {
            skillModel.append({"data": getStringForSkill(false, i), "skill": i});
        }
        if (!humanMove) {
            proxyTimer.interval = 2000;
            restartTimer();
        } else {
            checkMove();
        }
    }
}
