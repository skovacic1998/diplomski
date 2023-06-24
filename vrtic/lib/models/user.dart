class User{
  User({
    required this.username,
    required this.email,
    required this.isParent,
    required this.children,
  });
  final String username;
  final String email;
  final int isParent;
  late List<dynamic> children = [];

  Map<String, dynamic> toMap() => {
    'username': username,
    'email': email,
    'isParent': isParent,
    'children': children
  };
}