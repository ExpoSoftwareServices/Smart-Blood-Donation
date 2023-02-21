// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
part 'notifications.g.dart';
@JsonSerializable()
class Notifications{
String? name;
String? date;
String? time;
String? param;
  Notifications({
    this.name,
    this.date,
    this.time,
    this.param
  });
  factory  Notifications.fromJson(Map<String,dynamic> json) => _$NotificationFromJson(json);
  Map<String,dynamic> toJson()=> _$NotificationToJson(this);
  @override
  String toString() => 'name: $name, date: $date, time: $time, param: $param';
}
