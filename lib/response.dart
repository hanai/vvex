import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class Reply {
  String content;
  Member member;
  @JsonKey(name: 'topic_id')
  int topicId;

  Reply(this.content, this.member, this.topicId);

  factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);
  Map<String, dynamic> toJson() => _$ReplyToJson(this);
}

@JsonSerializable()
class Member {
  String username;

  @JsonKey(name: 'avatar_large')
  String avatarLarge;

  @JsonKey(name: 'avatar_mini')
  String avatarMini;

  @JsonKey(name: 'avatar_normal')
  String avatarNormal;

  Member(this.avatarLarge, this.avatarMini, this.avatarNormal, this.username);

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
