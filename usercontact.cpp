#include "usercontact.h"
#include "QJniObject"
#include "QVariantList"
#include "QGuiApplication"
#include <QtCore/private/qandroidextras_p.h>

UserContact::UserContact(QObject *parent)
    : QObject{parent}
{

}

void UserContact::contactData(QString info)
{

    QJniObject infoString = QJniObject::fromString(info).object<jstring>();
        QJniObject className = QNativeInterface::QAndroidApplication::context();
//    auto activity = QJniObject(QNativeInterface::QAndroidApplication::context());
    //    QJniObject className = QJniObject("com.listviewqml.contact/MainActivity");
    QJniObject res = className.callObjectMethod("readContactDetails", "(Ljava/lang/String;)Ljava/lang/String;", infoString.object());
    qDebug() << res.toString();
}
