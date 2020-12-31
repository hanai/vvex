// ignore: import_of_legacy_library_into_null_safe
import 'package:markdown/markdown.dart' as md;

class AtSyntax extends md.InlineSyntax {
  static final String _pattern = r'(^|\s+)@(\w+)(\s+|$)';

  AtSyntax() : super(_pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    var anchor = md.Element.text('a', '@${match[2]}');

    if ('${match[1]}'.length > 0) {
      parser.addNode(md.Text(match[1]));
    }
    parser.addNode(anchor);
    if ('${match[3]}'.length > 0) {
      parser.addNode(md.Text(match[3]));
    }
    return true;
  }
}
