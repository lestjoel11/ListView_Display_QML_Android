import QtQuick 2.15

Row{
//    property alias boxWidth : container.width
    property alias name : name.text
    property alias balance : balance.text
    id: dataRow
    Rectangle{
        id: container
        height: 50
        width: 300
        border.color: "black"
        border.width: 2
        radius:2
        Text {
            id: name
            anchors.verticalCenter:container.verticalCenter
            padding: 5
        }
        Text {
            id: balance
            padding: 5
            anchors.verticalCenter:container.verticalCenter
            anchors.left: name.right
            anchors.leftMargin: 10
        }
    }
}
