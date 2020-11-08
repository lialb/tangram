import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'constants.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create a user'),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // Validate returns true if the form is valid, otherwise false.
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                var url = '$ip/create-user';
                http.post(
                  url,
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'Username': usernameController.text,
                    'Name': nameController.text,
                    'Description': descriptionController.text,
                  }),
                );
                Navigator.pop(context);
              }
            },
            label: Row(
              children: [
                Icon(Icons.check),
                SizedBox(
                  width: 8.0,
                ),
                Text('Create user'),
              ],
            )),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'a_unique_string',
                    contentPadding:
                        // TODO: fix alignment
                        EdgeInsets.only(left: 10, top: 12, bottom: 5),
                  ),
                ),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Your full name',
                    contentPadding:
                        // TODO: fix alignment
                        EdgeInsets.only(left: 10, top: 12, bottom: 5),
                  ),
                ),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'A little bit about yourself...',
                    contentPadding:
                        // TODO: fix alignment
                        EdgeInsets.only(left: 10, top: 12, bottom: 5),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
