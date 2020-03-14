import 'dart:io';
import 'package:contact_list/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'contact_page.dart';
import "package:url_launcher/url_launcher.dart";

enum OrderOptions {orderaz, orderza}

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  Contact_helper helper = Contact_helper();
  List<Contact> listaDeContatos = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("ORDENDAR A - Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("ORDENDAR Z - A"),
                value: OrderOptions.orderza,
              )

            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: listaDeContatos.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: listaDeContatos[index].image != null
                            ? FileImage(File(listaDeContatos[index].image))
                            : AssetImage("images/person.jpg"))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      listaDeContatos[index].name ?? "",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      listaDeContatos[index].email ?? "",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      listaDeContatos[index].phoneNumber ?? "",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(context, index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return (Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Ligar",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                          
                          launch("tel:${listaDeContatos[index].phoneNumber}");
                          Navigator.pop(context);

                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: listaDeContatos[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {

                          helper.deleteContact(listaDeContatos[index].id);
                          setState(() {
                            listaDeContatos.removeAt(index);
                            Navigator.pop(context);
                          });

                        },
                      ),
                    )
                  ],
                ),
              ));
            },
          );
        });
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPAge(contact: contact)));

    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        listaDeContatos = list;
      });
    });
  }

  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        listaDeContatos.sort((a,b){

          return a.name.toLowerCase().compareTo(b.name.toLowerCase());

        });
        break;

      case OrderOptions.orderza:
        listaDeContatos.sort((a,b){

          return b.name.toLowerCase().compareTo(a.name.toLowerCase());

        });
        break;

    }
    setState(() {

    });

  }
}
