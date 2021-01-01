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
    json['website'] as String?,
  );
}

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'avatar_large': instance.avatarLarge,
      'avatar_mini': instance.avatarMini,
      'avatar_normal': instance.avatarNormal,
      'created': instance.created,
      'id': instance.id,
      'github': instance.github,
      'website': instance.website,
      'username': instance.username,
    };

Topic _$TopicFromJson(Map<String, dynamic> json) {
  return Topic(
    json['id'] as int,
    Member.fromJson(json['member'] as Map<String, dynamic>),
    json['content'] as String,
    json['title'] as String,
    Node.fromJson(json['node'] as Map<String, dynamic>),
    json['replies'] as int,
    json['created'] as int,
    json['last_reply_by'] as String,
    json['last_touched'] as int,
  );
}

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'content': instance.content,
      'member': instance.member,
      'title': instance.title,
      'node': instance.node,
      'replies': instance.replies,
      'id': instance.id,
      'created': instance.created,
      'last_reply_by': instance.lastReplyBy,
      'last_touched': instance.lastTouched,
    };

Node _$NodeFromJson(Map<String, dynamic> json) {
  return Node(
    json['id'] as int,
    json['avatar_mini'] as String,
    json['avatar_normal'] as String,
    json['avatar_large'] as String,
    json['name'] as String,
    json['title'] as String,
    json['topics'] as int,
    json['header'] as String,
    json['footer'] as String,
    json['title_alternative'] as String,
    json['root'] as bool,
    json['stars'] as int,
    json['parent_node_name'] as String,
  );
}

Map<String, dynamic> _$NodeToJson(Node instance) => <String, dynamic>{
      'avatar_mini': instance.avatarMini,
      'avatar_normal': instance.avatarNormal,
      'avatar_large': instance.avatarLarge,
      'name': instance.name,
      'title': instance.title,
      'topics': instance.topics,
      'header': instance.header,
      'footer': instance.footer,
      'title_alternative': instance.titleAlternative,
      'stars': instance.stars,
      'root': instance.root,
      'id': instance.id,
      'parent_node_name': instance.parentNodeName,
    };
