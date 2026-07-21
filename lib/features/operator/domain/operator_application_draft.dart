import "dart:io";

class OperatorApplicationDraft {
  final String fullLegalName;
  final String? fullLegalNameAr;
  final String country;
  final DateTime dateOfBirth;
  final String idType; // 'cin' or 'passport'
  final String idNumber;
  final File? idFrontImage;
  final File? idBackImage;
  const OperatorApplicationDraft({
    required this.fullLegalName,
    this.fullLegalNameAr,
    required this.country,
    required this.dateOfBirth,
    required this.idType,
    required this.idNumber,
    this.idFrontImage,
    this.idBackImage,
  });

  OperatorApplicationDraft copyWith({File? idFrontImage, File? idBackImage}) {
    return OperatorApplicationDraft(
      fullLegalName: fullLegalName,
      fullLegalNameAr: fullLegalNameAr,
      country: country,
      dateOfBirth: dateOfBirth,
      idType: idType,
      idNumber: idNumber,
      idFrontImage: idFrontImage ?? this.idFrontImage,
      idBackImage: idBackImage ?? this.idBackImage,
    );
  }
}