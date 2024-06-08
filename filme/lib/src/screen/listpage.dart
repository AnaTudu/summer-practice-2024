import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  void _toggleLike(String docId, bool likes) {
    FirebaseFirestore.instance
        .collection('movies')
        .doc(docId)
        .update({'likes': !likes});
  }

  void _toggleInterested(String docId, bool interested) {
    FirebaseFirestore.instance
        .collection('movies')
        .doc(docId)
        .update({'interested': !interested});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filme Adăugate"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("A apărut o eroare!");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> film =
                  document.data()! as Map<String, dynamic>;
              String titlu = film['title'] ?? 'Titlu necunoscut';
              String descriere = film['mesaj'] ?? 'Descriere indisponibilă';
              String link = film['link'] ?? 'Link indisponibil';
              String vizionat = film['vizionat'] ?? 'Status necunoscut';
              return ListTile(
                title: Text(titlu),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Titlu: $titlu'),
                    Text('Descreiere: $descriere'),
                    const SizedBox(height: 4),
                    Text('Link: $link'),
                    Text('Vizionat: $vizionat'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(film['likes']
                          ? Icons.thumb_up
                          : Icons.thumb_up_alt_outlined),
                      onPressed: () => _toggleLike(document.id, film['likes']),
                      color: film['likes'] ? Colors.blue : null,
                    ),
                    IconButton(
                      icon: Icon(
                          film['interested'] ? Icons.star : Icons.star_border),
                      onPressed: () =>
                          _toggleInterested(document.id, film['interested']),
                      color: film['interested']
                          ? const Color.fromARGB(255, 134, 87, 192)
                          : null,
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
