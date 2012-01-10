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
#ifndef REVERSI_GAME_ENGINE_H
#define REVERSI_GAME_ENGINE_H

#include <QObject>
#include <QStack>
#include "Engine.h"

class BoardModel;
class QDeclarativeContext;

class GameEngine: public QObject, public GameInterface {
    Q_OBJECT
    Q_PROPERTY (int whiteCount READ getWhiteCount NOTIFY whiteCountChanged)
    Q_PROPERTY (int blackCount READ getBlackCount NOTIFY blackCountChanged)
    Q_PROPERTY (int whiteSkill READ getWhiteSkill WRITE setWhiteSkill NOTIFY whiteSkillChanged)
    Q_PROPERTY (int blackSkill READ getBlackSkill WRITE setBlackSkill NOTIFY blackSkillChanged)
    Q_PROPERTY (bool isWhiteHuman READ getIsWhiteHuman WRITE setIsWhiteHuman NOTIFY whiteHumanChanged)
    Q_PROPERTY (bool isBlackHuman READ getIsBlackHuman WRITE setIsBlackHuman NOTIFY blackHumanChanged)
    Q_PROPERTY (bool undoing READ getUndoing WRITE setUndoing NOTIFY undoingChanged)
    Q_PROPERTY (int curPlayer READ getCurPlayer WRITE setCurPlayer NOTIFY curPlayerChanged)
    Q_PROPERTY (bool setupMode READ getSetupMode WRITE setSetupMode NOTIFY setupModeChanged)

public:
    explicit GameEngine(QDeclarativeContext *context, QObject* parent = 0);
    virtual ~GameEngine();

public: //from GameInterface
    /**
     *  @return a color of the current player
     */
    Defs::ChipColor currentPlayer() const { return (Defs::ChipColor)m_curPlayer; }

    /**
     *  @return score (number of chips) of the player
     */
    int playerScore( Defs::ChipColor player ) const;
    /**
     *  @return color of the chip at position [row, col]
     */
    Defs::ChipColor chipColorAt( int row, int col ) const;

    /**
     *  @return if move is possible to specified position by specified color
     */
    bool isMovePossible( const KReversiPos& move ) const;

public:
    Q_INVOKABLE bool makeMove(int index);
    Q_INVOKABLE bool makeComputerMove();
    Q_INVOKABLE bool undo();
    Q_INVOKABLE void restartGame();
    Q_INVOKABLE bool canUndo();
    Q_INVOKABLE void clearUndoStack();
    Q_INVOKABLE bool isInitialPosition();
    Q_INVOKABLE bool isOneMoved();

    Q_INVOKABLE void changeColor(int index); //setup position mode
    Q_INVOKABLE void setFirstMove(int color); //setup position mode

    int getWhiteCount() const {return playerScore(Defs::White);}
    int getBlackCount() const {return playerScore(Defs::Black);}

    bool getIsWhiteHuman() const {return m_isWhiteHuman;}
    bool getIsBlackHuman() const {return m_isBlackHuman;}

    void setIsWhiteHuman(bool isHuman) {
        if (isHuman != m_isWhiteHuman) {
            m_isWhiteHuman = isHuman;
            emit whiteHumanChanged();
        }
    }

    void setIsBlackHuman(bool isHuman) {
        if (isHuman != m_isBlackHuman) {
            m_isBlackHuman = isHuman;
            emit blackHumanChanged();
        }
    }

    int getWhiteSkill() const {return m_whiteSkill;}
    void setWhiteSkill(int skill) {
        if (m_whiteSkill != skill) {
            m_whiteSkill = skill;
            emit whiteSkillChanged();
        }
    }

    int getBlackSkill() const {return m_blackSkill;}
    void setBlackSkill(int skill) {
        if (m_blackSkill != skill) {
            m_blackSkill = skill;
            emit blackSkillChanged();
        }
    }

    bool getUndoing() const {return m_undoing;}
    void setUndoing(bool undoing) {
        if (undoing != m_undoing) {
            m_undoing = undoing;
            emit undoingChanged();
        }
    }

    bool getSetupMode() const {return m_setupMode;}
    void setSetupMode(bool setupMode) {
        if (setupMode != m_setupMode) {
            m_setupMode = setupMode;
            emit setupModeChanged();
        }
    }


    int getCurPlayer() const {return m_curPlayer;}

    void setCurPlayer(int curPlayer) {
        if ((Defs::ChipColor)curPlayer != m_curPlayer) {
            m_curPlayer = (Defs::ChipColor)curPlayer;
            emit curPlayerChanged();
        }
    }



    /**
     *  @return whether the game is already over
     */
    Q_INVOKABLE bool isGameOver() const;

    Q_INVOKABLE bool isAnyMovePossible(int color) const;

    Q_INVOKABLE int opponentColor(int color) const {return opponentColorFor((Defs::ChipColor)color);}

    Q_INVOKABLE bool isComputerThinking() const {return m_thinkingInProgress;}
    Q_INVOKABLE void interrupt();
signals:
    void computerMoved(int index);
    void whiteCountChanged();
    void blackCountChanged();
    void whiteSkillChanged();
    void blackSkillChanged();
    void whiteHumanChanged();
    void blackHumanChanged();
    void undoingChanged();
    void setupModeChanged();
    void curPlayerChanged();

private:
    enum Direction { Up, Down, Right, Left, UpLeft, UpRight, DownLeft, DownRight };
    /**
     *  Searches for "chunk" in direction dir for move.
     *  As my English-skills are somewhat limited, let me introduce
     *  new terminology ;).
     *  I'll define a "chunk" of chips for color "C" as follows:
     *  (let "O" be the color of the opponent for color "C")
     *  CO[O]C <-- this is a chunk
     *  where [O] is one or more opponent's pieces
     */
    bool hasChunk( Direction dir, const KReversiPos& move) const;
    /**
     *  Performs move, i.e. marks all the chips that player wins with
     *  this move with current player color
     */
    void makeMove( const KReversiPos& move );
    /**
     *  Requests a move from the game server
     */
    void makeNetworkMove( int row, int col );
    /**
     *  Sets the type of chip at (row,col)
     */
    void setChipColor(Defs::ChipColor type, int row, int col);

private:
    Engine *m_engine;
    /**
     *  The board itself
     */
    Defs::ChipColor m_cells[8][8];

    /**
     *  Score of each player
     */
    int m_score[2];
    /**
     *  Color of the current player
     */
    Defs::ChipColor m_curPlayer;
    /**
     *  The color of the human played chips
     */
//    Defs::ChipColor m_playerColor;
    /**
     *  The color of the computer played chips
     */
//    Defs::ChipColor m_computerColor;

    /**
     *  This list holds chips that were changed/added during last move
     *  First of them will be the chip added to the board by the player
     *  during last move. The rest of them - chips that were turned by that
     *  move.
     */
    PosList m_changedChips;
    /**
     *  This is an undo stack.
     *  It contains a lists of chips changed with each turn.
     *  @see m_changedChips
     */
    QStack<PosList> m_undoStack;

    bool m_isWhiteHuman;
    bool m_isBlackHuman;
    BoardModel* m_model;
    QDeclarativeContext *m_context;
    bool m_undoing;
    bool m_setupMode;
    int m_whiteSkill;
    int m_blackSkill;
    bool m_thinkingInProgress;
};

#endif //REVERSI_GAME_ENGINE_H
