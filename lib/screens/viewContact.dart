import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/editContact.dart';

String _callbackData;

class ViewContact extends StatelessWidget {
  final String id;
  final String name;
  final CollectionReference contacts;
  const ViewContact(
      {Key key,
      @required this.name,
      @required this.id,
      @required this.contacts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(id);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print('back');
            Navigator.pop(context);
          },
        ),
        title: Text(_callbackData != null ? _callbackData : name),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                print('buat edit');
                _callbackData = await Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return EditContact(
                        key: ValueKey(id), id: id, contacts: contacts);
                  },
                ));
              }),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              print('buat delete');
              await contacts.document(id).delete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
            key: key,
            future: contacts.document(id).get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text(snapshot.data["name"]),
                        subtitle: Text('name'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text(snapshot.data["phone"]),
                        subtitle: Text('phone'),
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text(snapshot.data["email"]),
                        subtitle: Text('email'),
                      ),
                    ],
                  ),
                );
              }

              return SizedBox();
            }),
      ),
    );
  }
}
