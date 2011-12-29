TEMPLATE = app
TARGET = Reversi

# Add more folders to ship with the application, here
# folder_01.source = qml/reversi
# folder_01.target = qml
# DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model

symbian:TARGET.UID3 = 0xA89FDCEC

# Allow network access on Symbian
# symbian:TARGET.CAPABILITY += NetworkServices

# Define QMLJSDEBUGGER to allow debugging of QML in debug builds
# (This might significantly increase build time)
# DEFINES += QMLJSDEBUGGER

# If your application uses the Qt Mobility libraries, uncomment
# the following lines and add the respective components to the 
# MOBILITY variable. 
# CONFIG += mobility
# MOBILITY +=

symbian {
    #UID should be requested by Publisher from OVI
    packageheader = "$${LITERAL_HASH}{\"Reversi\"},(0xA89FDCEC),1,0,0"
    default_deployment.pkg_prerules += packageheader

    DEPLOYMENT.installer_header = 0xA000D7CE
} else {
}

INCLUDEPATH += .

SOURCES += main.cpp \
           gameengine.cpp \
           Engine.cpp \
    boardmodel.cpp

HEADERS += commondefs.h \
           gameengine.h \
           Engine.h \
    boardmodel.h

OTHER_FILES += \
    i18n/reversi.ts \
    i18n/reversi_ru.ts \
    qml/UIConstants.js \
    qml/Chip.qml \
    qml/main.qml \
    qml/Dialog.qml \
    qml/SelectionDialog.qml \
    qml/Button.qml \
    qml/PlayerInfoArea.qml \
    qml/InfoBanner.qml

RESOURCES += reversi.qrc
RESOURCES += reversi_lang.qrc

DEPLOYMENTFOLDERS =

TRANSLATIONS += i18n/reversi_ru.ts
TRANSLATIONS += i18n/reversi.ts

system(lrelease $$TRANSLATIONS)

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()







