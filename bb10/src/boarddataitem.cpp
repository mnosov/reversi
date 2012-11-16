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

#include "boarddataitem.hpp"
#include "Engine.h"

BoardDataItem::BoardDataItem(const GameInterface& game, int row, int column, QObject *parent) :
    QObject(parent),
    m_game(game),
    m_row(row),
    m_column(column)
{
}

BoardDataItem::~BoardDataItem()
{
}

void BoardDataItem::update()
{
	emit dataChanged();
}

int BoardDataItem::dataColor() const
{
	return (int) m_game.chipColorAt(m_row, m_column);
}

bool BoardDataItem::canMoveCurrent() const
{
	return m_game.isMovePossible(KReversiPos(m_game.currentPlayer(), m_row, m_column));
}
