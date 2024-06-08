import 'package:flutter/material.dart';

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

  void _addfilme() {
    final String title = _titleController.text;
    final String mesaj = _mesajController.text;
    final String link = _linkController.text;
    final String vizionat = _vizionatController.text;
    if (title.isEmpty || mesaj.isEmpty) {
      return;
    }
    setState(() {
      _filme.add({
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
    });
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
        title: const Text('Add filme'),
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
            child: ListView.builder(
              itemCount: _filme.length,
              itemBuilder: (ctx, index) {
                return Card(
                  child: ListTile(
                    title: Text(_filme[index]['title']),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Aliniază textul la stânga
                        children: <Widget>[
                          Text('Descriere ${_filme[index]['mesaj']}'),
                          Text('Link ${_filme[index]['link']}'),
                          Text('Vizionat ${_filme[index]['vizionat']}'),
                        ]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(_filme[index]['likes']
                              ? Icons.thumb_up
                              : Icons.thumb_up_alt_outlined),
                          onPressed: () => _toggleLike(index),
                          color: _filme[index]['likes'] ? Colors.purple : null,
                        ),
                        IconButton(
                          icon: Icon(_filme[index]['interested']
                              ? Icons.star
                              : Icons.star_border),
                          onPressed: () => _toggleInterested(index),
                          color:
                              _filme[index]['interested'] ? Colors.amber : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
