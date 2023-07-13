import 'package:flutter/material.dart';
import 'package:crud_sqlite/models/view_model.dart';
import 'package:crud_sqlite/pages/edit_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final vm = ViewModel();
  List<Map<String, dynamic>> _records = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecords() async {
    List<Map<String, dynamic>> records = await vm.fetch();
    setState(() {
      _records = records;
    });
  }

  void _selectRecord(Map<String, dynamic> record) {
    _nameController.text = record['name'];
    _descriptionController.text = record['description'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Joshua app'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'Listado de registros',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _records.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> record = _records[index];
                  return Dismissible(
                    confirmDismiss: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        return showDialog(
                          context: context,
                          builder: (builder) => AlertDialog(
                            title: const Text('¿Desea borrar el registro?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await vm.deleteRecord(record['id']);
                                  await _fetchRecords();
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Confirmar'),
                              ),
                            ],
                          ),
                        );
                      }
                      return Future.value(false);
                    },
                    background: Container(),
                    secondaryBackground: Container(
                      color: const Color.fromARGB(255, 229, 99, 90),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              'Eliminar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    key: Key(record['id'].toString()),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        vm.showSnackBar(
                          'Se ha eliminado el registro existosamente',
                          context,
                        );
                      }
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(record['name']),
                        subtitle: Text(record['description']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPage(record: record),
                            ),
                          ).then((value) {
                            _fetchRecords();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AgregarElemento(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  FloatingActionButton AgregarElemento(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (builder) => AlertDialog(
            title: const Text('¿Desea agregar el registro?'),
            content: SizedBox(
              height: 130,
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  await vm.insertRecord(
                    _nameController.text,
                    _descriptionController.text,
                  );
                  await _fetchRecords();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Confirmar'),
              ),
            ],
          ),
        );
      },
      tooltip: 'Agregar registro',
      elevation: 2.0,
      child: const Icon(Icons.add),
    );
  }
}
