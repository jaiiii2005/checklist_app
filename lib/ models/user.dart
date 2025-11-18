class AppUser {
  String uid;
  String name;
  String email;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
  };

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
