import 'package:json_annotation/json_annotation.dart';
part 'slika.g.dart';

@JsonSerializable()
class Slika {
  int? slikaID;
  String? slikaByte;
  String? opis;

  Slika({
    this.slikaID,
    this.slikaByte,
    this.opis,
  });

  factory Slika.fromJson(Map<String, dynamic> json) => _$SlikaFromJson(json);

  Map<String, dynamic> toJson() => _$SlikaToJson(this);
}
