import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_app/tasks/core/entities/task.dart';
import 'package:inventory_app/tasks/core/repositories/task_repository.dart';
class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepositoryImpl(this._firestore);

  @override
  Future<void> create(Task task) async {
    await _firestore.collection('tasks').add({
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted,
    });
  }

  @override
  Future<void> delete(String id) async {
    await _firestore.collection('tasks').doc(id).delete();
  }

  @override
  Stream<List<Task>> getAll() {
    return _firestore.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Task(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          isCompleted: data['isCompleted'] ?? false,
        );
      }).toList();
    });
  }

  @override
  Future<void> update(Task task) async {
    await _firestore.collection('tasks').doc(task.id).update({
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted,
    });
  }


  @override
  Future<Task> getById(String id) async {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('tasks').doc(id).get();
    final data = doc.data()!;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  @override
  Stream<List<Task>> findByStatus(bool isCompleted) {
    return _firestore
        .collection('tasks')
        .where('isCompleted', isEqualTo: isCompleted)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Task(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          isCompleted: data['isCompleted'] ?? false,
        );
      }).toList();
    });
  }
}