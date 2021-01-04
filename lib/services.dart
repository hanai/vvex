import 'dart:io';
import 'dart:typed_data';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:html/parser.dart';
import 'package:vvex/exceptions.dart';
import 'package:vvex/types.dart';
import 'package:vvex/utils/dt.dart' as dt;
import 'package:vvex/utils/html.dart';
import 'package:vvex/utils/http.dart';

Future<bool> signin(Map<String, dynamic> args) {
  final http = new Http();
  return http
      .postForm("https://www.v2ex.com/signin",
          data: args,
          options: Options(
              responseType: ResponseType.plain,
              headers: {
                HttpHeaders.refererHeader: 'https://www.v2ex.com/signin'
              },
              followRedirects: false,
              validateStatus: (status) {
                return status == 200 || status == 302;
              }))
      .then((res) {
    final headersMap = res.headers.map;

    if (headersMap.containsKey('set-cookie')) {
      final vals = headersMap['set-cookie'];
      if (vals != null && vals.length > 1) {
        return true;
      }
    }
    return false;
  });
}

Future<Uint8List> getSigninCaptchaImage(String url) async {
  final http = new Http();
  final res = await http.get(url,
      options: Options(headers: {
        HttpHeaders.acceptHeader:
            'image/avif,image/webp,image/apng,image/*,*/*;q=0.8'
      }, responseType: ResponseType.bytes));

  return res.data;
}

Future<String> getSigninPageHTML() async {
  final http = new Http();
  final html = await http.getHTML(
    'https://www.v2ex.com/signin',
  );
  return html;
}

Future<List<Topic>> getNodeTopics(String node) async {
  final http = new Http();
  final html = await http.getHTML('https://www.v2ex.com/go/' + node);
  var $document = parse(html);
  var $cells = $document.querySelectorAll('#Wrapper .cell');

  var topics = $cells.where(($cell) {
    return $cell.querySelector('.topic-link') != null;
  }).map(($cell) {
    final $topicLink = $cell.querySelector('.topic-link');
    final link = $topicLink.attributes['href']!;
    RegExp reg = new RegExp(r"\/t\/(\d+)[^0-9]+");
    var match = reg.firstMatch(link);
    int topicId = 0;
    if (match != null && match.groupCount > 0) {
      topicId = int.parse(match.group(1)!);
    }
    return Topic(
        id: topicId,
        title: $topicLink.text,
        replies: int.parse($cell.querySelector('.count_livid')?.text ?? '0'),
        author: $cell.querySelector('strong')?.text ?? '',
        avatar: $cell.querySelector('.avatar').attributes['src']!);
  }).toList();

  return topics;
}

Future<List<Topic>> getTabTopics(String tab) async {
  final http = new Http();
  final html = await http.getHTML('https://www.v2ex.com/?tab=' + tab);
  var $document = parse(html);
  var $cells = $document.querySelectorAll('#Wrapper .cell.item');

  var topics = $cells.where(($cell) {
    return $cell.querySelector('.topic-link') != null;
  }).map(($cell) {
    final $topicLink = $cell.querySelector('.topic-link');
    final String link = $topicLink.attributes['href']!;
    RegExp reg = new RegExp(r"\/t\/(\d+)[^0-9]+");
    var match = reg.firstMatch(link);
    int topicId = 0;
    if (match != null && match.groupCount > 0) {
      topicId = int.parse(match.group(1)!);
    }
    return Topic(
        id: topicId,
        title: $topicLink.text,
        replies: int.parse($cell.querySelector('.count_livid')?.text ?? '0'),
        author: $cell.querySelector('strong')?.text ?? '',
        avatar: $cell.querySelector('.avatar').attributes['src']!);
  }).toList();

  return topics;
}

// Future<List<ret.Reply>> getTopicReplies(int topicId,
//     {bool refresh = false}) async {
//   final http = new Http();
//   var params = {
//     "topic_id": topicId,
//   };

//   if (refresh) {
//     params['now'] = DateTime.now().millisecondsSinceEpoch;
//   }
//   final res = await http.get<List<dynamic>>(
//       'https://www.v2ex.com/api/replies/show.json',
//       queryParameters: params);
//   final List<ret.Reply> replies =
//       res.data.map((e) => ret.Reply.fromJson(e)).toList();
//   return replies;
// }

