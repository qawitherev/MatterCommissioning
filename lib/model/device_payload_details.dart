class DevicePayloadDetails {
  final dynamic vers, setupPCode, serNum, discriminator, prodId, vendId;

  DevicePayloadDetails(
      {required this.discriminator,
        required this.prodId,
        required this.serNum,
        required this.setupPCode,
        required this.vendId,
        required this.vers});

  factory DevicePayloadDetails.fromJson(Map<String, dynamic> json) {
    return DevicePayloadDetails(
        discriminator: json["discriminator"],
        prodId: json["prodId"],
        serNum: json["serNum"],
        setupPCode: json["setupPCode"],
        vendId: json["vendId"],
        vers: json["vers"]);
  }
}
