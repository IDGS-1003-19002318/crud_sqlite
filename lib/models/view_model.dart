import 'package:flutter/material.dart';
import 'package:crud_sqlite/helpers/database_helper.dart';

class ViewModel {
  final dbHelper = DatabaseHelper();

  void showSnackBar(String message, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<bool> insertRecord(String name, String description) async {
    Map<String, dynamic> row = {
      'name': name,
      'description': description,
    };

    int id = await dbHelper.insert(row);
    if (id != 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateRecord(int id, String name, String description) async {
    Map<String, dynamic> row = {
      'id': id,
      'name': name,
      'description': description,
    };

    int count = await dbHelper.update(row);
    if (count != 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteRecord(int id) async {
    int count = await dbHelper.delete(id);
    if (count != 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetch() async {
    return await dbHelper.queryAll();
  }
}
