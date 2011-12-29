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

#include "boardmodel.h"
#include "Engine.h"

BoardModel::BoardModel(const GameInterface& game, QObject *parent) :
    QAbstractListModel(parent),
    m_game(game)
{
    QHash<int, QByteArray> roles;
    roles[ERoleIsBlack] = "isBlack";
    roles[ERoleIsWhite] = "isWhite";
    roles[ERoleCanMoveCurrentPlayer] = "canMoveCurrent";
    setRoleNames(roles);
}

void BoardModel::updateAfterMove(const PosList& updatedFields)
{
    Q_UNUSED(updatedFields);
    emit dataChanged(index(0, 0), index(8*8-1, 0));
/*    int ind = 0;
    foreach (const KReversiPos& pos, updatedFields) {
        if (pos.color != Defs::NoColor) {
            ind = pos.row * 8 + pos.col;
            emit dataChanged(index(ind, 0), index(ind, 0));
        }
    }*/
}

void BoardModel::updateMovePossibity()
{
    emit dataChanged(index(0, 0), index(8*8-1, 0));
}

void BoardModel::clearToInitial()
{
    emit dataChanged(index(0, 0), index(8*8-1, 0));
}

void BoardModel::updateItem(int itemIndex)
{
    emit dataChanged(index(itemIndex, 0), index(itemIndex, 0));
}

int BoardModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return 8*8;
}

QVariant BoardModel::data(const QModelIndex &index, int role) const
{
    int realIndex = index.row();
    int row = realIndex / 8;
    int col = realIndex % 8;
    if (realIndex < 0 || realIndex >= 8*8) {
        return QVariant();
    }

    switch (role) {
    case ERoleIsBlack:
        return m_game.chipColorAt(row, col) == Defs::Black;
    case ERoleIsWhite:
        return m_game.chipColorAt(row, col) == Defs::White;
    case ERoleCanMoveCurrentPlayer:
        return m_game.isMovePossible(KReversiPos(m_game.currentPlayer(), row, col));
    }

    return QVariant();
}
