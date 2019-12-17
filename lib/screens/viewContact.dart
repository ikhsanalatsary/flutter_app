import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/editContact.dart';

// String _callbackData;
class ViewContact extends StatefulWidget {
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
  _ViewContactState createState() => _ViewContactState();
}

// class _ViewContactState extends State<ViewContact> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: child,
//     );
//   }
// }

class _ViewContactState extends State<ViewContact> {
  String id;
  String name;
  CollectionReference contacts;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    name = widget.name;
    contacts = widget.contacts;
  }

  @override
  Widget build(BuildContext context) {
    print(id);
    return FutureBuilder<DocumentSnapshot>(
        future: contacts.document(id).get(),
        builder: (context, snapshot) {
          print('name = ${this.name}');
          final hasData = snapshot.hasData;
          var name = this.name;
          var phone = '-';
          var email = '-';
          if (hasData) {
            name = snapshot.data["name"];
            phone = snapshot.data["phone"];
            email = snapshot.data["email"];
          }
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  print('back');
                  Navigator.pop(context);
                },
              ),
              title: Text(name),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      print('buat edit');
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return EditContact(
                            key: ValueKey(id),
                            id: id,
                            contacts: contacts,
                            title: 'Edit Contact',
                          );
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text(name),
                      subtitle: Text('name'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(phone),
                      subtitle: Text('phone'),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(email),
                      subtitle: Text('email'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
