// models/event_model.dart
class EventModel {
  final String title;
  final String description;
  final String date;
  final String imagePath;
  final String category;
  bool isFavorite;

  EventModel({
    required this.title,
    required this.description,
    required this.date,
    required this.imagePath,
    required this.category,
    this.isFavorite = false,
  });
}