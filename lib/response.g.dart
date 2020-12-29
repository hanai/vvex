// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reply _$ReplyFromJson(Map<String, dynamic> json) {
  return Reply(
    json['content'] as String,
    Member.fromJson(json['member'] as Map<String, dynamic>),
    json['topic_id'] as int,
  );
}

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
      'content': instance.content,
      'member': instance.member,
      'topic_id': instance.topicId,
    };

Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
    json['avatar_large'] as String,
    json['avatar_mini'] as String,
    json['avatar_normal'] as String,
    json['username'] as String,
  );
}

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'username': instance.username,
      'avatar_large': instance.avatarLarge,
      'avatar_mini': instance.avatarMini,
      'avatar_normal': instance.avatarNormal,
    };

Topic _$TopicFromJson(Map<String, dynamic> json) {
  return Topic(
    Member.fromJson(json['member'] as Map<String, dynamic>),
    json['content'] as String,
  );
}

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'content': instance.content,
      'member': instance.member,
    };
