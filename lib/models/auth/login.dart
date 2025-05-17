class Login {
  final String sessionID;
  final String tokenType;
  final String deviceID;
  final String privateKey;

  Login({
    required this.sessionID,
    required this.tokenType,
    required this.deviceID,
    required this.privateKey,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      sessionID: json["session_id"],
      tokenType: json["token_type"],
      deviceID: json["device_id"],
      privateKey: json["private_key"],
    );
  }
}
