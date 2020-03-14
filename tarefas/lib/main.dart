import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _addTarefasController = TextEditingController();
  List _tarefas = [];

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _tarefas = json.decode(data);
      });
    });
  }

  void _addTarefa() {
    setState(() {
      Map<String, dynamic> novaTarefa = Map();
      novaTarefa["title"] = _addTarefasController.text;
      _addTarefasController.text = "";
      novaTarefa["ok"] = false;
      _tarefas.add(novaTarefa);
      _saveData();
    });
  }

  Future<Null> _refresh() async{

    await Future.delayed(Duration(seconds: 1));

    setState(() {

      _tarefas.sort((a,b){

        if (a["ok"] && !b["ok"]){
          return 1;
        }else if (!a["ok"] && b["ok"]){
          return -1;
        }else return 0;


      });

      _saveData();

    });

    return Null;




  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_tarefas);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  //INTERFACE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barraSuperiorHome(),
      body: corpoHome(),
    );
  }

  //BARRA SUPERIOR DA PAGINA HOME
  Widget barraSuperiorHome() {
    return AppBar(
      title: Text("Tarefas"),
      backgroundColor: Colors.blueAccent,
      centerTitle: true,
    );
  }

  //CORPO DA PAGINA HOME
  Widget corpoHome() {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _addTarefasController,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa: ",
                        labelStyle: TextStyle(
                          color: Colors.blueAccent,
                        )),
                  ),
                ),
                RaisedButton(
                  onPressed: _addTarefa,
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                ),
              ],
            )),
        Expanded(
          child: RefreshIndicator(child: listaDeTarefas(), onRefresh: _refresh),
        ),
      ],
    );
  }

  Widget listaDeTarefas() {
    return ListView.builder(
        padding: EdgeInsets.only(top: 10.0),
        itemCount: _tarefas.length,
        itemBuilder: buildItem);
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_tarefas[index]["title"]),
        value: _tarefas[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_tarefas[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            _tarefas[index]["ok"] = c;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_tarefas[index]);
          _lastRemovedPos = index;
          _tarefas.removeAt(index);

          _saveData();
        });

        final snack = SnackBar(
          content: Text("Tarefa Removida com sucesso"),
          action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _tarefas.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                });
              }),
          duration: Duration(seconds: 2),
        );

        Scaffold.of(context).showSnackBar(snack);
      },
    );
  }
}
