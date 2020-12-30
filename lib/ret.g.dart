// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reply _$ReplyFromJson(Map<String, dynamic> json) {
  return Reply(
    json['content'] as String,
    json['created'] as int,
    json['id'] as int,
    json['last_modified'] as int,
    Member.fromJson(json['member'] as Map<String, dynamic>),
    json['topic_id'] as int,
    json['member_id'] as int,
  );
}

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
      'content': instance.content,
      'created': instance.created,
      'id': instance.id,
      'last_modified': instance.lastModified,
      'member': instance.member,
      'member_id': instance.memberId,
      'topic_id': instance.topicId,
    };

Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
    json['avatar_large'] as String,
    json['avatar_mini'] as String,
    json['avatar_normal'] as String,
    json['created'] as int,
    json['id'] as int,
    json['github'] as String?,
    json['username'] as String,
  );
}

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'avatar_large': instance.avatarLarge,
      'avatar_mini': instance.avatarMini,
      'avatar_normal': instance.avatarNormal,
      'created': instance.created,
      'id': instance.id,
      'github': instance.github,
      'username': instance.username,
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
