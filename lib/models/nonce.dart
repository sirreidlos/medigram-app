class Nonce {
  final String nonce;
  final DateTime expirationDate;

  Nonce({required this.nonce, required this.expirationDate});

  factory Nonce.fromJson(Map<String, dynamic> json) {
    return Nonce(nonce: json["nonce"], expirationDate: DateTime.parse(json["expiration_date"]));
  }
}
