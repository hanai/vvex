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

class TopicReply {
  String avatar;
  String memberName;
  String content;

  TopicReply(
      {required this.avatar, required this.memberName, required this.content});
}
