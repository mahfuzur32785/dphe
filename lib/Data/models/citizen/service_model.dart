class ServiceModel {
  final int id;
  final String title;

  ServiceModel({required this.id, required this.title});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceModel && other.id == id && other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
