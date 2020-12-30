import 'package:json_annotation/json_annotation.dart';

part 'ret.g.dart';

@JsonSerializable()
class Reply {
  String content;
  int created;
  int id;
  @JsonKey(name: 'last_modified')
  int lastModified;
  Member member;
  @JsonKey(name: 'member_id')
  int memberId;
  @JsonKey(name: 'topic_id')
  int topicId;

  Reply(this.content, this.created, this.id, this.lastModified, this.member,
      this.topicId, this.memberId);

  factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);
  Map<String, dynamic> toJson() => _$ReplyToJson(this);
}

@JsonSerializable()
class Member {
  @JsonKey(name: 'avatar_large')
  String avatarLarge;

  @JsonKey(name: 'avatar_mini')
  String avatarMini;

  @JsonKey(name: 'avatar_normal')
  String avatarNormal;

  int created;
  int id;
  String? github;
  String username;

  Member(this.avatarLarge, this.avatarMini, this.avatarNormal, this.created,
      this.id, this.github, this.username);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}

@JsonSerializable()
class Topic {
  String content;
  Member member;

  Topic(this.member, this.content);

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}
