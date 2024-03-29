class DriverDetails {
  String fullName;
  String phoneNumber;
  String? userid;
  bool? isDocumentSubmitted;
  bool? isVerified;
  bool? isVerifiedBannerShown;
  bool? isBlocked;
  Map<String, dynamic>? kycData;

  DriverDetails(
      {required this.fullName,
      required this.phoneNumber,
      this.userid,
      this.isDocumentSubmitted,
      this.isVerified,
      this.isVerifiedBannerShown,
      this.isBlocked,
      this.kycData});

  // Implement the toJson method to convert the object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': fullName,
      'phone': phoneNumber,
      'userid': userid,
      'isDocumentSubmitted': isDocumentSubmitted,
      'isVerified': isVerified,
      'isVerifiedBannerShown': isVerifiedBannerShown,
      'isBlocked': isBlocked,
      'kycData': kycData
    };
  }

  // Implement a factory method to create a DriverDetails object from a JSON map
  factory DriverDetails.fromJson(Map<String, dynamic> json) {
    return DriverDetails(
        fullName: json['name'],
        phoneNumber: json['phone'],
        userid: json['userid'],
        isDocumentSubmitted: json['isDocumentSubmitted'],
        isVerified: json['isVerified'],
        isVerifiedBannerShown: json['isVerifiedBannerShown'],
        isBlocked: json['isBlocked'],
        kycData: json['kycData']);
  }
}
