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
  String? website;
  String username;

  Member(this.avatarLarge, this.avatarMini, this.avatarNormal, this.created,
      this.id, this.github, this.username, this.website);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}

@JsonSerializable()
class Topic {
  String content;
  Member member;
  String title;
  Node node;
  int replies;
  int id;
  int created;

  @JsonKey(name: 'last_reply_by')
  String lastReplyBy;
  @JsonKey(name: 'last_touched')
  int lastTouched;

  Topic(this.id, this.member, this.content, this.title, this.node, this.replies,
      this.created, this.lastReplyBy, this.lastTouched);

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}

@JsonSerializable()
class Node {
  @JsonKey(name: 'avatar_mini')
  String avatarMini;
  @JsonKey(name: 'avatar_normal')
  String avatarNormal;
  @JsonKey(name: 'avatar_large')
  String avatarLarge;

  String name;
  String title;

  int topics;

  String header;
  String footer;

  @JsonKey(name: 'title_alternative')
  String titleAlternative;

  int stars;

  bool root;
  int id;
  @JsonKey(name: 'parent_node_name')
  String parentNodeName;

  Node(
      this.id,
      this.avatarMini,
      this.avatarNormal,
      this.avatarLarge,
      this.name,
      this.title,
      this.topics,
      this.header,
      this.footer,
      this.titleAlternative,
      this.root,
      this.stars,
      this.parentNodeName);

  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);
  Map<String, dynamic> toJson() => _$NodeToJson(this);
}
