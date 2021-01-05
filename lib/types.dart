class Topic {
  int id;
  String title;
  int replies;
  String author;
  String avatar;
  String? content;

  Topic(
      {required this.id,
      required this.title,
      required this.replies,
      required this.author,
      required this.avatar,
      this.content});
}

class TopicData {
  int id;
  String title;
  String? content;
  int? createdAt;
  MemberData member;
  int replyCount;
  List<SubtleData>? subtles;
  int replyPageCount;
  List<String>? tags;
  String? node;
  String? lastReplyBy;
  int? lastReplyAt;

  TopicData(
      {required this.id,
      required this.title,
      this.content,
      this.createdAt,
      required this.member,
      required this.replyCount,
      this.subtles,
      this.tags,
      this.node,
      this.replyPageCount = 0,
      this.lastReplyAt,
      this.lastReplyBy});
}

class SubtleData {
  String content;
  int createdAt;
  SubtleData({required this.content, required this.createdAt});
}

class MemberData {
  String avatar;
  String username;

  MemberData({required this.avatar, required this.username});
}

class ReplyData {
  int createdAt;
  MemberData member;
  String content;
  int floor;

  ReplyData({
    required this.content,
    required this.createdAt,
    required this.member,
    required this.floor,
  });
}
