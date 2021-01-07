import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:html/dom.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:vvex/exceptions.dart';
import 'package:vvex/providers/user_state.dart';
import 'package:vvex/types.dart';
import 'package:vvex/utils/dt.dart' as dt;
import 'package:vvex/utils/html.dart';
import 'package:vvex/utils/http.dart';

Map<String, dynamic> updateUserState(BuildContext context, Document doc) {
  final userState = extractUserState(doc);
  bool logged = userState['logged'];
  if (logged) {
    final String username = userState['username'];
    final String avatar = userState['avatar'];
    Provider.of<UserState>(context, listen: false)
        .setState(logged: logged, username: username, avatar: avatar);
  } else {
    Provider.of<UserState>(context, listen: false).setState(
      logged: logged,
    );
  }

  return userState;
}

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

Future<List<TopicData>> getTabTopics(String tab) async {
  final http = new Http();
  final html = await http.getHTMLPC('https://www.v2ex.com/?tab=' + tab);
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

    var node;
    var lastReplyAt;
    var lastReplyBy;
    var createdAt;
    var $topicInfo = $cell.querySelector('.topic_info');
    if ($topicInfo != null) {
      node = $topicInfo.querySelector('a.node')!.text!.trim();
      var $time = $topicInfo.querySelector('span[title]');
      var $lastReplyBy = $topicInfo.querySelector('strong:last-child');
      if ($lastReplyBy != null) {
        var $lastReplyByLink = $lastReplyBy.querySelector('a');
        if ($lastReplyByLink != null) {
          lastReplyBy = $lastReplyByLink.text;
          lastReplyAt = dt.dp($time.attributes['title']!);
        }
      }

      if (lastReplyBy != null) {
        lastReplyAt = dt.dp($time.attributes['title']!);
      } else {
        createdAt = dt.dp($time.attributes['title']!);
      }
    }

    return TopicData(
        id: topicId,
        title: $topicLink.text,
        member: MemberData(
            username: $cell.querySelector('strong')?.text ?? '',
            avatar: $cell.querySelector('.avatar').attributes['src']!),
        replyCount: int.parse($cell.querySelector('.count_livid')?.text ?? '0'),
        lastReplyAt: lastReplyAt,
        lastReplyBy: lastReplyBy,
        createdAt: createdAt,
        node: node);
  }).toList();

  return topics;
}

Future getTopicAndReplies(int id,
    {required BuildContext context, int page = 1}) async {
  final stopwatch = Stopwatch()..start();
  print('topic $id start fetch');
  final http = new Http();
  final String res = await http.getHTMLPC(
    'https://www.v2ex.com/t/$id?p=$page',
  );

  print('topic $id fetch success: ${stopwatch.elapsed}');
  stopwatch.reset();
  var doc = parse(res);

  var userState = updateUserState(context, doc);
  if (!userState['logged'] && hasLoginForm(doc)) {
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
  var $topicContent =
      $topicSection.querySelector('.cell .topic_content'); // 部分 topic 仅有 title
  var topicContent = $topicContent != null ? parseContent($topicContent) : '';

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
    final replyCountAndLastReplyText =
        $replySectionCells[0].querySelector('.gray')?.text;
    replyCount = int.parse((new RegExp(r'^(\d+)\s'))
            .firstMatch(replyCountAndLastReplyText ?? '0 ')!
            .group(1) ??
        '0');

    if (replyCount > 0) {
      var match = (new RegExp(r'\d{4}-.+$'))
          .firstMatch(replyCountAndLastReplyText ?? '');
      if (match != null) {
        topicLastReplyAt = dt.dp(match.group(0) ?? '');
      }
      replyPageCount = int.parse(
          $replySection.querySelector('.page_input')?.attributes['max'] ?? '1');
    }

    replies = $replySectionCells.where((element) {
      return element.querySelector('.no') != null;
    }).map((e) {
      return ReplyData(
          content: parseContent(e.querySelector('.reply_content')),
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

  print('topic $id parse success: ${stopwatch.elapsed}');

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
