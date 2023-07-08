class UserChild{
  const UserChild({
    required this.uid,
    required this.name,
    required this.surname,
    required this.sex,
  });
  final String uid;
  final String name;
  final String surname;
  final int sex;

  Map<String, dynamic> getMap() => {
    'uid': uid,
    'name': name,
    'surname': surname,
    'sex': sex
  };
}