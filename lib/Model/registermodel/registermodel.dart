// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'registermodel.g.dart';
@JsonSerializable()
class Register {
  String? email;
  String? name;
  String? mobile;
  String? gender;
  String? bloodgroup;
  String? password;
  String? superuser;
  String? location;
  String? state;
  double? lat;
  double? long;
  String? address;
  String? mtoken;
  bool? isdonated;
  int? rewardpoints;
  Timestamp? donateddate;
  Register({
    this.email,
    this.name,
    this.mobile,
    this.gender,
    this.bloodgroup,
    this.password,
    this.superuser,
    this.location,
    this.state,
    this.lat,
    this.long,
    this.address,
    this.mtoken,
    this.isdonated,
    this.rewardpoints,
    this.donateddate
  });
  factory Register.fromJson(Map<String,dynamic> json)=>_$RegisterFromJson(json);
  Map<String,dynamic> toJson() =>_$RegisterToJson(this);



  @override
  String toString() {
    return 'email: $email, name: $name, mobile: $mobile, gender: $gender, bloodgroup: $bloodgroup, password: $password, superuser: $superuser, location: $location, state: $state, lat: $lat, long: $long, address: $address, mtoken: $mtoken, isdonated: $isdonated, rewardpoints: $rewardpoints, donateddate: $donateddate';
  }
}
