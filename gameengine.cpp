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

#include "gameengine.h"
#include "boardmodel.h"

#include <QDebug>
#include <QDeclarativeContext>

GameEngine::GameEngine(QDeclarativeContext *context, QObject* parent):
    QObject(parent),
    m_curPlayer(Defs::Black),
//  m_playerColor(Black), m_computerColor( White ),
    m_isWhiteHuman (true),
    m_isBlackHuman (false),
    m_model(0),
    m_context(context),
    m_setupMode(false),
    m_whiteSkill(1),
    m_blackSkill(1)
{

    restartGame();

    m_engine = new Engine(1);

    m_model = new BoardModel(*this);

    m_context->setContextProperty("gameModel", m_model);
}

GameEngine::~GameEngine()
{
    delete m_model;
    delete m_engine;
}

void GameEngine::restartGame()
{
    if (getSetupMode()) {
        return;
    }
    setCurPlayer(Defs::White);

    clearUndoStack();
    // reset board
    int r=0;
    int c=0;
    for(r=0; r<8; ++r)
        for(c=0; c<8; ++c)
            m_cells[r][c] = Defs::NoColor;
    // initial pos
    m_cells[3][3] = m_cells[4][4] = Defs::White;
    m_cells[3][4] = m_cells[4][3] = Defs::Black;


//    m_cells[5][5] = m_cells[0][0] = Defs::Black;
//    m_cells[5][6] = m_cells[0][1] = m_cells[0][2] = m_cells[0][4] = m_cells[0][6] = m_cells[1][0] = m_cells[5][4] = Defs::White;


    m_score[Defs::White] = 0;
    m_score[Defs::Black] = 0;
    for(r=0; r<8; ++r)
        for(c=0; c<8; ++c)
        {
            if (m_cells[r][c] == Defs::White) {
                m_score[Defs::White]++;
            } else if (m_cells[r][c] == Defs::Black) {
                m_score[Defs::Black]++;
            }
        }

    emit whiteCountChanged();
    emit blackCountChanged();
    if (m_model) {
        m_model->clearToInitial();
    }
//    m_score[White] = m_score[Black] = 2;
}

int GameEngine::playerScore( Defs::ChipColor player ) const
{
    return m_score[player];
}

Defs::ChipColor GameEngine::chipColorAt( int row, int col ) const
{
    Q_ASSERT( row < 8 && col < 8 );
    return m_cells[row][col];
}

void GameEngine::changeColor(int index)
{
    if (!getSetupMode()) {
        return;
    }
    int row = index / 8;
    int col = index % 8;
    if (chipColorAt(row, col) == Defs::NoColor) {
        m_score[Defs::White]++;
        m_cells[row][col] = Defs::White;
    } else if (chipColorAt(row, col) == Defs::White) {
        m_score[Defs::White]--;
        m_score[Defs::Black]++;
        m_cells[row][col] = Defs::Black;
    } else {
        m_score[Defs::Black]--;
        m_cells[row][col] = Defs::NoColor;
    }
    m_model->updateItem(index);
    emit whiteCountChanged();
    emit blackCountChanged();
}

void GameEngine::setFirstMove(int color)
{
    if (!getSetupMode()) {
        return;
    }
    m_curPlayer = (Defs::ChipColor) color;
}


bool GameEngine::makeMove(int index)
{
    if (getSetupMode()) {
        return false;
    }
    KReversiPos move;
    int row = index / 8;
    int col = index % 8;
    move = KReversiPos(m_curPlayer, row, col );
    if( !isMovePossible(move) )
    {
        qDebug() << "No move possible";
        return false;
    }
    makeMove( move );
    m_undoStack.push( m_changedChips );
    return true;
}

