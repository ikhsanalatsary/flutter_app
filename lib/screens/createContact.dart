import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateContact extends StatefulWidget {
  final CollectionReference contacts;
  final String title;

  const CreateContact({Key key, @required this.contacts, @required this.title})
      : super(key: key);

  @override
  _CreateContactState createState() => _CreateContactState(contacts: contacts);
}

class _CreateContactState extends State<CreateContact> {
  final CollectionReference contacts;
  final _formKey = GlobalKey<FormState>();
  FocusNode _nameFocus, _phoneFocus, _emailFocus;
  String _name, _phone, _email;

  _CreateContactState({this.contacts});

  @override
  void initState() {
    super.initState();

    _nameFocus = FocusNode();
    _phoneFocus = FocusNode();
    _emailFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _formKey.currentState?.dispose();

    super.dispose();
  }

  clear() {
    _name = _phone = _email = null;
    _formKey.currentState?.reset();
  }

  onSave(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('saved $_name, $_phone, $_email!');
      saveTofirestore();
      clear();
      goBack(context);
    } else {
      print('belum isi');
    }
  }

  saveTofirestore() async {
    await contacts
        .add({"name": "$_name", "phone": "$_phone", "email": "$_email"});
  }

  goBack(context) {
    print('back');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => goBack(context),
        ),
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                textInputAction: TextInputAction.next,
                focusNode: _nameFocus,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Name *',
                ),
                validator: (val) {
                  print(val);
                  if (val.isEmpty) {
                    return 'Name is required!';
                  }

                  return null;
                },
                onSaved: (val) {
                  print('ini $val');
                  _name = val;
                },
                onFieldSubmitted: (val) {
                  _nameFocus.unfocus();
                  FocusScope.of(context).requestFocus(_phoneFocus);
                },
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                focusNode: _phoneFocus,
                maxLength: 13,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.phone),
                  labelText: 'Phone *',
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Phone is required!';
                  }
                  // validasi jika bukan phone number
                  // if () return 'harus valid phone';

                  return null;
                },
                onSaved: (String val) {
                  print('ini $val');
                  _phone = val;
                },
                onFieldSubmitted: (val) {
                  _phoneFocus.unfocus();
                  FocusScope.of(context).requestFocus(_emailFocus);
                },
              ),
              TextFormField(
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'Email *',
                ),
                validator: (String val) {
                  if (val.isEmpty) {
                    return 'Email is required!';
                  }
                  // validasi jika bukan email
                  // if () return 'harus valid email';

                  return null;
                },
                onSaved: (String val) {
                  print('ini $val');
                  _email = val;
                },
                onFieldSubmitted: (val) {
                  // saving
                  onSave(context);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () => onSave(context),
      ),
    );
  }
}
