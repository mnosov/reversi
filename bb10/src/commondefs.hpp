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

#ifndef COMMONDEFS_H
#define COMMONDEFS_H

#include <QList>
#include <QObject>

// noColor = empty

class Defs: public QObject {
    Q_OBJECT
    Q_ENUMS(ChipColor)
public:
    enum ChipColor { White = 0, Black = 1, NoColor = 2 };
public:
    explicit Defs(QObject* parent = 0) {}
};

struct KReversiPos
{
    KReversiPos( Defs::ChipColor col = Defs::NoColor, int r = -1, int c = -1 )
        : color(col), row(r), col(c) { }
    Defs::ChipColor color;
    int row;
    int col;

    bool isValid() const { return ( color != Defs::NoColor || row != -1 || col != -1 ); }
};

typedef QList<KReversiPos> PosList;

#endif
