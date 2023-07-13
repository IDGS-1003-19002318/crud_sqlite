import 'package:flutter/material.dart';
import 'package:crud_sqlite/models/view_model.dart';

class EditPage extends StatefulWidget {
  final Map<String, dynamic> record;

  const EditPage({Key? key, required this.record}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<Map<String, dynamic>> _records = [];
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editDescriptionController =
      TextEditingController();
  late int _id = 0;

  final vm = ViewModel();

  @override
  void initState() {
    super.initState();
    _editNameController.text = widget.record['name'];
    _editDescriptionController.text = widget.record['description'];
    _id = widget.record['id'];
  }

  @override
  void dispose() {
    _editNameController.dispose();
    _editDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 130,
              child: Column(children: [
                TextField(
                    controller: _editNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                    )),
                TextField(
                    controller: _editDescriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                    )),
              ]),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await vm.updateRecord(
                  _id,
                  _editNameController.text,
                  _editDescriptionController.text,
                );
                await vm.fetch();
                Navigator.of(context).pop();
              },
              child: const Text('Actualizar'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
