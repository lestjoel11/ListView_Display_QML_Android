import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("User Details")

    property int start: 0;
    property int end : 20;

    ListView{
        id: usersList
        anchors.fill: parent
        header: Text{
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Balance"
            font.pixelSize: 16
            font.bold: true
        }
        clip:true
        model:listModel
        delegate: listItem
        onMovementEnded: {
            if(contentY === contentHeight-height-headerItem.height){
                start=end
                end+=20
                loadData(start,end)
            }
        }
        spacing:2
    }
    Component.onCompleted: loadData(start,end)

    ListModel{
        id: listModel
    }
    Component{
        id:listItem

        Row{
            Component.onCompleted:
                ()=>{
                    anchors.horizontalCenter = parent.horizontalCenter
                }
            ExpansionPanel{
                name: model.index+". "+model.name
                balance: model.balance
                age: "Age: "+model.age
                email: "Email: "+model.email
                gender: "Gender: "+ model.gender
                phone: "Phone: "+model.phone
            }
        }
    }
    function loadData(start,end){
        let xhr = new XMLHttpRequest()
        let url = "http://localhost:3000/"+start+"-"+end
        console.log(url)
        xhr.open("GET",url)
        xhr.onreadystatechange = function(){
            if(xhr.readyState===XMLHttpRequest.DONE){
                if(xhr.status===200){
                    let data = JSON.parse(xhr.responseText)
                    for(let i=0; i<data.length; i++){
                        listModel.append({
                                             index:data[i].index+1,
                                             balance:data[i].balance,
                                             age:data[i].age,
                                             name:data[i].name,
                                             gender:data[i].gender,
                                             email:data[i].email,
                                             phone:data[i].phone
                                         })
                    }
                }
            }
        }
        xhr.send()
    }
}


