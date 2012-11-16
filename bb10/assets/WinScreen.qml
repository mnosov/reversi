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
    property bool clearWin: false //if this is a clear victory
    function activate(clWin) {
        clearWin = clWin;
        show(rootDialog.containerWidth/2, rootDialog.containerHeight/2)
    }

    function deactivate() {
        hide();
    }

    property bool playerWins: (gameEngine.isWhiteHuman && (gameEngine.whiteCount > gameEngine.blackCount)) ||
        (gameEngine.isBlackHuman && (gameEngine.whiteCount < gameEngine.blackCount));

    property bool playerAgainstComp: (gameEngine.isWhiteHuman && !gameEngine.isBlackHuman) ||
                                     (!gameEngine.isWhiteHuman && gameEngine.isBlackHuman)

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
            topPadding: 200
            leftPadding: 24
            rightPadding: 24
            layout: DockLayout {
                        
                    }
            Label {
                id: titleText
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle {
                    color: {
                        if (gameEngine.whiteCount > gameEngine.blackCount) {
                            return Color.White
                        } else if (gameEngine.whiteCount < gameEngine.blackCount) {
                            return Color.Black
                        }
                        return Color.create("#808080")
                    }
                    base: SystemDefaults.TextStyles.TitleText
                    textAlign: TextAlign.Center
                    fontSize: FontSize.PointValue
                    fontSizeValue: 80/4
                }
                multiline: true
                text: {
                    if (gameEngine.whiteCount == gameEngine.blackCount) {
                        return qsTr("Draw")
                    }

                    if ((gameEngine.isWhiteHuman && gameEngine.isBlackHuman) ||
                            (!gameEngine.isWhiteHuman && !gameEngine.isBlackHuman)) {
                        if (gameEngine.whiteCount > gameEngine.blackCount) {
                            return qsTr("White wins")
                        } else {
                            return qsTr("Black wins")
                        }
                    }
                    //player wins/loose against computer. Make congratulation more informative
                    if (rootDialog.playerWins) {
                        if (!rootDialog.clearWin) {
                            return qsTr("Congratulations! You win!")
                        } else {
                            return qsTr("Congratulations! You win!")
                        }
                    } else {
                        if (gameEngine.whiteCount > gameEngine.blackCount) {
                            return qsTr("White wins")
                        } else {
                            return qsTr("Black wins")
                        }
                    }
                }
            }
        }
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            topPadding: 500
            leftPadding: 24
            rightPadding: 24
            layout: DockLayout {
                        
                    }
            Label {
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle {
                    color: {
                        if (gameEngine.whiteCount > gameEngine.blackCount) {
                            return Color.White
                        } else if (gameEngine.whiteCount < gameEngine.blackCount) {
                            return Color.Black
                        }
                        return Color.create("#808080")
                    }
                    base: SystemDefaults.TextStyles.BodyText
                    textAlign: TextAlign.Center
                    fontSize: FontSize.PointValue
                    fontSizeValue: 45/4
                }
                multiline: true
                visible: rootDialog.clearWin && rootDialog.playerWins && rootDialog.playerAgainstComp
                text: {
                    var compSkill = gameEngine.isWhiteHuman? gameEngine.blackSkill: gameEngine.whiteSkill
                    if (compSkill == 1) {
                        return qsTr("You won against opponent with Elementary level. Try to play with harder level.")
                    } else if (compSkill == 2) {
                        return qsTr("You're having good skills for winning Easy level. How about Medium?")
                    } else if (compSkill == 3) {
                        return qsTr("Well, it was not so easy to win Medium level, was it?")
                    } else if (compSkill == 4) {
                        return qsTr("Nice game, congratulations!")
                    } else if (compSkill == 5) {
                        return qsTr("Wow! Excellent victory!")
                    } else if (compSkill == 6) {
                        return qsTr("This game was amazing! You're becoming Reversi professional :-)")
                    } else if (compSkill == 7) {
                        return qsTr("Unbelievable! You won against hardest level! What's next? Maybe play with different color?")
                    }
                }
            }
        }
    }
    property bool isFullyActive: false
    onFullyActive: {
        isFullyActive = true;
    }

    onFullyClosed: {
        isFullyActive = false;
    }
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

