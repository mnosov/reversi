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
import Qt.labs.particles 1.0

Dialog {
    id: rootDialog
    property bool clearWin: false //if this is a clear victory
    function activate(clWin) {
        clearWin = clWin;
        show(rootDialog.width/2, rootDialog.height/2)
    }

    function deactivate() {
        hide();
    }

    property bool playerWins: (gameEngine.isWhiteHuman && (gameEngine.whiteCount > gameEngine.blackCount)) ||
        (gameEngine.isBlackHuman && (gameEngine.whiteCount < gameEngine.blackCount));

    property bool playerAgainstComp: (gameEngine.isWhiteHuman && !gameEngine.isBlackHuman) ||
                                     (!gameEngine.isWhiteHuman && gameEngine.isBlackHuman)
    content: Item {
        anchors.fill: parent
            Image {
            anchors.fill: parent
            source: "qrc:/resources/background.png"
            opacity: 0.5
        }
        Text {
            id: titleText
            z: 5
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: inPortrait? 100: 20
            font.pixelSize: 45
            color: {
                if (gameEngine.whiteCount > gameEngine.blackCount) {
                    return "white"
                } else if (gameEngine.whiteCount < gameEngine.blackCount) {
                    return "black"
                }
                return "#808080"
            }

            width: parent.width - 24
            wrapMode: Text.WordWrap
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
        Text {
            z: 5
            horizontalAlignment: Text.AlignHCenter
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.top: titleText.bottom
            anchors.topMargin: inPortrait? 100: 20
            font.pixelSize: 25
            color: {
                if (gameEngine.whiteCount > gameEngine.blackCount) {
                    return "white"
                } else if (gameEngine.whiteCount < gameEngine.blackCount) {
                    return "black"
                }
                return "#808080"
            }

            width: parent.width - 24
            wrapMode: Text.WordWrap
            visible: rootDialog.clearWin && rootDialog.playerWins && rootDialog.playerAgainstComp
            text: {
                var compSkill = gameEngine.isWhiteHuman? gameEngine.blackSkill: gameEngine.whiteSkill
                if (compSkill == 1) {
                    return qsTr("You won against opponent with Elementary level. Try to play with harder level.")
                } else if (compSkill == 2) {
                    return qsTr("You're having good skills for winning Easy level. How about Medium?")
                } else if (skill == 3) {
                    return qsTr("Well, it was not so easy to win Medium level, was it?")
                } else if (skill == 4) {
                    return qsTr("Nice game, congratulations!")
                } else if (skill == 5) {
                    return qsTr("Wow! Excellent victory!")
                } else if (skill == 6) {
                    return qsTr("This game was amazing! You're becoming Reversi professional :-)")
                } else if (skill == 7) {
                    return qsTr("Unbelievable! You won against hardest level! What's next? Maybe play with different color?")
                }
            }
        }

        Component {
            id: particles
            Item {
                anchors.fill: parent
                Particles {
                    z: 4
                    y: parent.height
                    x: parent.width / 2
                    visible: gameEngine.whiteCount != gameEngine.blackCount
                    width: 1
                    height: 1
                    source: (gameEngine.whiteCount > gameEngine.blackCount)? "qrc:/resources/bw12.png":"qrc:/resources/bw1.png"
                    lifeSpan: 5000
                    count: 50
                    angle: 270
                    angleDeviation: 90
                    velocity: 100
                    velocityDeviation: 60
                    ParticleMotionGravity {
                        yattractor: 1000
                        xattractor: 0
                        acceleration: 35
                    }
                }
                Item {
                    z: 2
                    anchors.right: parent.right
                    anchors.top: parent.top
                    width: 1
                    height: parent.height
                    Particles {
                        y: parent.height
                        x: parent.width
                        width: 1
                        height: 1
                        source: {
                            if (gameEngine.whiteCount > gameEngine.blackCount) {
                                return "qrc:/resources/bw1.png"
                            } else {
                                return "qrc:/resources/bw12.png"
                            }
                        }
                        lifeSpan: 5000
                        count: 12
                        angle: 270-30
                        angleDeviation: 40 //240/6
                        velocity: 60
                        velocityDeviation: 30
                        ParticleMotionGravity {
                            yattractor: 1000
                            xattractor: 0
                            acceleration: 35
                        }
                    }
                }
                Particles {
                    z: 2
                    y: parent.height
                    x: 0
                    width: 1
                    height: 1
                    source: {
                        if (gameEngine.whiteCount < gameEngine.blackCount) {
                            return "qrc:/resources/bw12.png"
                        } else {
                            return "qrc:/resources/bw1.png"
                        }
                    }
                    lifeSpan: 5000
                    count: 12
                    angle: 270+30
                    angleDeviation: 50 //300/6
                    velocity: 60
                    velocityDeviation: 30
                    ParticleMotionGravity {
                        yattractor: 1000
                        xattractor: 0
                        acceleration: 35
                    }
                }
            }
        }
        Loader {
            id: particlesLoader
            anchors.fill: parent
            sourceComponent: null

        }
    }
    onFullyActive: {
        particlesLoader.sourceComponent = particles
    }

    onFullyClosed: {
        particlesLoader.sourceComponent = null
    }
}