// Future<ret.Topic> getTopicDetail(int id, {bool refresh = false}) async {
//   final http = new Http();
//   var params = {
//     "id": id,
//   };

//   if (refresh) {
//     params['now'] = DateTime.now().millisecondsSinceEpoch;
//   }

//   final res = await http.get<List<dynamic>>(
//       'https://www.v2ex.com/api/topics/show.json',
//       queryParameters: params);
//   final ret.Topic topic = ret.Topic.fromJson(res.data[0]);
//   return topic;
// }

Future getTopicAndReplies(int id, {int page = 1}) async {
  final http = new Http();
  final String res = await http.getHTML('https://www.v2ex.com/t/$id?p=$page',
      options: Options(headers: {
        HttpHeaders.userAgentHeader:
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36'
      }));
  var doc = parse(res);
  if (!testIfLoged(doc) && hasLoginForm(doc)) {
    throw (new NeedLoginException());
  }

  var $main = doc.getElementById('Main');
  var $boxs = $main.querySelectorAll('.box');

  var $topicSection = $boxs[0];
  var $replySection = $boxs[1];

  var topicTitle = $topicSection.querySelector('.header h1').text;
  var topicMemberUsername = $topicSection.querySelector('.header .gray a').text;
  var topicMemberAvatar =
      $topicSection.querySelector('.header .avatar').attributes['src'] ?? '';
  var topicContent = $topicSection
      .querySelector('.cell .topic_content')
      ?.innerHtml; // 部分 topic 仅有 title
  int topicCreated = dt.dp(
      $topicSection.querySelector('.header .gray span').attributes['title'] ??
          '');

  var subtles = $topicSection.querySelectorAll('.subtle').map((e) {
    return SubtleData(
        createdAt:
            dt.dp(e.querySelector('.fade span').attributes['title'] ?? ''),
        content: e.querySelector('.topic_content').innerHtml);
  }).toList();

  int replyCount = 0;
  int? topicLastReplyAt;
  int replyPageCount = 0;
  List<String> topicTags = [];
  List<ReplyData> replies = [];
  if (doc.getElementById('no-comments-yet') == null) {
    var $replySectionCells = $replySection.querySelectorAll('.cell');

    topicTags = $replySectionCells[0]
        .querySelectorAll('a.tag')
        .map((e) => e.text.trim())
        .toList();
    replyCount = int.parse((new RegExp(r'^(\d+)\s'))
            .firstMatch(
                $replySectionCells[0].querySelector('.gray')?.text ?? '0 ')!
            .group(1) ??
        '0');

    if (replyCount > 0) {
      topicLastReplyAt = dt.dp((new RegExp(r'\d{4}-.+$'))
          .firstMatch($replySectionCells[0].querySelector('.gray')!.text)!
          .group(0)!);
      replyPageCount = int.parse(
          $replySection.querySelector('.page_input')?.attributes['max'] ?? '1');
    }

    replies = $replySectionCells.where((element) {
      return element.querySelector('.no') != null;
    }).map((e) {
      return ReplyData(
          content: e.querySelector('.reply_content').innerHtml,
          createdAt: dt.dp(e.querySelector('.ago').attributes['title']!),
          floor: int.parse(e.querySelector('.no').text),
          member: MemberData(
            avatar: e.querySelector('.avatar').attributes['src']!,
            username: e.querySelector('strong a').text,
          ));
    }).toList();
  } else {
    topicTags = $replySection
        .querySelectorAll('a.tag')
        .map((e) => e.text.trim())
        .toList();
  }

  final result = {
    "topic": TopicData(
        id: id,
        title: topicTitle,
        content: topicContent,
        createdAt: topicCreated,
        subtles: subtles,
        replyCount: replyCount,
        lastReplyAt: topicLastReplyAt,
        replyPageCount: replyPageCount,
        tags: topicTags,
        member: MemberData(
            avatar: topicMemberAvatar, username: topicMemberUsername)),
    "replies": replies,
  };

  return result;
}
