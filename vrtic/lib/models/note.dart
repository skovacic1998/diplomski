class Note{
  const Note({
    required this.noteText,
    required this.timestamp,
    required this.child
  });
  final String noteText;
  final int timestamp;
  final Map<String, dynamic>? child;

  Map<String, dynamic> toMap() => {
    'note': noteText,
    'timestamp': timestamp,
    'child': child
  };
}