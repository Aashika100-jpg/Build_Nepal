class User {
  final String name;
  final String passportNumber;
  final String location;
  final DateTime visaValidUntil;

  User({
    required this.name,
    required this.passportNumber,
    required this.location,
    required this.visaValidUntil,
  });
}

final usersDatabase = {
  '1234567': User(
    name: 'Romeo Asara',
    passportNumber: '1234567',
    location: 'Italy',
    visaValidUntil: DateTime(2027, 10, 10),
  ),
  '1234988': User(
    name: 'Semro Askas',
    passportNumber: '1234988',
    location: 'Spain',
    visaValidUntil: DateTime(2026, 12, 10),
  ),
  '122212': User(
    name: 'Saksajsa Isaoa',
    passportNumber: '122212',
    location: 'France',
    visaValidUntil: DateTime(2027, 12, 12),
  ),
};
