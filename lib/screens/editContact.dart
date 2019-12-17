import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditContact extends StatefulWidget {
  final CollectionReference contacts;
  final String id, title;

  const EditContact(
      {Key key,
      @required this.id,
      @required this.contacts,
      @required this.title})
      : super(key: key);

  @override
  _EditContactState createState() =>
      _EditContactState(contacts: contacts, id: id);
}

class _EditContactState extends State<EditContact> {
  final String id;
  final CollectionReference contacts;
  final _formKey = GlobalKey<FormState>();
  final AsyncMemoizer _memoizer = AsyncMemoizer<DocumentSnapshot>();
  FocusNode _nameFocus, _phoneFocus, _emailFocus;
  // String _name, _phone, _email;
  TextEditingController _nameController, _phoneController, _emailController;

  _EditContactState({this.contacts, this.id});

  @override
  void initState() {
    super.initState();

    _nameFocus = FocusNode();
    _phoneFocus = FocusNode();
    _emailFocus = FocusNode();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _formKey.currentState?.dispose();

    super.dispose();
  }

  clear() {
    // _name = _phone = _email = null;
    _formKey.currentState?.reset();
  }

  onUpdate(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // print('saved $_name, $_phone, $_email!');
      updateData();
      clear();
      goBack(context);
    } else {
      print('belum isi');
    }
  }

  updateData() async {
    await contacts.document(id).updateData({
      "name": "${_nameController.text}",
      "phone": "${_phoneController.text}",
      "email": "${_emailController.text}"
    });
  }

  goBack(context) {
    print('back');
    Navigator.pop(context, _nameController.text);
  }

  Widget _buildForm(BuildContext context,
      [data = const {"name": "", "phone": "", "email": ""}]) {
    print('data = $data');
    _nameController.value = _nameController.text.isEmpty
        ? TextEditingValue(
            text: data["name"],
            selection: TextSelection.collapsed(offset: data["name"].length))
        : _nameController.value;
    _phoneController.value = _phoneController.text.isEmpty
        ? TextEditingValue(
            text: data["phone"],
            selection: TextSelection.collapsed(offset: data["phone"].length))
        : _phoneController.value;
    _emailController.value = _emailController.text.isEmpty
        ? TextEditingValue(
            text: data["email"],
            selection: TextSelection.collapsed(offset: data["email"].length))
        : _emailController.value;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
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
                // _name = val;
              },
              onChanged: (val) {
                // _nameController.value = TextEditingValue(
                //     text: val,
                //     selection: TextSelection.collapsed(offset: val.length));
                // _name = val;
              },
              onFieldSubmitted: (val) {
                _nameFocus.unfocus();
                FocusScope.of(context).requestFocus(_phoneFocus);
              },
            ),
            TextFormField(
              controller: _phoneController,
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
                // _phone = val;
              },
              onChanged: (val) {
                // _phoneController.value = TextEditingValue(
                //     text: val,
                //     selection: TextSelection.collapsed(offset: val.length));
                // _phone = val;
              },
              onFieldSubmitted: (val) {
                _phoneFocus.unfocus();
                FocusScope.of(context).requestFocus(_emailFocus);
              },
            ),
            TextFormField(
              controller: _emailController,
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
                // _email = val;
              },
              onChanged: (val) {
                // _emailController.value = TextEditingValue(
                //     text: val,
                //     selection: TextSelection.collapsed(offset: val.length));
                // _email = val;
              },
              onFieldSubmitted: (val) {
                // saving
                onUpdate(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<DocumentSnapshot> _fetchData() async {
    return _memoizer.runOnce(() => contacts.document(id).get());
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
      body: FutureBuilder<DocumentSnapshot>(
          future: _fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildForm(context, snapshot.data);
            } else {
              return _buildForm(context);
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () => onUpdate(context),
      ),
    );
  }
}
