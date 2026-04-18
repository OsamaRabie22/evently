import 'package:evently_1/helpers/firestore_helper.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class AddEventProvider extends ChangeNotifier {
  List<String> categories = [
    "Book Club",
    "Sport",
    "Birthday",
    "Exhibition",
    "Meeting",
  ];

  int selectedCategoryIndex = 0;
  bool isLoading = false;

  void changeCategory(int index) {
    selectedCategoryIndex = index;
    notifyListeners();
  }
  void setInitialCategory(String category) {
    final index = categories.indexOf(category);
    if (index != -1) {
      selectedCategoryIndex = index;
      notifyListeners();
    }
  }
  Future<void> addEvent(TaskModel taskModel) async {
    isLoading = true;
    notifyListeners();

    try {
      await FirestoreHelper.createTask(taskModel);
    } catch (e) {
      rethrow; // هيتمسك في الـ UI
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}