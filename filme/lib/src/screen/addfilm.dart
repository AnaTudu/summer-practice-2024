import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Addfilm extends StatefulWidget {
  const Addfilm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddfilmState createState() => _AddfilmState();
}

class _AddfilmState extends State<Addfilm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mesajController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _vizionatController = TextEditingController();
  final List<Map<String, dynamic>> _filme = [];

  void _addfilme() async {
    final String title = _titleController.text;
    final String mesaj = _mesajController.text;
    final String link = _linkController.text;
    final String vizionat = _vizionatController.text;
    if (title.isEmpty || mesaj.isEmpty) {
      return;
    }

    CollectionReference movies =
        FirebaseFirestore.instance.collection('movies');

    await movies.add({
      'title': title,
      'mesaj': mesaj,
      'link': link,
      'vizionat': vizionat,
      'likes': false,
      'interested': false,
    });

    _titleController.clear();
    _mesajController.clear();
    _linkController.clear();
    _vizionatController.clear();
  }

  void _toggleLike(int index) {
    setState(() {
      _filme[index]['likes'] = !_filme[index]['likes'];
    });
  }

  void _toggleInterested(int index) {
    setState(() {
      _filme[index]['interested'] = !_filme[index]['interested'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adauga filme'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Titlu film'),
          ),
          TextField(
            controller: _mesajController,
            decoration: const InputDecoration(labelText: 'Descriere'),
          ),
          TextField(
            controller: _linkController,
            decoration: const InputDecoration(labelText: 'Link'),
          ),
          TextField(
            controller: _vizionatController,
            decoration: const InputDecoration(labelText: 'Vizionat'),
          ),
          ElevatedButton(
            onPressed: _addfilme,
            child: const Text('Adauga film'),
          ),
          Expanded(
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('filme').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Ops!! Ceva nu e OK!');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ListTile(
                          title: Text('Titlu: ${data['titlu']}'),
                          subtitle: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                Text('Descriere: ${data['mesaj']}'),
                                Text('Link: ${data['link']}'),
                                Text('Vizionat: ${data['vizionat']}'),
                              ]))
                          // Add the rest of your movie data here
                          );
                    }).toList(),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
