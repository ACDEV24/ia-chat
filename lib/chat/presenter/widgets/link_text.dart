import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Expression {
  final RegExp regExp;
  final TextStyle textStyle;

  const Expression({
    required this.regExp,
    required this.textStyle,
  });
}

class MatchText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final List<Expression> expressions;

  const MatchText({
    super.key,
    required this.text,
    required this.expressions,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (final expression in expressions) {
      final matches = expression.regExp.allMatches(text);

      for (final match in matches) {
        final linkText = match.group(0)!;
        final index = match.start;
        final end = match.end;

        if (index > lastEnd) {
          spans.add(
            TextSpan(
              text: text.substring(lastEnd, index),
              style: textStyle,
            ),
          );
        }

        spans.add(
          TextSpan(
            text: linkText,
            style: expression.textStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(Uri.parse(linkText));
              },
          ),
        );

        lastEnd = end;
      }
    }

    if (lastEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastEnd),
          style: textStyle,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}
