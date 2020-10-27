import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'Controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CounterController c = Get.put(CounterController());

  TextEditingController titleCont = TextEditingController();

  TextEditingController desCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance.collection("TASK");

    Future<void> createData(String titles, String desc) async {
      await Firebase.initializeApp();
      // ref.doc(titleCont.text.toString()).set({
      //   'Title': titleCont.text.toString(),
      //   'Des': desCont.text.toString()
      // }).then((val) {
      //   print("Added");
      // });
      ref.add({'Title': titles, 'Des': desc}).then((val) {
        print("Added");
      });
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    key: Key(
                        snapshot.data.documents[index].documentID.toString()),
                    title: Text(
                      "${snapshot.data.documents[index].get('Title')}",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                        "${snapshot.data.documents[index].get('Des')}",
                        style: TextStyle(color: Colors.white)),
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          var id = snapshot.data.documents[index].documentID;
                          ref.doc(id).delete();
                          print("${snapshot.data.documents[index].documentID}");
                        }),
                  );
                });
          }
          return (CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.defaultDialog(
              backgroundColor: Colors.white,
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
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                    color: Colors.orange,
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      String title = titleCont.text;
                      String des = desCont.text;

                      if (title.isNotEmpty && des.isNotEmpty) {
                        createData(title, des);
                        Get.back();
                        titleCont.clear();
                        desCont.clear();
                        print("Added");
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

Future<void> readData() async {
  await Firebase.initializeApp();
  FirebaseFirestore.instance.collection('TODO').get().then((snapshot) {
    if (snapshot != null) {
      return ListView.builder(
          itemCount: snapshot.docs.length,
          itemBuilder: (BuildContext context, snapshot) {
            return null;
          });
    }
  });
}
