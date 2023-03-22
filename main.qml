import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.LocalStorage as Sql

Window {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("User Details")

    property int start: 0
    property int end: 20

    property var db: null

    ListModel { id: listModel }
    Component.onCompleted: {
        openDB();
        createTable();
        loadData(start, end);
        loadModelData(start, end)
//        if (db) {
//                    db.transaction(
//                        function(tx) {
//                            tx.executeSql('DROP TABLE IF EXISTS users');
//                        }
//                    );
//                }

    }
    ListView {
        id: usersList
        anchors { fill: parent; margins: 20 }
        clip: true
        header: Text {
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Balance"
            font { pixelSize: 16; bold: true }
        }
        model: listModel
        delegate: listItem
        spacing: 2
    }
    Component {
        id: listItem
        Row {
            ExpansionPanel {
                name: model.id + ". " + model.name
                balance: model.balance
                age: "Age: " + model.age
                email: "Email: " + model.email
                gender: "Gender: " + model.gender
                phone: "Phone: " + model.phone
            }
            Component.onCompleted: {
                //loadModelData should come here
                if (index > ListView.view.count - 5) {
                    start = end
                    end += 20
                    loadData(start, end)
                    loadModelData(start,end)
                }
            }
        }
    }
    function loadData(start, end) {
        let xhr = new XMLHttpRequest()
        let url = "http://localhost:3000/" + start + "-" + end
        console.log(url)
        xhr.open("GET", url)
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    let data = JSON.parse(xhr.responseText)
                    for (let i = 0; i < data.length; i++) {
                        insertData(data[i].id+1, data[i].name, data[i].balance,  data[i].age, data[i].email, data[i].gender,  data[i].phone)
                    }
                }
            }
        }
        xhr.send()
    }

    function loadModelData(start, end) {
        //have to modify readData to read only increments of 20 and append to model
        let sqlData = readData(start,end);
        for(let i = 0; i<sqlData.length; i++){
            listModel.append({
                                 "id": sqlData[i].id,
                                 "balance": sqlData[i].balance,
                                 "age": sqlData[i].age,
                                 "name": sqlData[i].name,
                                 "gender": sqlData[i].gender,
                                 "email": sqlData[i].email,
                                 "phone": sqlData[i].phone
                             })
            console.log(sqlData[i].name)
        }
    }

    function openDB() {
        db = Sql.LocalStorage.openDatabaseSync("userDB", "1.0", "Cache server data", 1000000);
    }
    function createTable() {
        db.transaction(
                    function(tx) {
                        tx.executeSql('CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY, name TEXT, balance TEXT, age INTEGER, email TEXT, gender TEXT, phone TEXT)');
                    }
                    )
    }
    function insertData(id, name, balance, age, email, gender, phone) {
        db.transaction(
                    function(tx) {
                        tx.executeSql('INSERT INTO users VALUES(?,?,?,?,?,?,?)', [id, name, balance, age, gender, email, phone]);
                    }
                    )
    }
    function readData(start,end) {
        start = start+1
        let res = [];
        db.readTransaction(
                    function(tx) {
                        let data = tx.executeSql('SELECT * FROM users WHERE rowid BETWEEN ? AND ?', [start, end]);
                        for(let i = 0; i<data.rows.length; i++) {
                            res.push(data.rows.item(i));
                        }
                    }
                    );
        return res;
    }

}
