import 'package:flutter/material.dart';
import 'package:crud_sqlite/models/view_model.dart';
//import 'database_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final dbHelper = DatabaseHelper();
  final vm = ViewModel();

  List<Map<String, dynamic>> _records = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editDescriptionController =
      TextEditingController();

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
      _nameController.clear();
      _descriptionController.clear();
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
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      bool insercion = await vm.insertRecord(
                          _nameController.text, _descriptionController.text);
                      if (insercion) {
                        // ignore: use_build_context_synchronously
                        vm.showSnackBar('Se ha agregado el registro', context);
                        _fetchRecords();
                      } else {
                        // ignore: use_build_context_synchronously
                        vm.showSnackBar('Se ha producido un error', context);
                      }
                    },
                    child: const Text('Añadir un nuevo registro'),
                  ),
                ),
              ],
            ),
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
                                    title: const Text(
                                        '¿Desea borrar el registro?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          vm.deleteRecord(record['id']);
                                          _fetchRecords();
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text('Confirmar'),
                                      ),
                                    ]));
                      } else {
                        _editNameController.text = record['name'];
                        _editDescriptionController.text = record['description'];
                        return showDialog(
                            context: context,
                            builder: (builder) => AlertDialog(
                                    title: const Text('Editar registro'),
                                    content: SizedBox(
                                      height: 130,
                                      child: Column(children: [
                                        TextField(
                                            controller: _editNameController,
                                            decoration: const InputDecoration(
                                              labelText: 'Nombre',
                                            )),
                                        TextField(
                                            controller:
                                                _editDescriptionController,
                                            decoration: const InputDecoration(
                                              labelText: 'Descripción',
                                            )),
                                      ]),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          vm.updateRecord(
                                              record['id'],
                                              _editNameController.text,
                                              _editDescriptionController.text);
                                          Navigator.of(context).pop(false);
                                          _fetchRecords();
                                        },
                                        child: const Text('Confirmar cambios'),
                                      ),
                                    ]));
                      }
                    },
                    background: Container(
                      color: const Color.fromARGB(255, 255, 251, 0),
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text('Editar',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )
                          ]),
                    ),
                    secondaryBackground: Container(
                      color: const Color.fromARGB(255, 229, 99, 90),
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text('Eliminar',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )
                          ]),
                    ),
                    key: Key(record['id'].toString()),
                    onDismissed: (direction) => {
                      if (direction == DismissDirection.endToStart)
                        {
                          vm.showSnackBar(
                              'Se ha eliminado el registro existosamente',
                              context)
                        }
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(record['name']),
                        subtitle: Text(record['description']),
                        onTap: () {
                          _selectRecord(record);
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
    );
  }
}
