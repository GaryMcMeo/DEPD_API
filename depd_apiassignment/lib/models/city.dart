part of 'models.dart';

class City extends Equatable {
  final String? cityId;
  final String? provinceId;
  final String? province;
  final String? type;
  final String? cityName;
  final String? postalCode;

  const City({
    this.cityId,
    this.provinceId,
    this.province,
    this.type,
    this.cityName,
    this.postalCode,
  });

  factory City.fromMap(Map<String, dynamic> data) => City(
        cityId: data['city_id'] as String?,
        provinceId: data['province_id'] as String?,
        province: data['province'] as String?,
        type: data['type'] as String?,
        cityName: data['city_name'] as String?,
        postalCode: data['postal_code'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'city_id': cityId,
        'province_id': provinceId,
        'province': province,
        'type': type,
        'city_name': cityName,
        'postal_code': postalCode,
      };

  factory City.fromJson(String data) {
    return City.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      cityId,
      provinceId,
      province,
      type,
      cityName,
      postalCode,
    ];
  }
}
