// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registermodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Register _$RegisterFromJson(Map<String, dynamic> json) => Register(
      email: json['email'] as String?,
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
      gender: json['gender'] as String?,
      bloodgroup: json['bloodgroup'] as String?,
      password: json['password'] as String?,
      superuser: json['superuser'] as String?,
      location: json['location'] as String?,
      state: json['state'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      long: (json['long'] as num?)?.toDouble(),
      address: json['address'] as String?,
      mtoken: json['mtoken'] as String?,
      isdonated: json['isdonated'] as bool?,
      rewardpoints: json['rewardpoints'] as int?,
      donateddate: json['donateddate'] as Timestamp?
    );

Map<String, dynamic> _$RegisterToJson(Register instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'mobile': instance.mobile,
      'gender': instance.gender,
      'bloodgroup': instance.bloodgroup,
      'password': instance.password,
      'superuser': instance.superuser,
      'location': instance.location,
      'state': instance.state,
      'lat': instance.lat,
      'long': instance.long,
      'address': instance.address,
      'mtoken':instance.mtoken,
      'isdonated':instance.isdonated,
      'rewardpoints':instance.rewardpoints,
      'donateddate':instance.donateddate
    };
