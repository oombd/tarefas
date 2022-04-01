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
  Map<String, dynamic> _tarefaRemovida = {};

  TextEditingController _controllerTarefa = TextEditingController();

  _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarTarefa() {
    String textoDigitado = _controllerTarefa.text;
    Map<String, dynamic> tarefa = {};
    tarefa["nota"] = textoDigitado;
    tarefa["status"] = false;

    setState(() {
      _lista.add(tarefa);
    });
    _salvarArquivo();
    _controllerTarefa.text = "";
  }
  _salvarArquivo() async {

    var arquivo = await _getFile();
    String dados = json.encode(_lista);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      var erro = e.toString();
      return erro;
    }
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo().then( ( dados ) {
      setState(() {
        _lista = json.decode(dados);
      });
    });
  }

  Widget criarIntemLista(context, index) {
    return Dismissible(
        key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction){

          _tarefaRemovida = _lista[index];
          _lista.removeAt(index);
          _salvarArquivo();

          final snackBar = SnackBar(
            content: const Text("Nota removida!"),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: (){
                  setState(() {
                    _lista.insert(index, _tarefaRemovida);
                  });
                  _salvarArquivo();
                }),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        },
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.all(13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const <Widget>[
              Icon(
                  Icons.delete,
                color: Colors.white,
              )
            ],
          ),
        ),
        child: CheckboxListTile(
            title: Text(_lista[index]["nota"]),
            value: _lista[index]['status'],
            onChanged: (valor){
              setState(() {
                _lista[index]["status"] = valor;
              });
              _salvarArquivo();
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 238, 238, 238),
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 45, top: 40),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
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
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                    itemCount: _lista.length,
                    itemBuilder: criarIntemLista,
                  ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
        focusColor: Colors.white30,
        hoverColor: Colors.black54,
        splashColor: Colors.black54,
        elevation: 0,
        child: const Icon(Icons.add),
        onPressed: (){
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text("Adicionar tarefa"),
                  content: TextField(
                    controller: _controllerTarefa,
                    decoration: const InputDecoration(
                      labelText: "Digite sua tarefa"
                    ),
                    onChanged: (text) {

                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Cancelar"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text("Salvar"),
                      onPressed: () {
                        if (_controllerTarefa.text.isEmpty) {
                          Navigator.pop(context);
                          return;
                        }
                          _salvarTarefa();
                          Navigator.pop(context);
                      },
                    )
                  ],
                );
              },
          );
        },
        //child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 238, 238, 238),
        child: BottomAppBar(
          elevation: 0,
            color: Colors.white,
            shape: const CircularNotchedRectangle(),
            child: Row (
              children: <Widget>[
                IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.menu)
                ),
              ],
            )
        ),
      )
    );
  }
}