bool GameEngine::makeComputerMove()
{
    if (getSetupMode()) {
        return false;
    }
    if (!isAnyMovePossible(m_curPlayer)) {
        return false;
    }
//    m_curPlayer = m_computerColor;
    if (m_curPlayer == Defs::White) {
        m_engine->setStrength(m_whiteSkill);
    } else {
        m_engine->setStrength(m_blackSkill);
    }
    KReversiPos move = m_engine->computeMove( *this, true );
    if( !move.isValid() )
        return false;

    if( (m_curPlayer == Defs::White && m_isWhiteHuman) ||
            (m_curPlayer == Defs::Black && m_isBlackHuman))
    {
        qDebug() << "Strange! makeComputerMove() just got not computer move!";
        return true;
    }

    makeMove(move);
    m_undoStack.push( m_changedChips );
    emit computerMoved (move.row*8+move.col);
    return true;
}

bool GameEngine::canUndo()
{
    return !m_undoStack.isEmpty();
}

void GameEngine::clearUndoStack()
{
    m_undoStack.clear();
}


bool GameEngine::undo()
{
    bool res = false;

    qDebug() << "Undo";
    if (getSetupMode()) {
        return false;
    }
    PosList revertedCells;
    if ( !m_undoStack.isEmpty() )
    {
        PosList lastUndo = m_undoStack.pop();

        KReversiPos move = lastUndo.takeFirst();
        setChipColor( Defs::NoColor, move.row, move.col );
        revertedCells.append(move);

        // and change back the color of the rest chips
        foreach( const KReversiPos &pos, lastUndo )
        {
            Defs::ChipColor opponentColor = opponentColorFor( m_cells[pos.row][pos.col] );
            setChipColor( opponentColor, pos.row, pos.col );
            revertedCells.append(pos);
        }

        lastUndo.clear();

        if ((move.color == Defs::White && m_isWhiteHuman ) ||
                (move.color == Defs::Black && m_isBlackHuman )) {
            setCurPlayer(move.color);
        } else if (m_isBlackHuman || m_isWhiteHuman){
            res = true;
        } else {
            setCurPlayer(move.color);
        }

        emit whiteCountChanged();
        emit blackCountChanged();

        m_model->updateAfterMove(revertedCells);
    }

    return res;
}

bool GameEngine::isGameOver() const
{
    // trivial fast-check
    if( m_score[Defs::White] + m_score[Defs::Black] == 64 )
        return true; // the board is full
    else
        return !(isAnyMovePossible(Defs::White) || isAnyMovePossible(Defs::Black));
}

bool GameEngine::isAnyMovePossible(int color) const
{
    for( int r=0; r<8; ++r )
        for( int c=0; c<8; ++c )
        {
            if( m_cells[r][c] == Defs::NoColor )
            {
                // let's see if we can put chip here
                if( isMovePossible( KReversiPos((Defs::ChipColor)color, r, c ) ) )
                        return true;
            }
        }
    return false;
}

