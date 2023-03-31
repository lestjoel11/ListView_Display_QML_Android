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
  GridView {

    signal updateRows()
    id: usersGrid
    anchors.fill: parent
    cellWidth: 200
    cellHeight: 350
    clip: true
    header: Text {
      id: title
      text: "Balance"
      font { pixelSize: 16; bold: true }
    }
    model: UserDetail {}
    onUpdateRows: model.increaseRows()
    delegate: delegateItem
    snapMode: GridView.SnapToRow
  }

  Component {
    id: delegateItem
    Row {
      spacing: 30
      ExpansionPanel {
        name: model.id + ". " + model.name
        balance: model.balance
        age: "Age: " + model.age
        email: "Email: " + model.email
        gender: "Gender: " + model.gender
        phone: "Phone: " + model.phone
        Component.onCompleted: {
          if (index > parent.GridView.view.count - 5 ) { usersGrid.updateRows(); }
        }
      }
      AddContactBtn { contactInfo: [model.name, model.email, model.phone]; }
    }

  }
}
