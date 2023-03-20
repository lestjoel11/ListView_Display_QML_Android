import QtQuick 2.15

Rectangle{
    id: container
    width: 300
    border.color: "black"
    border.width: 2
    radius:2
    property alias name : name.text
    property alias balance : balance.text

    property alias age: age.text

    property alias email: email.text
    property alias phone: phone.text
    property alias gender: gender.text
    states: [
        State{
            name: "collapsed"
            PropertyChanges {
                target: container
                implicitHeight:50
            }
            PropertyChanges{
                target: detailsHeader
                y: (container.height-detailsHeader.height)/2
            }
            PropertyChanges {
                target: moreDetails
                visible: false
            }
        },
        State{
            name:"expanded"
            PropertyChanges{
                target: detailsHeader
                y: 5
            }
            PropertyChanges {
                target: container
                implicitHeight: moreDetails.height+detailsHeader.height+10
            }
            PropertyChanges {
                target: moreDetails
                visible: true
            }
        }
    ]
    transitions: [
        Transition {
            from: "collapsed"
            to: "expanded"
            PropertyAnimation{
                target: container
                property: "implicitHeight"
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
                property: "implicitHeight"
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
    Row{
        id:detailsHeader
        anchors.horizontalCenter: container.horizontalCenter
        spacing: 10
        Text {
            id: name
        }
        Text {
            id: balance
        }
    }
    Row{
        id:moreDetails
        anchors.top: detailsHeader.bottom
        anchors.horizontalCenter: container.horizontalCenter
        Column{
            spacing: 3
            Text {
                id: age
            }
            Text {
                id: gender
            }
            Text {
                id: email
            }
            Text {
                id: phone
            }
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: function(){
            container.state = (container.state==="collapsed"?"expanded":"collapsed")
        }
    }
}

