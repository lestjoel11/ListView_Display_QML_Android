#ifndef USERDETAIL_H
#define USERDETAIL_H

#include "qjsonarray.h"
#include <QAbstractListModel>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QVariantMap>
#include <QSqlQuery>
#include <QList>

class userdetail : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QJsonArray jsonData READ getJsonData WRITE setJsonData RESET resetJsonData NOTIFY jsonDataChanged)

    Q_PROPERTY(QList<QVariantMap> datas READ datas WRITE setDatas NOTIFY datasChanged)

    Q_PROPERTY(int startPosition READ getStartPosition WRITE setStartPosition NOTIFY startPositionChanged)

    Q_PROPERTY(int endPosition READ getEndPosition WRITE setEndPosition NOTIFY endPositionChanged)

public:
    QList <QVariantMap> m_datas;
    explicit userdetail(QObject *parent = nullptr);

    enum Roles {
        IdRole = Qt::UserRole,
        BalanceRole,
        AgeRole,
        NameRole,
        GenderRole,
        EmailRole,
        PhoneRole
    };

    // Basic functionality:

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    QJsonArray getJsonData() const;
    void setJsonData(const QJsonArray &newJsonData);
    void resetJsonData();

    bool getVerifyDataLength() const;
    void setVerifyDataLength(bool newVerifyDataLength);

    int getServerItemCountVal() const;
    void setServerItemCountVal(int newServerItemCountVal);

    QList<QVariantMap> datas() const;
    void setDatas(const QList<QVariantMap> &newDatas);

    int getStartPosition() const;
    void setStartPosition(int newStartPosition);

    int getEndPosition() const;
    void setEndPosition(int newEndPosition);

public slots:
    void increaseRows();
    void dbOperations();

signals:
    void jsonDataChanged();

    void verifyDataLengthChanged();

    void serverCountReply();

    void datasChanged();

    void startPositionChanged();

    void endPositionChanged();

    void canReadFromDB();

private:
    QList<QString> columns = {"id", "name", "balance", "age", "gender", "email", "phone"};
    int startPosition;
    int endPosition;
    QJsonArray jsonData;
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    int serverItemCountVal;
    QNetworkAccessManager *manager;
    QSqlQuery query;

private slots:
    void serverReply(QNetworkReply *reply);
    void serverItemCount(QNetworkReply *reply);
    void sendReq(QNetworkAccessManager *manager, QString requestType);
    void insertIntoDB();
    void readFromDB();
};

#endif // USERDETAIL_H
