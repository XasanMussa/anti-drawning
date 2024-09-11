// notification.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';

class notification extends StatefulWidget {
  @override
  _notificationState createState() => _notificationState();
}

class _notificationState extends State<notification> {
  List<Map<String, dynamic>> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var data = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      _cards = data;
    });
  }

  void _deleteCard(int id) async {
    await DatabaseHelper.instance.delete(id);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_cards[index][DatabaseHelper.columnTitle]),
              subtitle: Text(_cards[index][DatabaseHelper.columnSubtitle]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () =>
                    _deleteCard(_cards[index][DatabaseHelper.columnId]),
              ),
            ),
          );
        },
      ),
    );
  }
}
