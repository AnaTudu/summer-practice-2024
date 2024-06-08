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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _addfilme() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final String title = _titleController.text;
    final String mesaj = _mesajController.text;
    final String link = _linkController.text;
    final String vizionat = _vizionatController.text;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adauga filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titlu film',
                  icon: Icon(Icons.movie),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Fara titlu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mesajController,
                decoration: const InputDecoration(
                  labelText: 'Descriere',
                  icon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Fara descriere';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Link',
                  icon: Icon(Icons.link),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _vizionatController,
                decoration: const InputDecoration(
                  labelText: 'Vizionat',
                  icon: Icon(Icons.visibility),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addfilme,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text('Adauga film'),
              ),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('filme')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Ops!! Ceva nu e OK!');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }
                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return ListTile(
                              title: Text('Titlu: ${data['titlu']}'),
                              subtitle: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Text('Descriere: ${data['mesaj']}'),
                                    Text('Link: ${data['link']}'),
                                    Text('Vizionat: ${data['vizionat']}'),
                                  ])));
                        }).toList(),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
