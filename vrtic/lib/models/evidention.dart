class Evidention{
  Evidention({
    required this.timestamp,
    required this.children
  });
  final int timestamp;
  late List<dynamic> children = []; 

  Map<String, dynamic> toMap() => {
    'timestamp': timestamp,
    'children': children
  };
}