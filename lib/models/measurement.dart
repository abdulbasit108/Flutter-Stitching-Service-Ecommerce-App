import 'dart:convert';

class Measurement{
  final String id;
  final String profileName;
  final double chestMeasurement;
  final double waistMeasurement;
  final double hipsMeasurement;
  final double inseamMeasurement;
  final double sleeveMeasurement;
  final double shoulderMeasurement;
  final String userId;

  Measurement({
    required this.id, 
    required this.profileName, 
    required this.chestMeasurement, 
    required this.waistMeasurement, 
    required this.hipsMeasurement, 
    required this.inseamMeasurement, 
    required this.sleeveMeasurement, 
    required this.shoulderMeasurement, 
    required this.userId
    });

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileName': profileName,
      'chestMeasurement': chestMeasurement,
      'waistMeasurement': waistMeasurement,
      'hipsMeasurement': hipsMeasurement,
      'inseamMeasurement': inseamMeasurement,
      'sleeveMeasurement': sleeveMeasurement,
      'shoulderMeasurement': shoulderMeasurement,
      'userId': userId,
    };
  }

  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      id: map['_id'] ?? '',
      profileName: map['profileName'] ?? '',
      chestMeasurement: map['chestMeasurement']?.toDouble() ?? 0.0,
      waistMeasurement: map['waistMeasurement']?.toDouble() ?? 0.0,
      hipsMeasurement: map['hipsMeasurement']?.toDouble() ?? 0.0,
      inseamMeasurement: map['inseamMeasurement']?.toDouble() ?? 0.0,
      sleeveMeasurement: map['sleeveMeasurement']?.toDouble() ?? 0.0,
      shoulderMeasurement: map['shoulderMeasurement']?.toDouble() ?? 0.0,
      userId: map['userId'] ?? '',
      
    );
  }

  String toJson() => json.encode(toMap());

  factory Measurement.fromJson(String source) => Measurement.fromMap(json.decode(source));

  



    

}

