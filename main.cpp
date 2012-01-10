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
#include <QDebug>
#include <QDeclarativeEngine>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include "gameengine.h"
#if defined(Q_OS_UNIX) && !defined(MEEGO_SIMULATOR_BUILD) && !defined(Q_OS_SYMBIAN)
#include <MDeclarativeCache>
#endif

Q_DECL_EXPORT int main(int argc, char *argv[])
{
#if !defined(Q_OS_UNIX) || defined (Q_OS_SYMBIAN)
    qDebug() << "Build for Symbian";
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

    viewer.setSource(QUrl("qrc:qml/MainScreenItem.qml"));


    viewer.showExpanded();

    return app.exec();
#else
    qDebug() << "Build for MeeGo";
    QScopedPointer<QApplication> app(createApplication(argc, argv));
#ifdef MEEGO_SIMULATOR_BUILD
    QScopedPointer<QmlApplicationViewer> viewer(QmlApplicationViewer::create());
    viewer->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
#else
    QDeclarativeView *viewer = MDeclarativeCache::qDeclarativeView();
#endif

    QTranslator trans;
    trans.load(":/i18n/reversi");
    app->installTranslator(&trans);

    QDeclarativeContext *ctxt = viewer->rootContext();
    if (!ctxt)
    {
        return 0;
    }

    GameEngine gameEng (ctxt);

    qmlRegisterUncreatableType<GameEngine>("Reversi", 1, 0, "GameEngine", "should not be created there");
    qmlRegisterUncreatableType<Defs>("Reversi", 1, 0, "Defs", "should not be created there");

    ctxt->setContextProperty("gameEngine", &gameEng);

    qDebug() << "Context property gameEngine is set";
    viewer->setSource(QUrl("qrc:qml/mainMeeGo.qml"));
    //viewer->setMainQmlFile(QLatin1String("qml/reversi/mainMeeGo.qml"));

#ifdef MEEGO_SIMULATOR_BUILD
    viewer->showExpanded();
#else
    viewer->showFullScreen();
#endif
    return app->exec();
#endif
}
