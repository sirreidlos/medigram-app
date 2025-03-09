class Consent {
  final String signerDeviceID;
  final List<int> nonce;
  final String signature;

  Consent({
    required this.signerDeviceID,
    required this.nonce,
    required this.signature,
  });

  Map<String, dynamic> toJson() => {
    "signer_device_id": signerDeviceID,
    "nonce": nonce,
    "signature": signature,
  };
}
