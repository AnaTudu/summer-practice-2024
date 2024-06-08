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
        backgroundColor: Colors.purple,
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
            padding: const EdgeInsets.all(8), // Add padding around the list
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> film =
                  document.data()! as Map<String, dynamic>;
              String titlu = film['title'] ?? 'Titlu necunoscut';
              String descriere = film['mesaj'] ?? 'Descriere indisponibilă';
              String link = film['link'] ?? 'Link indisponibil';
              String vizionat = film['vizionat'] ?? 'Status necunoscut';
              return Card(
                // Use Card for each film entry
                elevation: 5, // Shadow effect
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: ListTile(
                  title: Text(titlu,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0), // Padding for better spacing
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Descriere: $descriere'),
                        const SizedBox(height: 4),
                        Text('Link: $link'),
                        Text('Vizionat: $vizionat'),
                      ],
                    ),
                  ),
                  trailing: Wrap(
                    spacing: 12, // Space between icons
                    children: [
                      IconButton(
                        icon: Icon(film['likes']
                            ? Icons.thumb_up
                            : Icons.thumb_up_alt_outlined),
                        onPressed: () =>
                            _toggleLike(document.id, film['likes']),
                        color: film['likes'] ? Colors.green : null,
                      ),
                      IconButton(
                        icon: Icon(film['interested']
                            ? Icons.star
                            : Icons.star_border),
                        onPressed: () =>
                            _toggleInterested(document.id, film['interested']),
                        color: film['interested'] ? Colors.amber : null,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
