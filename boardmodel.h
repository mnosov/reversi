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
#ifndef BOARDMODEL_H
#define BOARDMODEL_H

#include <QAbstractListModel>
#include <QString>
#include "commondefs.h"

class GameInterface;

class BoardModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit BoardModel(const GameInterface& game, QObject *parent = 0);

    enum ItemRoles {
        ERoleIsBlack = Qt::UserRole + 1,
        ERoleIsWhite,
        ERoleCanMoveCurrentPlayer
    };

public:
    Q_INVOKABLE void updateMovePossibity();
    void updateAfterMove(const PosList& updatedFields);
    void clearToInitial();
    void updateItem(int itemIndex);

    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const;
    virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;

signals:

public slots:

private:
    const GameInterface& m_game;

};

#endif // BOARDMODEL_H
