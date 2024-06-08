import 'package:cloud_firestore/cloud_firestore.dart';

class GroupService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createGroup(
      String groupName, List<String> memberIds, List<String> movieIds) async {
    CollectionReference groups = _db.collection('groups');
    await groups.add({
      'name': groupName,
      'members':
          memberIds.map((id) => _db.collection('users').doc(id)).toList(),
      'movies': movieIds.map((id) => _db.collection('movies').doc(id)).toList(),
    });
  }
}
