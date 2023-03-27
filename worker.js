WorkerScript.onMessage = function(message) {
  let res = []
  let xhr = new XMLHttpRequest();
  xhr.open("GET", message.url);
  xhr.onreadystatechange = function () {
    if (xhr.readyState === XMLHttpRequest.DONE) {
      if (xhr.status === 200) {
        let data = JSON.parse(xhr.responseText);
//        for (let i = 0; i < data.length; i++) {
//          insertData(data[i].id, data[i].name, data[i].balance, data[i].age, data[i].email, data[i].gender, data[i].phone);
//        }
//        console.log(data)
        WorkerScript.sendMessage({data});
      }
    }
  };
  xhr.send();
};
