#include "usercontact.h"
#include "QJniObject"
#include "QVariantList"

UserContact::UserContact(QObject *parent)
    : QObject{parent}
{

}

void UserContact::contactData(QString info)
{

//    QJniObject infoString = QJniObject::fromString(info).object<jstring>();
//    QJniObject mainActivity = QJniObject("com.example.listviewdisplayqml/MainActivity");
//    QJniObject res = mainActivity.callObjectMethod("readContactDetails", "(Ljava/lang/String;)Ljava/lang/String;", infoString.object());
//    qDebug() << res.toString();
}
