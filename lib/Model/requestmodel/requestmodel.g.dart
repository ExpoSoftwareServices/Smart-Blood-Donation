// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requestmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) => Request(
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
      superuser: json['superuser'] as String?,
      location: json['location'] as String?,
      dist: json['dist'] as int?,
      bloodgroup: json['bloodgroup'] as String?,
      charges: json['charges'] as bool?,
      accomodation: json['accomodation'] as bool?,
      date: json['date'] as String?,
      time: json['time'] as String?,
      status: json['status'] as String?,
      mtoken: json['mtoken'] as String?,
      isdonated: json['isdonated'] as bool?,
      receivedfrom: json['receivedfrom'] as String?
    );

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
      'name': instance.name,
      'mobile': instance.mobile,
      'superuser': instance.superuser,
      'location': instance.location,
      'dist': instance.dist,
      'bloodgroup': instance.bloodgroup,
      'charges': instance.charges,
      'accomodation': instance.accomodation,
      'date': instance.date,
      'time': instance.time,
      'status': instance.status,
      'mtoken':instance.mtoken,
      'isdonated':instance.isdonated,
      'receivedfrom':instance.receivedfrom
    };
