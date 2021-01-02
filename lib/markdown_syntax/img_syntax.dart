// ignore: import_of_legacy_library_into_null_safe
import 'package:markdown/markdown.dart' as md;

class ImgSyntax extends md.InlineSyntax {
  static final String _pattern =
      r'(^|\s)((https?:)?\/\/([^\s]*)\.(png|jpg))(\s|$)';

  ImgSyntax() : super(_pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    var element = md.Element.empty('img');
    element.attributes['src'] = match[2];

    parser.addNode(md.Text(match[1]));
    parser.addNode(element);
    parser.addNode(md.Text(match[6]));

    return true;
  }
}
