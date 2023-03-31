import QtQuick 2.15
import QtQuick.Window 2.15
import com.example.model

Window {
  id: mainWindow
  width: 640
  height: 480
  visible: true
  title: qsTr("User Details")

  property int gridViewIndex: 0
  ListView {
    signal updateRows()
    id: usersList
    anchors.fill: parent
    clip: true
    header: Text {
      id: title
      text: "Balance"
      font { pixelSize: 16; bold: true }
    }
    model: UserDetail {}
    onUpdateRows: model.increaseRows()
    delegate: delegateItem
  }

  Component {
    id: delegateItem
    Row {
      id: dataRow
      ExpansionPanel {
        name: model.id + ". " + model.name
        balance: model.balance
        age: "Age: " + model.age
        email: "Email: " + model.email
        gender: "Gender: " + model.gender
        phone: "Phone: " + model.phone
        Component.onCompleted: {
          if (index > dataRow.ListView.view.count - 5 ) { usersList.updateRows(); }
        }
        AddContactBtn { contactInfo: [model.name, model.email, model.phone]; }
      }
    }
  }
}
