class User {
  final String userID;
  final String email;

  User({required this.userID, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(userID: json["user_id"], email: json["email"]);
  }
}
