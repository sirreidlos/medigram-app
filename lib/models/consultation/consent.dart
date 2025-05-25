class Consent {
  final String signerDeviceID;
  final String nonce;
  final String signature;

  Consent({
    required this.signerDeviceID,
    required this.nonce,
    required this.signature,
  });

  factory Consent.fromJson(Map<String, dynamic> json) {
    return Consent(
      signerDeviceID: json['signer_device_id'],
      nonce: json['nonce'],
      signature: json['signature'],
    );
  }

  Map<String, dynamic> toJson() => {
    "signer_device_id": signerDeviceID,
    "nonce": nonce,
    "signature": signature,
  };
}
