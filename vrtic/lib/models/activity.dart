class Activity{
  const Activity({
    required this.title,
    required this.description,
    required this.timestamp,
  });
  final String title;
  final String description;
  final int timestamp;

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'timestamp': timestamp,
  };
}