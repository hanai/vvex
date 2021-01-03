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
  int createdAt;
  MemberData member;
  int replyCount;
  int? lastReplyAt;
  List<SubtleData> subtles;
  int replyPageCount;

  TopicData(
      {required this.id,
      required this.title,
      this.content,
      required this.createdAt,
      required this.member,
      required this.replyCount,
      this.lastReplyAt,
      required this.subtles,
      this.replyPageCount = 0});
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
