/**
  Initial implementation with QML ListView, and WorkerScript
  */

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.LocalStorage as Sql
import "script.js" as Script
//Preload the data on one go and next time in C++
Window {
  id: mainWindow
  width: 640
  height: 480
  visible: true
  title: qsTr("User Details")

  property int start: 0
  property int end: 20

  //question about properties, should they be parameters for functions
//      property var db: null
  ListModel {
    id: listModel
  }
  //Issues till now: first load is empty
  // after certain point its not seamless enough
  WorkerScript {
    id: loadFromServer
    source: "worker.js"
    onMessage: (messageObj)=>{
                 for (let i = 0; i < messageObj.data.length; i++) {
                   Script.insertData(messageObj.data[i].id, messageObj.data[i].name, messageObj.data[i].balance, messageObj.data[i].age, messageObj.data[i].email, messageObj.data[i].gender, messageObj.data[i].phone);
                 }
                 let dbVal = Script.readData(start, end)
                 Script.loadModelData(start, end, dbVal)
               }
  }
  Component.onCompleted: {
    Script.createTable() // check if table exists if not create it

    Script.dbOperations(start, end)
//    Script.clearDB()
  }
  ListView {
    id: usersList
    anchors {
      fill: parent
      margins: 20
    }
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
        name: (model.id + 1) + ". " + model.name
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
          //                    loadToDB(start, end)
          //                    loadModelData(start,end)
          Script.dbOperations(start, end)
        }
      }
    }
  }
}
