class UserDetail {
  final String userID;
  final int nik;
  final String name;
  final DateTime dob;
  final String gender;

  UserDetail({
    required this.userID,
    required this.nik,
    required this.name,
    required this.dob,
    required this.gender,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      userID: json["user_id"],
      nik: json["nik"],
      name: json["name"],
      dob: DateTime.parse(json["dob"]),
      gender: json["gender"],
    );
  }
}
