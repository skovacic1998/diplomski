class Child{
  const Child({
    required this.name,
    required this.surname,
    required this.sex,
  });
  final String name;
  final String surname;
  final int sex;

  Map<String, dynamic> getMap() => {
    'name': name,
    'surname': surname,
    'sex': sex
  };

  Map<String,dynamic> toJson() => {
        'name': name,
        'surname': surname,
        'sex': sex
      };
}