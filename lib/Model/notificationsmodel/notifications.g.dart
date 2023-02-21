// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notifications _$NotificationFromJson(Map<String, dynamic> json) => Notifications(
      name: json['name'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
      param: json['param'] as String?
    );

Map<String, dynamic> _$NotificationToJson(Notifications instance) =>
    <String, dynamic>{
      'name': instance.name,
      'date': instance.date,
      'time': instance.time,
      'param':instance.param
    };
