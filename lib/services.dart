import 'dart:io';
import 'dart:typed_data';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:html/parser.dart';
import 'package:vvex/ret.dart' as ret;
import 'package:vvex/types.dart';
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
        link: $topicLink.attributes['href'],
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
        link: $topicLink.attributes['href'],
        replies: int.parse($cell.querySelector('.count_livid')?.text ?? '0'),
        author: $cell.querySelector('strong')?.text ?? '',
        avatar: $cell.querySelector('.avatar').attributes['src']!);
  }).toList();

  return topics;
}

Future<List<ret.Reply>> getTopicReplies(int topicId) async {
  final http = new Http();
  final res = await http.get<List<dynamic>>(
      'https://www.v2ex.com/api/replies/show.json?topic_id=' +
          topicId.toString());
  final List<ret.Reply> replies =
      res.data.map((e) => ret.Reply.fromJson(e)).toList();
  return replies;
}

Future<ret.Topic> getTopicDetail(int id) async {
  final http = new Http();
  final res = await http.get<List<dynamic>>(
      'https://www.v2ex.com/api/topics/show.json?id=' + id.toString());
  final ret.Topic topic = ret.Topic.fromJson(res.data[0]);
  return topic;
}
