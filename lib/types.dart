class Topic {
  int id;
  String title;
  String? link;
  int replies;
  String author;
  String avatar;
  String? content;

  Topic(
      {required this.id,
      required this.title,
      this.link,
      required this.replies,
      required this.author,
      required this.avatar,
      this.content});
}

class TopicData {
  int id;
  String title;
  String content;
  int createdAt;
  MemberData member;
  int replyCount;
  int? lastReplyAt;
  List<SubtleData> subtles;

  TopicData(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAt,
      required this.member,
      required this.replyCount,
      this.lastReplyAt,
      required this.subtles});
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

  ReplyData({
    required this.content,
    required this.createdAt,
    required this.member,
  });
}
