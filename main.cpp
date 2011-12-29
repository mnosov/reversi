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

#include <QtGui/QApplication>
#include <QTranslator>
#include <QUrl>
#include <QDeclarativeEngine>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include "gameengine.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QTranslator trans;
    trans.load(":/i18n/reversi");
    app.installTranslator(&trans);

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);

    QDeclarativeContext *ctxt = viewer.rootContext();
    if (!ctxt)
    {
        return 0;
    }

    GameEngine gameEng (ctxt);

    qmlRegisterUncreatableType<GameEngine>("Reversi", 1, 0, "GameEngine", "should not be created there");
    qmlRegisterUncreatableType<Defs>("Reversi", 1, 0, "Defs", "should not be created there");

    ctxt->setContextProperty("gameEngine", &gameEng);

    viewer.setSource(QUrl("qrc:qml/main.qml"));


    viewer.showExpanded();

    return app.exec();
}
