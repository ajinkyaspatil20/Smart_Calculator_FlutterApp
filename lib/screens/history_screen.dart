import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class HistoryScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation History'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Clear History',
                      style: Theme.of(context).textTheme.titleMedium),
                  content: Text('Are you sure you want to clear all history?',
                      style: Theme.of(context).textTheme.bodyMedium),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text('Clear'),
                      onPressed: () {
                        _firebaseService.clearAllHistory();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
body: StreamBuilder<List<Map<String, dynamic>>>( 

        stream: _firebaseService.getCalculationsHistory().map((data) => data), 

        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {

            return Center(child: Text('No calculations in history'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,

            itemBuilder: (context, index) {
              var data = snapshot.data![index];


              return Dismissible(
                key: Key(data['expression']),

                background: Container(
                  color: Theme.of(context).colorScheme.error,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.delete),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _firebaseService.deleteCalculation(data['id']);

                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                      '${data['expression']} = ${data['result']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      'Type: ${data['type']}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    trailing: Text(
                      data['timestamp'] != null
                          ? _formatTimestamp(data['timestamp'] as Timestamp)
                          : '',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}\n${dateTime.hour}:${dateTime.minute}';
  }
}
