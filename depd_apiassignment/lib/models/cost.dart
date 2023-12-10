part of 'models.dart';

class Cost {
  final int value;
  final String etd;
  final String note;

  Cost({
    required this.value,
    required this.etd,
    required this.note,
  });

  factory Cost.fromRawJson(String str) => Cost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cost.fromJson(Map<String, dynamic> json) => Cost(
        value: json["value"],
        etd: json["etd"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "etd": etd,
        "note": note,
      };
}