void GameEngine::makeMove( const KReversiPos& move )
{
    m_changedChips.clear();

    setChipColor( move.color, move.row, move.col );
    // the first one is the move itself
    m_changedChips.append( move );
    // now turn color of all chips that were won
    if( hasChunk( Up, move ) )
    {
        for(int r=move.row-1; r >= 0; --r)
        {
            if( m_cells[r][move.col] == move.color )
                break;
            setChipColor( move.color, r, move.col );
            m_changedChips.append( KReversiPos( move.color, r, move.col ) );
        }
    }
    if( hasChunk( Down, move ) )
    {
        for(int r=move.row+1; r < 8; ++r)
        {
            if( m_cells[r][move.col] == move.color )
                break;
            setChipColor( move.color, r, move.col );
            m_changedChips.append( KReversiPos( move.color, r, move.col ) );
        }
    }
    if( hasChunk( Left, move ) )
    {
        for(int c=move.col-1; c >= 0; --c)
        {
            if( m_cells[move.row][c] == move.color )
                break;
            setChipColor( move.color, move.row, c );
            m_changedChips.append( KReversiPos( move.color, move.row, c ) );
        }
    }
    if( hasChunk( Right, move ) )
    {
        for(int c=move.col+1; c < 8; ++c)
        {
            if( m_cells[move.row][c] == move.color )
                break;
            setChipColor( move.color, move.row, c );
            m_changedChips.append( KReversiPos( move.color, move.row, c ) );
        }
    }
    if( hasChunk( UpLeft, move ) )
    {
        for(int r=move.row-1, c=move.col-1; r>=0 && c >= 0; --r, --c)
        {
            if( m_cells[r][c] == move.color )
                break;
            setChipColor( move.color, r, c );
            m_changedChips.append( KReversiPos( move.color, r, c ) );
        }
    }
    if( hasChunk( UpRight, move ) )
    {
        for(int r=move.row-1, c=move.col+1; r>=0 && c < 8; --r, ++c)
        {
            if( m_cells[r][c] == move.color )
                break;
            setChipColor( move.color, r, c );
            m_changedChips.append( KReversiPos( move.color, r, c ) );
        }
    }
    if( hasChunk( DownLeft, move ) )
    {
        for(int r=move.row+1, c=move.col-1; r < 8 && c >= 0; ++r, --c)
        {
            if( m_cells[r][c] == move.color )
                break;
            setChipColor( move.color, r, c );
            m_changedChips.append( KReversiPos( move.color, r, c ) );
        }
    }
    if( hasChunk( DownRight, move ) )
    {
        for(int r=move.row+1, c=move.col+1; r < 8 && c < 8; ++r, ++c)
        {
            if( m_cells[r][c] == move.color )
                break;
            setChipColor( move.color, r, c );
            m_changedChips.append( KReversiPos( move.color, r, c ) );
        }
    }

    setCurPlayer(opponentColor(m_curPlayer));

    emit whiteCountChanged();
    emit blackCountChanged();
    m_model->updateAfterMove(m_changedChips);
    //qDebug() << "Current player changed to" << (m_curPlayer == White ? "White" : "Black" );
    // emit moveFinished();
}

bool GameEngine::isMovePossible( const KReversiPos& move ) const
{
    // first - the trivial case:
    if( m_cells[move.row][move.col] != Defs::NoColor || move.color == Defs::NoColor )
        return false;

    if( hasChunk( Up, move ) || hasChunk( Down, move )
            || hasChunk( Left, move ) || hasChunk( Right, move )
            || hasChunk( UpLeft, move ) || hasChunk( UpRight, move )
            || hasChunk( DownLeft, move ) || hasChunk( DownRight, move ) )
    {
        return true;
    }

    return false;
}

