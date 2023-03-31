#include "userdetail.h"
#include <QJsonArray>
#include <QJsonObject>
#include "QSqlDatabase"
#include "QSqlError"
#include "QSqlQuery"
#include "QSqlRecord"
#include "QSqlQueryModel"


userdetail::userdetail(QObject *parent)
    : QAbstractListModel(parent)
{


    setStartPosition(0); setEndPosition(19);
    manager = new QNetworkAccessManager(this);
    db.setDatabaseName("usersDB.db");

    //connect to db

    if (!db.open()) {
        qDebug() << "ERROR: " << db.lastError();
    }

    //get itemCount from server
    sendReq(manager, "itemCount");
    connect(manager, &QNetworkAccessManager::finished, this, &userdetail::serverItemCount);
    connect(this, &userdetail::serverCountReply, this, &userdetail::dbOperations, Qt::QueuedConnection);

    //    query.exec("DROP TABLE IF EXISTS users");

}
userdetail::~userdetail()
{
    db.close();
}
void userdetail::dbOperations()
{
    int dbRowCount = 0;
    query.prepare("SELECT COUNT(*) FROM users");
    if (query.exec() && query.next()) {
        dbRowCount = query.value(0).toInt();
        qDebug() << "DB Row count:" << dbRowCount;
        qDebug() << "Server rowcount" << serverItemCountVal;
    }
    //if they are not equal
    if(!(dbRowCount==serverItemCountVal)){
        //    get row count
        query.exec("CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY, name TEXT, balance TEXT, age INTEGER, email TEXT, gender TEXT, phone TEXT)");

        //load model details from db
        disconnect(manager, &QNetworkAccessManager::finished, this, &userdetail::serverItemCount);
        sendReq(manager,"");
        connect(manager, &QNetworkAccessManager::finished, this, &userdetail::serverReply);
        //connect to slot and once jsonArray has value insert into to DB
        connect(this,&userdetail::jsonDataChanged,this,&userdetail::insertIntoDB, Qt::QueuedConnection);
        connect(this,&userdetail::canReadFromDB,this,&userdetail::readFromDB, Qt::QueuedConnection);
    }else {
        readFromDB();
    }



}


int userdetail::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_datas.size();
}

QHash<int, QByteArray> userdetail::roleNames() const
{
    QHash<int, QByteArray> names;
    names[IdRole] = "id";
    names[BalanceRole] = "balance";
    names[AgeRole] = "age";
    names[NameRole] = "name";
    names[GenderRole] = "gender";
    names[EmailRole] = "email";
    names[PhoneRole] = "phone";

    return names;
}

QVariant userdetail::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QVariantMap currentRow = m_datas.at(index.row());
    switch(role){
    case IdRole:
        return QVariant((currentRow.value("id").toInt()+1));
    case BalanceRole:
        return QVariant(currentRow.value("balance").toString());
    case AgeRole:
        return QVariant(currentRow.value("age").toInt());
    case NameRole:
        return QVariant(currentRow.value("name").toString());
    case GenderRole:
        return QVariant(currentRow.value("gender").toString());
    case EmailRole:
        return QVariant(currentRow.value("email").toString());
    case PhoneRole:
        return QVariant(currentRow.value("phone").toString());
    }
    return QVariant();
}

bool userdetail::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (data(index, role) != value) {
        emit dataChanged(index, index, {role});
        return true;
    }
    return false;
}

QJsonArray userdetail::getJsonData() const
{
    return jsonData;
}

void userdetail::setJsonData(const QJsonArray &newJsonData)
{
    if (jsonData == newJsonData)
        return;
    jsonData = newJsonData;
    emit jsonDataChanged();
}

void userdetail::resetJsonData()
{
    setJsonData({}); // TODO: Adapt to use your actual default value
}

int userdetail::getServerItemCountVal() const
{
    return serverItemCountVal;
}

void userdetail::setServerItemCountVal(int newServerItemCountVal)
{
    serverItemCountVal = newServerItemCountVal;
    emit serverCountReply();
}

void userdetail::serverReply(QNetworkReply *reply)
{
    if(reply->error() == QNetworkReply::NoError){
        setJsonData(QJsonDocument::fromJson(reply->readAll()).array());
    }
}

void userdetail::serverItemCount(QNetworkReply *reply)
{
    if(reply->error() == QNetworkReply::NoError){
        setServerItemCountVal(QJsonDocument::fromJson(reply->readAll()).object().value("itemCount").toInt());
    } else {
        qDebug() << reply->error();
    }
}

void userdetail::sendReq(QNetworkAccessManager *manager, QString requestType="")
{
    QString url = requestType=="itemCount"?"http://192.168.0.135:4000/itemCount":"http://192.168.0.135:4000/";
    QNetworkRequest request((QUrl(url)));
    QNetworkReply *reply = manager->get(request);
}

void userdetail::insertIntoDB()
{
    db.transaction();
    query.prepare("INSERT INTO users (id, name, balance, age, gender, email, phone) "
                  "VALUES(?, ?, ?, ?, ?, ?, ?)");
    for(int i=0; i<jsonData.size();i++){
        query.addBindValue(jsonData.at(i).toObject().value("id").toInt());
        query.addBindValue(jsonData.at(i).toObject().value("name").toString());
        query.addBindValue(jsonData.at(i).toObject().value("balance").toString());
        query.addBindValue(jsonData.at(i).toObject().value("age").toInt());
        query.addBindValue(jsonData.at(i).toObject().value("gender").toString());
        query.addBindValue(jsonData.at(i).toObject().value("email").toString());
        query.addBindValue(jsonData.at(i).toObject().value("phone").toString());
        query.exec();
    }
    db.commit();
    int dbRowCount;
    query.prepare("SELECT COUNT(*) FROM users");
    if (query.exec() && query.next()) {
        dbRowCount = query.value(0).toInt();
        qDebug() << "DB Row count:" << dbRowCount;
    }
    qDebug() << "Inserted to DB";
    emit canReadFromDB();
}

void userdetail::readFromDB()
{
    QVariantMap row;
    query.prepare("SELECT * from users where id between ? and ?");
    query.addBindValue(startPosition);
    query.addBindValue(endPosition);
    query.exec();
    beginInsertRows(QModelIndex(), startPosition, endPosition-1);
    while (query.next()) {
        for (int i = 0; i<columns.size(); i++){
            row.insert(columns[i], query.value(columns.at(i)));
        }
        m_datas.append(row);
    }
    qDebug() << "Retrieved from DB";
    endInsertRows();
}

void userdetail::increaseRows()
{
    setStartPosition(getEndPosition());
    setEndPosition(getEndPosition()+20);
    readFromDB();
}

QList<QVariantMap> userdetail::datas() const
{
    return m_datas;
}

void userdetail::setDatas(const QList<QVariantMap> &newDatas)
{
    if (m_datas == newDatas)
        return;
    m_datas = newDatas;
    emit datasChanged();
}

int userdetail::getStartPosition() const
{
    return startPosition;
}

void userdetail::setStartPosition(int newStartPosition)
{
    if (startPosition == newStartPosition)
        return;
    startPosition = newStartPosition;
    emit startPositionChanged();
}

int userdetail::getEndPosition() const
{
    return endPosition;
}

void userdetail::setEndPosition(int newEndPosition)
{
    if (endPosition == newEndPosition)
        return;
    endPosition = newEndPosition;
    emit endPositionChanged();
}
