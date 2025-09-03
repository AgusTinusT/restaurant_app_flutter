import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ExpansionProvider extends ChangeNotifier {
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  void toggle() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }
}

class ExpandableDescription extends StatelessWidget {
  final String text;
  final int maxLines = 4;
  const ExpandableDescription({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (!textPainter.didExceedMaxLines) {
          return Text(text, style: style);
        }

        return ChangeNotifierProvider(
          create: (_) => _ExpansionProvider(),
          child: Consumer<_ExpansionProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    text,
                    style: style,
                    maxLines: provider.isExpanded ? null : maxLines,
                    overflow:
                        provider.isExpanded ? null : TextOverflow.ellipsis,
                  ),
                  InkWell(
                    onTap: () => provider.toggle(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        provider.isExpanded ? 'Show less' : 'Read more',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
