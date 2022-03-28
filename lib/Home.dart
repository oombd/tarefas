import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _lista = [];

  _salvarArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    File arquivo =  File("${diretorio.path}/dados.json");

    Map<String, dynamic> tarefa = Map();
    tarefa["tarefa"] = "sdhjbfzisbdli";
    tarefa["realizada"] = false;
    _lista.add(tarefa);

    String dados = json.encode(_lista);
    arquivo.writeAsString(dados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 40, top: 35),
        child: Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 238, 238, 238),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              )
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.87,
          //color: const Color.fromARGB(255, 255, 1, 1),
          padding: const EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                    itemCount: _lista.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_lista[index]),
                      );
                    },
                  ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 123, 0, 0),
        foregroundColor: Colors.white,
        focusColor: Colors.blue,
        hoverColor: Colors.orange,
        splashColor: Colors.orange,
        elevation: 0,
        child: const Icon(Icons.add),
        onPressed: (){

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Adicionar tarefa"),
                  content: TextField(
                    decoration: const InputDecoration(
                      labelText: "Digite sua tarefa"
                    ),
                    onChanged: (text) {

                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Cancelar"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text("Salvar"),
                      onPressed: (){} ,
                    )
                  ],
                );
              },
          );
        },
        //child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row (
          children: <Widget>[
            IconButton(
                onPressed: (){},
                icon: Icon(Icons.menu)
            ),
          ],
        )
      ),
    );
  }
}
