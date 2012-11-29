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

ContainerLH {
    id: rootWindow

    property int chipWidth: 90
    property int chipHeight: 90
    property int topOffset: 0
    property int leftOffset: 0

    property bool isInPortrait: (rootWindow.containerWidth < rootWindow.containerHeight)? true: false

    property int moveAnimationDuration: 500

    property bool undoing: false
    property bool humanMove: ((gameEngine.curPlayer == Defs.White && gameEngine.isWhiteHuman) ||
            (gameEngine.curPlayer == Defs.Black && gameEngine.isBlackHuman))


    property bool showPossibleMoves: false

    property bool isLastGameClear: true //this means that you didn't change level, moved back, or setup position during the game

    property bool isPendingNew: false
    
    layout: DockLayout {
    }

    background: Color.Black
    
    ImageView {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        imageSource: "asset:///images/background.png"
    }

    ImageView {
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Top
        imageSource: "asset:///images/boardbig.png"
    }

    attachedObjects: [
	    Timer {
	        id: proxyTimer
	        interval: 10
	        onTimeout: {
	            console.log("Proxy timer triggered");
	            proxyTimer.stop();
	            proxyTimer.interval = 10;
	            moveTimer.stop();
	            moveTimer.start();
	        }
	    },
	    Timer {
	        id: moveTimer
	        interval: 500
	        onTimeout: {
	            moveTimer.stop();
	            console.log("Timer triggered: game over = " + gameEngine.isGameOver());
	            checkMove();
	        }
	    },
	    Timer { //TODO
	        id: undoTimer
	        interval: moveAnimationDuration
	        singleShot: false
	        //running: undoing
	        property bool lastUndo: false
	        onTimeout: {
	            console.log("Undo timer triggered");
	            if (gameEngine.setupMode) {
	                return;
	            }
	
	            if (lastUndo) {
	                undoTimer.stop();
	                //undoing = false;
	                return;
	            }
	
	            if (gameEngine.canUndo()) {
	                lastUndo = !gameEngine.undo();
	            }
	        }
	    }
	]
    ListView {
        id: chipGrid
        layout: GridListLayout {
            columnCount: 8
        }
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        dataModel: gameModel
        //enabled: false
        touchPropagationMode: TouchPropagationMode.PassThrough
        function makeMoveProxy(index) {
            gameEngine.makeMove(index);
        }
        function restartTimerProxy() {
            restartTimer();
        }
        property bool setupModeProxy: gameEngine.setupMode
        function changeColorProxy(index) {
            gameEngine.changeColor(index)
        }
        property bool humanMoveProxy: rootWindow.humanMove
        property bool showPossibleMovesProxy: rootWindow.showPossibleMoves
        
        
        listItemComponents: ListItemComponent {
            Chip {
                id: chip
                canMoveCurrent: ListItemData.canMoveCurrent
                isSetupMode: ListItem.view.setupModeProxy
                showPossibleMoves: ListItem.view.showPossibleMovesProxy
                humanMove: ListItem.view.humanMoveProxy
                curColor: ListItemData.dataColor

                onClicked: {
                    console.log("Chip clicked:"+ListItem.indexInSection);
                    if (ListItem.view.setupModeProxy) {
                        ListItem.view.changeColorProxy(ListItem.indexInSection);
                        return;
                    }

                    if (ListItem.view.humanMoveProxy /*&& !moveTimer.running && !proxyTimer.running*/) { //TODO: running state for timers
                        if (ListItemData.canMoveCurrent) {
                            ListItem.view.makeMoveProxy(ListItem.indexInSection);
//                            currentMove = computerColor;
                            ListItem.view.restartTimerProxy();
                        }
                    } else {
                        console.log("Please wait");
                    }
                }
            }
        }
    }

    InfoBanner {
        id: infoBanner
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        //preferredWidth: 650 //TODO infoArea.width - 30
    }

    Container {
        id: infoArea
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Bottom
        bottomPadding: 1280-768-140-10
        touchPropagationMode: TouchPropagationMode.PassThrough
        overlapTouchPolicy: OverlapTouchPolicy.Allow
        layout: DockLayout {}
        ContainerLH {
            id: countInfo
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Top
            layout: DockLayout {}
            PlayerInfoArea {
                id: playerCountInfo
                preferredWidth: countInfo.containerWidth/2
                color: Defs.White
            }
            PlayerInfoArea {
                id: compCountInfo
                preferredWidth: countInfo.containerWidth/2
                color: Defs.Black
                horizontalAlignment: HorizontalAlignment.Right
            }
        }
    }
    Container {
        id: buttonsRow
        verticalAlignment: VerticalAlignment.Bottom
        horizontalAlignment: HorizontalAlignment.Fill
        bottomPadding: infoArea.bottomPadding - 140
        topPadding: 0
        leftPadding: 20
        rightPadding: 20
        property int buttonWidth: containerWidth/3 - 10*2
        layout: DockLayout {
                    
                }
        RButton {
            id: undoButton
            preferredWidth: buttonsRow.buttonWidth
            horizontalAlignment: HorizontalAlignment.Left
            text: qsTr("Undo")
            buttonEnabled: !gameEngine.setupMode
            onClicked: {
                if (gameEngine.canUndo()) {
                    interruptCurrentThinking();
                    undoTimer.lastUndo = false;
                    //undoing = true;
                    undoTimer.stop();
                    undoTimer.start();
                    undoTimer.lastUndo = !gameEngine.undo();
                    isLastGameClear = false; //if player wins with "undo" - it is not a clear victory
                }
            }
        }
        RButton {
            text: qsTr("New")
            preferredWidth: buttonsRow.buttonWidth
            horizontalAlignment: HorizontalAlignment.Center
            buttonEnabled: !gameEngine.setupMode
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

        RButton {
            text: gameEngine.setupMode? qsTr("Done"): isInPortrait? qsTr("Setup"): qsTr("Setup_short")
            buttonEnabled: true
            preferredWidth: buttonsRow.buttonWidth
            horizontalAlignment: HorizontalAlignment.Right
            onClicked: {
                interruptCurrentThinking();
                if (!gameEngine.setupMode) {
                    gameEngine.setupMode = true;
                } else {
                    gameEngine.setupMode = false;
                    gameEngine.clearUndoStack();
                    gameModel.updateMovePossibity();
                    if (gameEngine.isInitialPosition() || gameEngine.isOneMoved()) {
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

    Container {
        verticalAlignment: VerticalAlignment.Bottom
        bottomPadding: buttonsRow.bottomPadding - 100
        horizontalAlignment: HorizontalAlignment.Left
        leftPadding: 20
        rightPadding: 20
        preferredHeight: checkBox.preferredHeight
        layout: DockLayout {
        }
        RCheckBox {
            id: checkBox
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Left
            text: qsTr("Show possible moves")
            buttonEnabled: rootWindow.showPossibleMoves
            onClicked: {
                rootWindow.showPossibleMoves = !rootWindow.showPossibleMoves
            }
        }
    }

    RButton {
        verticalAlignment: VerticalAlignment.Bottom
        bottomPadding: 10
        horizontalAlignment: HorizontalAlignment.Right
        rightPadding: 20
        text: qsTr("About")
        preferredWidth: 240
        onClicked: {
            console.log("onAboutClicked")
            interruptCurrentThinking();
            aboutScreen.show(mouseWindowX, mouseWindowY);
        }
    }

    function showSelectionDialog(playerColor, startX, startY) {
        interruptCurrentThinking();
        selectSkill.showFor(playerColor, startX, startY)
    }

    RSelectionDialog {
        id: selectSkill
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
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

        model: XmlDataModel { source: "models/skills.xml" }

        onAccepted: {
            isLastGameClear = gameEngine.isInitialPosition() || gameEngine.isOneMoved(); //if player changes skill during play - it is not clear victory
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
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
    }

    AboutScreen {
        id: aboutScreen
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        onRejected: {
            if (!gameEngine.isGameOver()) {
                checkMove();
            }
        }
    }

    function restartTimer() {
        proxyTimer.stop();
        proxyTimer.start();
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

    onCreationCompleted: {
        /*console.log("Main item loaded:"+rootWindow.width+"x"+rootWindow.height);
        skillModel.append({"data": getStringForSkill(true, -1), "skill": -1});
        for (var i = 1; i <= 7; i++) {
            skillModel.append({"data": getStringForSkill(false, i), "skill": i});
        }*/
        gameEngine.computerMoved.connect(restartTimer);
        if (!humanMove) {
            proxyTimer.interval = 1000;
            restartTimer();
        } else {
            checkMove();
        }
    }
}
