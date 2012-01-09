TEMPLATE = app
TARGET = Reversi
# Add more folders to ship with the application, here
#folder_01.source = qml/reversi
#folder_01.target = qml

#DEPLOYMENTFOLDERS = folder_01
DEPLOYMENTFOLDERS =

symbian:TARGET.UID3 = 0x2004b2fb #for development 0xA89FDCEC

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
#symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

QML_IMPORT_PATH =

symbian {
    #0xA89FDCEC for development
    packageheader = "$${LITERAL_HASH}{\"Reversi\"},(0x2004b2fb),1,0,0"
    default_deployment.pkg_prerules += packageheader

    DEPLOYMENT.installer_header = 0x2002CCCF #for development 0xA000D7CE

    my_deployment.pkg_prerules += vendorinfo

    DEPLOYMENT += my_deployment

    vendorinfo += "%{\"Michael.Nosov@gmail.com\"}" ":\"Michael.Nosov@gmail.com\""
} else {
    # Speed up launching on MeeGo/Harmattan when using applauncherd daemon
#    CONFIG += qdeclarative-boostable
unix {
    splashscreen.path = /opt/$${TARGET}/images
    splashscreen.files += ./resources_meego/splash_portrait.png
    splashscreen.files += ./resources_meego/splash_landscape.png

    #MAKE INSTALL
    INSTALLS += splashscreen
}
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
    qml/UIConstants_meego.js \
    qml/Chip.qml \
    qml/MainScreenItem.qml \
    qml/mainMeeGo.qml \
    qml/Dialog.qml \
    qml/SelectionDialog.qml \
    qml/Button.qml \
    qml/PlayerInfoArea.qml \
    qml/InfoBanner.qml \
    qml/CheckBox.qml \
    qml/WinScreen.qml \
    qml/AboutScreen.qml \
    qml/AboutSection.qml \
    qml/AboutSectionText.qml \
    qml/SectionTextContent.qml

RESOURCES += reversi.qrc
RESOURCES += reversi_lang.qrc

unix:!symbian {
    RESOURCES += reversi_meego.qrc
} else {
    RESOURCES += reversi_symbian.qrc
}

TRANSLATIONS += i18n/reversi_ru.ts
TRANSLATIONS += i18n/reversi.ts

system(lrelease $$TRANSLATIONS)


# Add dependency to Symbian components
# CONFIG += qt-components

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

