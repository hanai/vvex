import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vvex/pages/home_page/home_page.dart';
import 'package:vvex/pages/login_page.dart';
import 'package:vvex/pages/member_page/user_info_page.dart';
import 'package:vvex/pages/topic_page/topic_page.dart';
import 'package:vvex/pages/webview_page/webview_page.dart';

const String HomePageRoute = '/';

const String LoginPageRoute = '/login';

const String TopicPageRoute = '/topic';

const String MemberPageRoute = '/member';

const String NewTopicPageRoute = '/new_topic';

const String WebViewPageRoute = '/web_view';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomePageRoute:
      return MaterialPageRoute(builder: (context) => HomePage(title: 'VVEX'));
    case LoginPageRoute:
      return MaterialPageRoute(builder: (context) => LoginPage(title: '登录'));
    case TopicPageRoute:
      var args = settings.arguments! as Map<String, dynamic>;
      var topicId = args['topicId'] as int;
      var title = args['title'] as String;
      return MaterialPageRoute(
          builder: (context) => TopicPage(
                title: title,
                topicId: topicId,
              ));
    case WebViewPageRoute:
      var args = settings.arguments! as Map<String, dynamic>;
      var url = args['url'] as String;
      var title = args['title'] as String;
      return MaterialPageRoute(
          builder: (context) => WebViewPage(
                url: url,
                title: title,
              ));
    case MemberPageRoute:
      var args = settings.arguments! as Map<String, dynamic>;
      var username = args['username'] as String;
      return MaterialPageRoute(
          builder: (context) => MemberPage(
                username: username,
              ));
    default:
      return MaterialPageRoute(builder: (context) => HomePage(title: 'VVEX'));
  }
}
