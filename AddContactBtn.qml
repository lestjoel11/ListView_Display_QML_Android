import QtQuick 2.15
import com.example.model

Rectangle {
  property var contactInfo : [];
  UserContact {
    id: userContact
  }
  height: addButton.height + 5
  width: addButton.width + 5
//  anchors.top: phone.bottom
  radius: 2
  border { color: "blue"; width: 3 }
  MouseArea {
    anchors.fill: parent
    onClicked: {
      let userVal = contactInfo[0]+","+contactInfo[1]+","+contactInfo[2]
      userContact.contactData(userVal)
    }
    Text { id: addButton; text: "Add to Contacts"}
  }
}
