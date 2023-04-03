import QtQuick 2.15
//import com.example.model


Rectangle{
  id: container
  implicitWidth: 400
  radius: 2
  border { color: "black"; width: 2 }

  property alias name: name.text
  property alias balance: balance.text

  property alias age : age.text

  property alias email: email.text
  property alias phone: phone.text
  property alias gender: gender.text
  property alias serial : serial.text;

  states: [
    State{
      name: "collapsed"
      PropertyChanges { target: container; height: detailsHeader.height+contactNumber.height+30 }
//      PropertyChanges { target: detailsHeader; y: (container.height-detailsHeader.height)/2 }
      PropertyChanges { target: moreDetails; visible: false }
      //      PropertyChanges { target: footer; visible: false }
    },
    State{
      name:"expanded"
      PropertyChanges { target: detailsHeader; y: 5}
      PropertyChanges { target: moreDetails; visible: true }
      //      PropertyChanges { target: footer; visible: true }
      PropertyChanges { target: container; height: moreDetails.height+detailsHeader.height+moreDetails.spacing+detailsHeader.spacing+30}
    }
  ]
  transitions: [
    Transition {
      from: "collapsed"
      to: "expanded"
      PropertyAnimation{
        target: container
        property: "height"
        duration: 100
      }
      PropertyAnimation{
        target: moreDetails
        property: "visible"
        duration: 30
        easing.type: Easing.InOutBack
      }
      NumberAnimation{
        target: detailsHeader
        property: "y"
        duration: 100
      }
    },
    Transition {
      from: "expanded"
      to: "collapsed"
      PropertyAnimation{
        target: container
        property: "height"
        duration: 100
      }
      NumberAnimation{
        target: detailsHeader
        property: "y"
        duration: 100
      }
      PropertyAnimation{
        target: moreDetails
        property: "visible"
        duration: 30
        easing.type: Easing.InOutBack
      }
    }

  ]
  state: "collapsed"

  UserContact {
    id: userContact
  }

  Row{
    id:detailsHeader
    anchors.horizontalCenter: container.horizontalCenter
    spacing: 5
    Text { id: serial; font.pointSize: 16}
    Text { id: name; font.pointSize: 16}
    Text { id: balance }
  }
  Row {
    id: contactNumber
    anchors.top: detailsHeader.bottom
    anchors.horizontalCenter: container.horizontalCenter
    Text {
      id: phone
      font.pointSize: 12
      color: "gray"

    }
  }
  Row {
    id: contactAction
    anchors.top: contactNumber.bottom
    anchors.horizontalCenter: container.horizontalCenter
    Text {
      id: contactStatus
      text: "Add to contact or edit contact based on Contact Existing"
      font.pointSize: 14
      color: "green"
    }
  }

  Row{
    id: moreDetails
    anchors { top: detailsHeader.bottom; horizontalCenter: container.horizontalCenter}
    Column{
      spacing: 5
      Row {
        Text { id: labelForAge; text: "Age: " }
        Text { id: age }
      }
      Row {
        Text { id: labelForGender; text: "Gender: " }
        Text { id: gender }
      }
      Row{
        Text { id: labelForEmail; text: "Email: " }
        Text { id: email }
      }

    }
  }
  MouseArea {
    anchors.fill:  container
//    onClicked: { container.state = (container.state==="collapsed"?"expanded":"collapsed") }
//    onClicked: { userContact.contactData([name.text, email.text, phone.text]) }
  }

}

