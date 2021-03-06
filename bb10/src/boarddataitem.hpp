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
#ifndef BOARD_DATA_ITEM_H
#define BOARD_DATA_ITEM_H

#include <QAbstractListModel>
#include <QString>
#include "commondefs.hpp"

#include <QObject>

class GameInterface;

class BoardDataItem: public QObject {
    Q_OBJECT
    Q_PROPERTY (int dataColor READ dataColor NOTIFY dataChanged)
    Q_PROPERTY (bool canMoveCurrent READ canMoveCurrent  NOTIFY dataChanged)
public:
    explicit BoardDataItem(const GameInterface& game, int row, int column, QObject *parent = 0);
    ~BoardDataItem();

public:
    void update();

    int dataColor() const;
    bool canMoveCurrent() const;

signals:
    void dataChanged();

private:
    const GameInterface& m_game;
    int m_row;
    int m_column;
};

#endif // BOARD_DATA_ITEM_H
