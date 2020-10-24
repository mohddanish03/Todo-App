import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'Controller.dart';

class HomeScreen extends StatelessWidget {
  final CounterController c = Get.put(CounterController());
  TextEditingController titleCont = TextEditingController();
  TextEditingController desCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection("Users");
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: user.snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error!.Something is wrong'),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          "${snapshot.data.documents[index].get('Title')}",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      subtitle: Text(
                          "${snapshot.data.documents[index].get('Des')}",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                      trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {}),
                    );
                  });
            }
            return CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.defaultDialog(
              title: 'New Task',
              content: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: titleCont,
                      decoration: InputDecoration(
                          labelText: "Title", border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: desCont,
                      decoration: InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.orange,
                    child: Text("Submit"),
                    onPressed: () {
                      String title = titleCont.text;
                      String des = desCont.text;
                      if (title.isNotEmpty && des.isNotEmpty) {
                        createUser(title, des);
                        Get.back();
                        titleCont.clear();
                        desCont.clear();
                      }
                      Get.back();
                    },
                  ),
                ],
              ));
        },
        label: Text('Add Task'),
        icon: Icon(Icons.add),
      ),
    );
  }
}

Future<void> createUser(String title, String description) async {
  await Firebase.initializeApp();
  CollectionReference ref = FirebaseFirestore.instance.collection("Users");
  ref.add({'Title': title, 'Des': description});
  return;
}

Future<void> readData() async {
  await Firebase.initializeApp();
  FirebaseFirestore.instance
      .collection('Users')
      .where('Users', isEqualTo: 'Danish')
      .get()
      .then((snapshot) {
    if (snapshot != null) {
      return ListView.builder(
          itemCount: snapshot.docs.length,
          itemBuilder: (BuildContext context, snapshot) {
            return null;
          });
    }
  });
}
