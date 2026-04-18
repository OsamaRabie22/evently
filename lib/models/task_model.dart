class TaskModel {
  String title;
  String description;
  String category;
  int date;
  String id;
  bool isFavorite;

  TaskModel({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.id = "",
    this.isFavorite = false,
  });

  TaskModel.fromJson(Map<String, dynamic> json)
      : this(
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    category: json['category'] ?? '',
    date: json['date'] ?? 0,
    id: json['id'] ?? '',
    isFavorite: json['isFavorite'] ?? false,
  );

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "category": category,
      "date": date,
      "id": id,
      "isFavorite": isFavorite,
    };
  }
}