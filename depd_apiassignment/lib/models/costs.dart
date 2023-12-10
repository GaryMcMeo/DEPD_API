part of 'models.dart';

class Costs {
  final String service;
  final String description;
  final List<Cost> cost;

  Costs({
    required this.service,
    required this.description,
    required this.cost,
  });

  factory Costs.fromRawJson(String str) => Costs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Costs.fromJson(Map<String, dynamic> json) => Costs(
        service: json["service"],
        description: json["description"],
        cost: List<Cost>.from(json["cost"].map((x) => Cost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service": service,
        "description": description,
        "cost": List<dynamic>.from(cost.map((x) => x.toJson())),
      };
}
