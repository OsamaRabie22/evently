import 'package:flutter/material.dart';
import '../models/task_model.dart';

class HomePageProvider extends ChangeNotifier {
  List<String> categories = [
    "All",
    "Sport",
    "Birthday",
    "Meeting",
    "Exhibition",
    "Book Club",
  ];

  int selectedCategoryIndex = 0;

  void changeCategory(int index) {
    selectedCategoryIndex = index;
    notifyListeners();
  }

  // بياخد الـ events من Firebase ويفلترها
  List<TaskModel> filterEvents(List<TaskModel> allEvents) {
    if (selectedCategoryIndex == 0) return allEvents;
    return allEvents
        .where((e) => e.category == categories[selectedCategoryIndex])
        .toList();
  }
}