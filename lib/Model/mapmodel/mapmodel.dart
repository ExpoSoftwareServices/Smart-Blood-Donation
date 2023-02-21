// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'mapmodel.g.dart';

@JsonSerializable()
class Mapdata {
  String? city;
  String? lat;
  String? lng;
  String? country;
  String? iso2;
  String? admin_name;
  String? capital;
  String? population;
  String? population_proper;
  Mapdata({
    this.city,
    this.lat,
    this.lng,
    this.country,
    this.iso2,
    this.admin_name,
    this.capital,
    this.population,
    this.population_proper,
  });

  factory Mapdata.fromJson(Map<String, dynamic> json) =>
      _$MapdataFromJson(json);

  @override
  String toString() {
    return 'city: $city, lat: $lat, lng: $lng, country: $country, iso2: $iso2, admin_name: $admin_name, capital: $capital, population: $population, population_proper: $population_proper';
  }
}
