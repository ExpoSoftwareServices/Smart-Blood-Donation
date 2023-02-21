// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'requestmodel.g.dart';
@JsonSerializable()
class Request {
  String? name;
  String? mobile;
  String? superuser;
  String? location;
  int? dist;
  String? bloodgroup;
  bool? charges;
  bool? accomodation;
  String? date;
  String? time;
  String? status;
  String? mtoken;
  bool? isdonated;
  String? receivedfrom;
  Request({
    this.name,
    this.mobile,
    this.superuser,
    this.location,
    this.dist,
    this.bloodgroup,
    this.charges,
    this.accomodation,
    this.date,
    this.time,
    this.status,
    this.mtoken,
    this.isdonated,
    this.receivedfrom
  });
  factory Request.fromJson(Map<String,dynamic> json) => _$RequestFromJson(json);
  Map<String,dynamic> toJson()=> _$RequestToJson(this);

  @override
  String toString() {
    return 'name: $name, mobile: $mobile, superuser: $superuser, location: $location, dist: $dist, bloodgroup: $bloodgroup, charges: $charges, accomodation: $accomodation, date: $date, time: $time, status: $status, mtoken: $mtoken, isdonated: $isdonated,receivedfrom $receivedfrom';
  }
}
