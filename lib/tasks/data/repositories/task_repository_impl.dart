// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../core/entities/task.dart';
// import '../../core/repositories/task_repository.dart';
// class TaskRepositoryImpl implements TaskRepository {
//   final FirebaseFirestore _firestore;

//   TaskRepositoryImpl(this._firestore);

//   @override
//   Future<void> create(Task task) async {
//     await _firestore.collection('tasks').add({
//       'title': task.title,
//       'description': task.description,
//       'category': task.category,
//       'dueDate': task.dueDate,
//       'createdAt': task.createdAt,
//     });
//   }

//   @override
//   Future<void> delete(String id) async {
//     await _firestore.collection('tasks').doc(id).delete();
//   }

//   @override
//   Stream<List<Task>> getAll() {
//     return _firestore.collection('tasks').snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         final data = doc.data();
//         return Task(
//           userId: doc.id,
//           title: data['title'] ?? '',
//           description: data['description'] ?? '',
//           category: data['category'] ?? '',
//           dueDate: data['dueDate']?.toString() ?? Timestamp.now(),
//           createdAt: data['createdAt'] ?? Timestamp.now(),
//           status: data['status'] ?? false,
//         );
//       }).toList();
//     });
//   }

//   @override
//   Future<void> update(Task task) async {
//     await _firestore.collection('tasks').doc(task.userId).update({
//       'title': task.title,
//       'description': task.description,
//       'category': task.category,
//       'dueDate': task.dueDate,
//       'createdAt': task.createdAt,
//       'status': task.status,
//     });
//   }


//   @override
//   Future<Task> getById(String id) async {
//     DocumentSnapshot<Map<String, dynamic>> doc =
//         await _firestore.collection('tasks').doc(id).get();
//     final data = doc.data()!;
//     return Task(
//       userId: doc.id,
//       title: data['title'] ?? '',
//       description: data['description'] ?? '',
//       category: data['category'] ?? '',
//       dueDate: data['dueDate'] ?? Timestamp.now(),
//       createdAt: data['createdAt'] ?? Timestamp.now(),
//       status: data['status'] ?? false,
//     );
//   }

//   @override
//   Stream<List<Task>> findByStatusAndCategory(bool status, String category) {
//     return _firestore
//         .collection('tasks')
//         .where('status', isEqualTo: status)
//         .where('category', isEqualTo: category)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         final data = doc.data();
//         return Task(
//           userId: doc.id,
//           title: data['title'] ?? '',
//           description: data['description'] ?? '',
//           category: data['category'] ?? '',
//           dueDate: data['dueDate'] ?? Timestamp.now(),
//           createdAt: data['createdAt'] ?? Timestamp.now(),
//           status: data['status'] ?? false,
//         );
//       }).toList();
//     });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/entities/task.dart';
import '../../core/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepositoryImpl(this._firestore);

  @override
  Future<void> create(Task task) async {
    await _firestore.collection('tasks').add({
      'title': task.title,
      'description': task.description,
      'category': task.category,
      'dueDate': task.dueDate,
      'createdAt': task.createdAt,
      'status': task.status,
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
          userId: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          // 🔧 Sửa lỗi: chuyển từ toString() → ép kiểu chính xác về Timestamp
          dueDate: (data['dueDate'] is Timestamp)
              ? data['dueDate'] as Timestamp
              : Timestamp.now(),
          createdAt: (data['createdAt'] is Timestamp)
              ? data['createdAt'] as Timestamp
              : Timestamp.now(),
          status: data['status'] ?? false,
        );
      }).toList();
    });
  }

  @override
  Future<void> update(Task task) async {
    await _firestore.collection('tasks').doc(task.userId).update({
      'title': task.title,
      'description': task.description,
      'category': task.category,
      'dueDate': task.dueDate,
      'createdAt': task.createdAt,
      'status': task.status,
    });
  }

  @override
  Future<Task> getById(String id) async {
    final doc = await _firestore.collection('tasks').doc(id).get();
    final data = doc.data();

    if (data == null) {
      throw Exception('Task with id $id not found');
    }

    return Task(
      userId: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      dueDate: (data['dueDate'] is Timestamp)
          ? data['dueDate'] as Timestamp
          : Timestamp.now(),
      createdAt: (data['createdAt'] is Timestamp)
          ? data['createdAt'] as Timestamp
          : Timestamp.now(),
      status: data['status'] ?? false,
    );
  }

  @override
  Stream<List<Task>> findByStatusOrCategory(bool status, String category) async* {
    final statusStream = _firestore
        .collection('tasks')
        .where('status', isEqualTo: status)
        .snapshots();

    final categoryStream = _firestore
        .collection('tasks')
        .where('category', isEqualTo: category)
        .snapshots();

    await for (final statusSnapshot in statusStream) {
      final categorySnapshot = await categoryStream.first;
      if (category.isEmpty) {
        // Nếu category rỗng, chỉ trả về kết quả theo status
        yield statusSnapshot.docs.map((doc) {
          final data = doc.data();
          return Task(
            userId: doc.id,
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            category: data['category'] ?? '',
            dueDate: (data['dueDate'] is Timestamp)
                ? data['dueDate'] as Timestamp
                : Timestamp.now(),
            createdAt: (data['createdAt'] is Timestamp)
                ? data['createdAt'] as Timestamp
                : Timestamp.now(),
            status: data['status'] ?? false,
          );
        }).toList();
        continue;
      }
      // Gộp 2 danh sách và loại bỏ trùng lặp theo ID
      final allDocs = {
        for (var doc in [...statusSnapshot.docs, ...categorySnapshot.docs])
          doc.id: doc
      };

      yield allDocs.values.map((doc) {
        final data = doc.data();
        return Task(
          userId: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          dueDate: (data['dueDate'] is Timestamp)
              ? data['dueDate'] as Timestamp
              : Timestamp.now(),
          createdAt: (data['createdAt'] is Timestamp)
              ? data['createdAt'] as Timestamp
              : Timestamp.now(),
          status: data['status'] ?? false,
        );
      }).toList();
    }
  }
}
