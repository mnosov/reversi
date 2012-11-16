//-- Default empty project template
#include "app.hpp"

#include <bb/cascades/Application>

#include <QLocale>
#include <QTranslator>
#include <QDebug>
#include <QMutex>
#include <QFile>
#include <QTimer>
#include "gameengine.hpp"
#include "commondefs.hpp"

using ::bb::cascades::Application;

static QFile *file = 0;
static QMutex* logMutex = 0;
void myMessageOutputFile(QtMsgType type, const char *msg)
{
    if (!logMutex) {
        logMutex = new QMutex();
    }

    QMutexLocker locker (logMutex);
    Q_UNUSED(type);

    if (!file) {
        file = new QFile("/accounts/1000/shared/documents/reversi_log.txt");
        bool ok = file->open(QFile::WriteOnly);
        if (!ok) {
            delete file;
            file = 0;
        }
    }

    if (file) {
        file->write(msg);
        file->write("\r\n");
        file->flush();
    }
    printf("%s\r\n", msg);
    fflush(stdout);
}


int main(int argc, char **argv)
{
    //-- this is where the server is started etc
    Application app(argc, argv);
    // qInstallMsgHandler(myMessageOutputFile);
    //-- localization support
    QTranslator translator;
    QString locale_string = QLocale().name();
    QString filename = QString( "reversi_%1" ).arg( locale_string );
    if (translator.load(filename, "app/native/qm")) {
        app.installTranslator( &translator );
    }
    qmlRegisterType<QTimer>("Reversi",1,0,"Timer");
    qmlRegisterUncreatableType<GameEngine>("Reversi", 1, 0, "GameEngine", "should not be created there");
    qmlRegisterUncreatableType<Defs>("Reversi", 1, 0, "Defs", "should not be created there");

    App mainApp;
    
    //-- we complete the transaction started in the app constructor and start the client event loop here
    return Application::instance()->exec();
    //-- when loop is exited the Application deletes the scene which deletes all its children (per qt rules for children)
}
