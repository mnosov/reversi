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

#include "boardmodel.hpp"
#include "boarddataitem.hpp"
#include "Engine.h"

BoardModel::BoardModel(const GameInterface& game, QObject *parent) :
    BModel(),
    m_game(game)
{
	setParent(parent);
    /*QHash<int, QByteArray> roles;
    roles[ERoleIsBlack] = "isBlack";
    roles[ERoleIsWhite] = "isWhite";
    roles[ERoleCanMoveCurrentPlayer] = "canMoveCurrent";
    setRoleNames(roles);*/
	for (int i = 0; i < 8; i++) {
		for (int j = 0; j < 8; j++) {
			BoardDataItem* item = new BoardDataItem(m_game, i, j, parent);
			append(item);
		}
	}
}

BoardModel::~BoardModel()
{
}

void BoardModel::updateAll()
{
	for (int i = 0; i < size(); i++) {
		BoardDataItem* item = qobject_cast<BoardDataItem*>(value(i));
		item->update();
	}
}

void BoardModel::updateAfterMove(const PosList& updatedFields)
{
    Q_UNUSED(updatedFields); //TODO
    //emit dataChanged(index(0, 0), index(8*8-1, 0));
    updateAll();
}

void BoardModel::updateMovePossibity()
{
	//todo
    //emit dataChanged(index(0, 0), index(8*8-1, 0));
	updateAll();
}

void BoardModel::clearToInitial()
{
	//TODO
    //emit dataChanged(index(0, 0), index(8*8-1, 0));
	updateAll();
}

void BoardModel::updateItem(int itemIndex)
{
	//TODO
    //emit dataChanged(index(itemIndex, 0), index(itemIndex, 0));
	updateAll();
}

/*QVariant BoardModel::data(const QModelIndex &index, int role) const
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
*/
