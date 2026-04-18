import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evently_1/models/task_model.dart';

class FirestoreHelper {
  // مسار events الـ user الحالي
  static CollectionReference<TaskModel> getTasksCollection() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection("Tasks")
        .doc(uid)
        .collection("events")
        .withConverter<TaskModel>(
      fromFirestore: (snapshot, _) =>
          TaskModel.fromJson({...snapshot.data()!, 'id': snapshot.id}),
      toFirestore: (value, _) => value.toJson(),
    );
  }

  // إضافة event جديد
  static Future<void> createTask(TaskModel task) {
    final collection = getTasksCollection();
    final doc = collection.doc();
    task.id = doc.id;
    return doc.set(task);
  }

  // Stream لـ real-time updates (كل الـ events)
  static Stream<QuerySnapshot<TaskModel>> getTasksStream() {
    return getTasksCollection().snapshots();
  }

  // Stream للـ favorites فقط
  static Stream<QuerySnapshot<TaskModel>> getFavoritesStream() {
    return getTasksCollection()
        .where('isFavorite', isEqualTo: true)
        .snapshots();
  }

  // toggle favorite
  static Future<void> toggleFavorite(String id, bool currentValue) {
    return getTasksCollection()
        .doc(id)
        .update({'isFavorite': !currentValue});
  }

  // حذف event
  static Future<void> deleteTask(String id) {
    return getTasksCollection().doc(id).delete();
  }

  // تعديل event
  static Future<void> updateTask(TaskModel task) {
    return getTasksCollection().doc(task.id).update(task.toJson());
  }
}