bool GameEngine::hasChunk( Direction dir, const KReversiPos& move ) const
{
    // On each step (as we proceed) we must ensure that current chip is of the
    // opponent color.
    // We'll do our steps until we reach the chip of player color or we reach
    // the end of the board in this direction.
    // If we found player-colored chip and number of opponent chips between it and
    // the starting one is greater than zero, then Hurray! we found a chunk
    //
    // Well, I wrote this description from my head, now lets produce some code for that ;)

    Defs::ChipColor opColor = opponentColorFor(move.color);
    int opponentChipsNum = 0;
    bool foundPlayerColor = false;
    if( dir == Up )
    {
        for( int row=move.row-1; row >= 0; --row )
        {
            Defs::ChipColor color = m_cells[row][move.col];
            if( color == opColor )
            {
                opponentChipsNum++;
            }
            else if(color == move.color)
            {
                foundPlayerColor = true;
                break; //bail out
            }
            else // NoColor
                break; // no luck in this direction
        }

        if(foundPlayerColor && opponentChipsNum != 0)
            return true;
    }
    else if( dir == Down )
    {
        for( int row=move.row+1; row < 8; ++row )
        {
            Defs::ChipColor color = m_cells[row][move.col];
            if( color == opColor )
            {
                opponentChipsNum++;
            }
            else if(color == move.color)
            {
                foundPlayerColor = true;
                break; //bail out
            }
            else // NoColor
                break; // no luck in this direction
        }

        if(foundPlayerColor && opponentChipsNum != 0)
            return true;
    }
    else if( dir == Left )
    {
        for( int col=move.col-1; col >= 0; --col )
        {
            Defs::ChipColor color = m_cells[move.row][col];
            if( color == opColor )
            {
                opponentChipsNum++;
            }
            else if(color == move.color)
            {
                foundPlayerColor = true;
                break; //bail out
            }
            else // NoColor
                break; // no luck in this direction
        }

        if(foundPlayerColor && opponentChipsNum != 0)
            return true;
    }
    else if( dir == Right )
    {
        for( int col=move.col+1; col < 8; ++col )
        {
            Defs::ChipColor color = m_cells[move.row][col];
            if( color == opColor )
            {
                opponentChipsNum++;
            }
            else if(color == move.color)
            {
                foundPlayerColor = true;
                break; //bail out
            }
            else // NoColor
                break; // no luck in this direction
        }

        if(foundPlayerColor && opponentChipsNum != 0)
            return true;
    }
    else if( dir == UpLeft )
    {
        for( int row=move.row-1, col=move.col-1; row >= 0 && col >= 0; --row, --col )
        {
            Defs::ChipColor color = m_cells[row][col];
            if( color == opColor )
            {
                opponentChipsNum++;
            }
            else if(color == move.color)
            {
                foundPlayerColor = true;
                break; //bail out
            }
            else // NoColor
                break; // no luck in this direction
        }

        if(foundPlayerColor && opponentChipsNum != 0)
            return true;
    }
    else if( dir == UpRight )
    {
        for( int row=move.row-1, col=move.col+1; row >= 0 && col < 8; --row, ++col )
        {
            Defs::ChipColor color = m_cells[row][col];
            if( color == opColor )
            {
                opponentChipsNum++;
            }
            else if(color == move.color)
            {
                foundPlayerColor = true;
                break; //bail out
            }
            else // NoColor
                break; // no luck in this direction
        }

        if(foundPlayerColor && opponentChipsNum != 0)
            return true;
    }
    else if( dir == DownLeft )
    {
        for( int row=move.row+1, col=move.col-1; row < 8 && col >= 0; ++row, --col )
        {
            Defs::ChipColor color = m_cells[row][col];
            if( color == opColor )
            {
                opponentChipsNum++;
            }
            else if(color == move.color)
            {
                foundPlayerColor = true;
                break; //bail out
            }
            else // NoColor
                break; // no luck in this direction
        }

        if(foundPlayerColor && opponentChipsNum != 0)
            return true;
    }
    else if( dir == DownRight )
    {
        for( int row=move.row+1, col=move.col+1; row < 8 && col < 8; ++row, ++col )
        {
            Defs::ChipColor color = m_cells[row][col];
            if( color == opColor )
            {
                opponentChipsNum++;
            }
            else if(color == move.color)
            {
                foundPlayerColor = true;
                break; //bail out
            }
            else // NoColor
                break; // no luck in this direction
        }

        if(foundPlayerColor && opponentChipsNum != 0)
            return true;
    }

    return false;
}

void GameEngine::setChipColor(Defs::ChipColor color, int row, int col)
{
    Q_ASSERT( row < 8 && col < 8 );
    // first: if the current cell already contains a chip of the opponent,
    // we'll decrease opponents score
    if( m_cells[row][col] != Defs::NoColor && color != Defs::NoColor && m_cells[row][col] != color )
        m_score[opponentColorFor(color)]--;
    // if the cell contains some chip and is being replaced by NoColor,
    // we'll decrease the score of that color
    // Such replacements (with NoColor) occur during undoing
    if( m_cells[row][col] != Defs::NoColor && color == Defs::NoColor )
        m_score[ m_cells[row][col] ]--;

    // and now replacing with chip of 'color'
    m_cells[row][col] = color;

    if( color != Defs::NoColor )
        m_score[color]++;

    //qDebug() << "Score of White player:" << m_score[White];
    //qDebug() << "Score of Black player:" << m_score[Black];
}

