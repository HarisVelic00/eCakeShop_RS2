import 'package:json_annotation/json_annotation.dart';
part 'vrstaproizvoda.g.dart';

@JsonSerializable()
class VrstaProizvoda {
  int? vrstaproizvodaID;
  String? naziv;
  String? opis;

  VrstaProizvoda({
    this.vrstaproizvodaID,
    this.naziv,
    this.opis,
  });

  factory VrstaProizvoda.fromJson(Map<String, dynamic> json) =>
      _$VrstaProizvodaFromJson(json);

  Map<String, dynamic> toJson() => _$VrstaProizvodaToJson(this);
}
