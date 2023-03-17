import QtQuick 2.15


//    property alias boxWidth : container.width


Rectangle{
    id: container

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
                target: moreDetails
                visible: false
            }
            PropertyChanges {
                target: container
                implicitHeight:50

            }
        },
        State{
            name:"expanded"
            PropertyChanges {
                target: container
                implicitHeight: detailsHeader.height+moreDetails.height
            }
        }
    ]
    state: "collapsed"
    width: 300
    border.color: "black"
    border.width: 2
    radius:2
    Row{
        id:detailsHeader
        anchors{
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        spacing: 10
        Text {
            id: name
        }
        Text {
            id: balance
        }
    }
    Column{
        id:moreDetails
        spacing: 10
        anchors.top: detailsHeader.bottom
        anchors{
            horizontalCenter: detailsHeader.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
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
    MouseArea{
        anchors.fill: parent
        onClicked: function(){
            container.state = (container.state==="collapsed"?"expanded":"collapsed")
        }
    }
}

