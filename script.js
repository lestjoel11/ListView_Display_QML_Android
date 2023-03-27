let db = Sql.LocalStorage.openDatabaseSync("userDB", "1.0",
                                           "Cache server data", 1000000)

function clearDB() {
  if (db) {
    db.transaction(function (tx) {
      tx.executeSql('DROP TABLE IF EXISTS users')
    })
  }
}

//const worker = new WorkerScript({
//                                  source: "worker.js"
//                                })

function loadToDB(start, end) {
  let url = "http://localhost:3000/" + start + "-" + end
  console.log(url)
  loadFromServer.sendMessage({
                       "url": url
                     })
}

//function loadToDB(start, end) {
//  let xhr = new XMLHttpRequest()
//  let url = "http://localhost:3000/" + start + "-" + end
//  console.log(url)
//  xhr.open("GET", url)
//  xhr.onreadystatechange = function () {
//    if (xhr.readyState === XMLHttpRequest.DONE) {
//      if (xhr.status === 200) {
//        let data = JSON.parse(xhr.responseText)
//        for (let i = 0; i < data.length; i++) {
//          insertData(data[i].id, data[i].name, data[i].balance,  data[i].age, data[i].email, data[i].gender,  data[i].phone)
//        }
//      }
//    }
//  }
//  xhr.send()
//}
function loadModelData(start, end, dbVal) {
  //have to modify readData to read only increments of 20 and append to model
  for (var i = 0; i < dbVal.length; i++) {
    listModel.append({
                       "id": dbVal[i].id,
                       "balance": dbVal[i].balance,
                       "age": dbVal[i].age,
                       "name": dbVal[i].name,
                       "gender": dbVal[i].gender,
                       "email": dbVal[i].email,
                       "phone": dbVal[i].phone
                     })
  }
}

function createTable() {
  db.transaction(function (tx) {
    tx.executeSql(
          'CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY, name TEXT, balance TEXT, age INTEGER, email TEXT, gender TEXT, phone TEXT)')
  })
}
function insertData(id, name, balance, age, email, gender, phone) {
  db.transaction(function (tx) {
    try {
      tx.executeSql('INSERT INTO users VALUES(?,?,?,?,?,?,?)',
                    [id, name, balance, age, gender, email, phone])
    } catch (e) {
      console.error(e)
    }
  })
}
function readData(start, end) {
  end = end - 1
  let res = []
  db.readTransaction(function (tx) {
    let data = tx.executeSql('SELECT * FROM users WHERE rowid BETWEEN ? AND ?',
                             [start, end])
    for (var i = 0; i < data.rows.length; i++) {
      res.push(data.rows.item(i))
    }
  })
  return res
}

function checkDBValues(start, end) {
  let res = readData(start, end)
  if (res.length > 0)
    return res
  return false
}

function dbOperations(start, end) {
  let dbVal = checkDBValues(start, end)

  if (!dbVal) {
    loadToDB(start, end)
  } else {
    loadModelData(start, end, dbVal)
  }
}
