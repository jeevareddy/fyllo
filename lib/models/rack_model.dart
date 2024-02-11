import 'dart:convert';

class RackModel {
  final String city;
  final int createdTime;
  final String address;
  final int updatedTime;
  final int id;
  final bool isEnabled;
  final double lat;
  final double lng;
  RackModel({
    required this.city,
    required this.createdTime,
    required this.address,
    required this.updatedTime,
    required this.id,
    required this.isEnabled,
    required this.lat,
    required this.lng,
  });

  RackModel copyWith({
    String? city,
    int? createdTime,
    String? address,
    int? updatedTime,
    int? id,
    bool? isEnabled,
    double? lat,
    double? lng,
  }) {
    return RackModel(
      city: city ?? this.city,
      createdTime: createdTime ?? this.createdTime,
      address: address ?? this.address,
      updatedTime: updatedTime ?? this.updatedTime,
      id: id ?? this.id,
      isEnabled: isEnabled ?? this.isEnabled,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'createdTime': createdTime,
      'address': address,
      'updatedTime': updatedTime,
      'id': id,
      'isEnabled': isEnabled,
      'lat': lat,
      'lng': lng,
    };
  }

  factory RackModel.fromMap(Map<String, dynamic> map) {
    return RackModel(
      city: map['city'] ?? '',
      createdTime: map['createdTime']?.toInt() ?? 0,
      address: map['address'] ?? '',
      updatedTime: map['updatedTime']?.toInt() ?? 0,
      id: map['id']?.toInt() ?? 0,
      isEnabled: map['isEnabled'] ?? false,
      lat: map['lat']?.toDouble() ?? 0.0,
      lng: map['lng']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RackModel.fromJson(String source) => RackModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Rack(city: $city, createdTime: $createdTime, address: $address, updatedTime: $updatedTime, id: $id, isEnabled: $isEnabled, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RackModel &&
      other.city == city &&
      other.createdTime == createdTime &&
      other.address == address &&
      other.updatedTime == updatedTime &&
      other.id == id &&
      other.isEnabled == isEnabled &&
      other.lat == lat &&
      other.lng == lng;
  }

  @override
  int get hashCode {
    return city.hashCode ^
      createdTime.hashCode ^
      address.hashCode ^
      updatedTime.hashCode ^
      id.hashCode ^
      isEnabled.hashCode ^
      lat.hashCode ^
      lng.hashCode;
  }
}