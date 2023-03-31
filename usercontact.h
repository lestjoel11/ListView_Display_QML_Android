#ifndef USERCONTACT_H
#define USERCONTACT_H

#include <QObject>
#include <QVariantList>

class UserContact : public QObject
{
    Q_OBJECT
public:
    explicit UserContact(QObject *parent = nullptr);

public slots:
    void contactData(QString info);

signals:


};

#endif // USERCONTACT_H
