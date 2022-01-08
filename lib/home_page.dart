import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _toDoController = TextEditingController();
  Map<String, dynamic> _lastRemove = Map();

  List _listToDo = [];

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  _saveToDo() {
    String text = _toDoController.text;
    Map<String, dynamic> toDo = Map();
    toDo['title'] = text;
    toDo['check'] = false;
    setState(() {
      _listToDo.add(toDo);
    });
    _saveFile();
    _toDoController.text = '';
  }

  _saveFile() async {
    var file = await _getFile();

    String data = json.encode(_listToDo);
    file.writeAsString(data);
  }

  _readFile() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readFile().then((data) {
      setState(() {
        _listToDo = json.decode(data);
      });
    });
  }

  Widget createdList(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      onDismissed: (d) {
        _lastRemove = _listToDo[index];
        _listToDo.removeAt(index);
        _saveFile();

        final snackBar = SnackBar(
          content: Text('Tarefa removida!'),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () {
                setState(() {
                  _listToDo.insert(index, _lastRemove);
                });
                _saveFile();
              }),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      direction: DismissDirection.endToStart,
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.restore_from_trash,
            color: Colors.white,
          ),
        ),
      ),
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.green,
        child: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      ),
      child: ListTile(
        title: Text(_listToDo[index]['title']),
        trailing: Checkbox(
            value: _listToDo[index]['check'],
            onChanged: (v) {
              setState(() {
                _listToDo[index]['check'] = v;
              });
              _saveFile();
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manipulando dados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: createdList,
                itemCount: _listToDo.isEmpty ? 0 : _listToDo.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Adicionar Tarefa'),
                  content: TextField(
                    autofocus: true,
                    controller: _toDoController,
                    decoration: InputDecoration(
                      label: Text('Nome da tarefa'),
                    ),
                    onChanged: (text) {},
                  ),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        fixedSize: const Size(100, 40),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: const Size(100, 40),
                      ),
                      onPressed: () {
                        _saveToDo();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Adicionar',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
