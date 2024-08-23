part of 'task.dart';

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      key: json['key'] as String,
      value: json['value'] as String,
      id: json['is'] as int,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'id': instance.id,
    };
