//-- Default empty project template
#include "app.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include "gameengine.hpp"


using namespace bb::cascades;

App::App()
{
    QmlDocument *qml = QmlDocument::create("asset:///main.qml");
    //-- setContextProperty expose C++ object in QML as an variable
    //-- uncomment next line to introduce 'this' object to QML name space as an 'app' variable
    //qml->setContextProperty("app", this);
    GameEngine* gameEngine = new GameEngine(qml, this);
    Application::instance()->installEventFilter(gameEngine);
    qml->setContextProperty("gameEngine", gameEngine);
    
    AbstractPane *root = qml->createRootObject<AbstractPane>();
    Application::instance()->setScene(root);
}
