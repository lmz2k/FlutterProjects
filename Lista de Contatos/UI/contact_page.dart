import 'dart:io';

import 'package:contact_list/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ContactPAge extends StatefulWidget {
  final Contact contact;

  ContactPAge({this.contact});

  @override
  _ContactPAgeState createState() => _ContactPAgeState();
}

class _ContactPAgeState extends State<ContactPAge> {
  Contact _editedContact;
  bool _userEdited = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();


  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact =  Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phoneNumber;

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name.isNotEmpty && _editedContact.name != null){
              Navigator.pop(context,_editedContact);
            }else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }

          },
          child: Icon(Icons.save),
          backgroundColor: Colors.lightGreen,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[

              GestureDetector(

                child:   Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContact.image != null
                              ? FileImage(File(_editedContact.image))
                              : AssetImage("images/person.jpg"))),
                ),
                onTap: (){

                  ImagePicker.pickImage(source: ImageSource.camera).then((file){


                    if (file == null) return;

                    setState(() {
                      _editedContact.image = file.path;
                    });

                  });

                },

              ),

              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text){
                    _userEdited = true;

                    setState(() {
                      _editedContact.name = text;
                    });
                  }


              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,

              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.phoneNumber = text;
                },
                keyboardType: TextInputType.phone,

              )

            ],
          ),
        ),
      ),
    );
  }


  Future<bool> _requestPop(){
    if (_userEdited){
      showDialog(context: context,
      builder: (context){
          return AlertDialog(
            title: Text("Descartar alterações?"),
            content: Text("Se sair as alterações serão perdidas!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Ok"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
              )
            ],
          );

          });

      return Future.value(false);
    }else{
      return Future.value(true);
    }

  }
}
