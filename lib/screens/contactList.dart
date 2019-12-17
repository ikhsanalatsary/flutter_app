import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/createContact.dart';
import 'package:flutter_app/screens/viewContact.dart';

class ContactList extends StatefulWidget {
  final CollectionReference dbContacts;
  final FirebaseMessaging fcm;

  const ContactList({Key key, @required this.dbContacts, @required this.fcm})
      : super(key: key);

  @override
  _ContactListState createState() =>
      _ContactListState(contacts: dbContacts, fcm: fcm);
}

class _ContactListState extends State<ContactList> {
  final CollectionReference contacts;
  final FirebaseMessaging fcm;

  _ContactListState({this.contacts, this.fcm});

  @override
  void initState() {
    super.initState();

    // ios request notification
    fcm.requestNotificationPermissions();
    fcm.getToken().then((deviceId) => print('deviceId: $deviceId'));
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
            stream: contacts.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text('Loading'),
                    ],
                  );
                case ConnectionState.waiting:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text('Please wait'),
                    ],
                  );
                default:
                  if (snapshot.hasData) {
                    print('sini ${snapshot.data.documents}');
                    return ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          final DocumentSnapshot doc =
                              snapshot.data.documents[index];
                          final _name = doc.data["name"];
                          final _id = doc.documentID;
                          return Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.person),
                                title: Text(_name),
                                onTap: () {
                                  print('tapped!');
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return ViewContact(
                                          key: ValueKey(_id),
                                          name: _name,
                                          id: _id,
                                          contacts: contacts);
                                    },
                                  ));
                                },
                              ),
                              Divider(
                                color: Colors.grey[300],
                              )
                            ],
                          );
                        });
                  }

                  return null; // unreachable
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateContact(
                        contacts: contacts,
                        title: 'Create',
                      )));
        },
      ),
    );
  }
}
