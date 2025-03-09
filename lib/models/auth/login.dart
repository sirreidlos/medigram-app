class Login {
  final String accessToken;
  final String sessionID;
  final String tokenType;
  final int expiresIn;
  final String deviceID;
  final String privateKey;

  Login({
    required this.accessToken,
    required this.sessionID,
    required this.tokenType,
    required this.expiresIn,
    required this.deviceID,
    required this.privateKey,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      accessToken: json["access_token"],
      sessionID: json["session_id"],
      tokenType: json["token_type"],
      expiresIn: json["expires_in"],
      deviceID: json["device_id"],
      privateKey: json["private_key"],
    );
  }
}
