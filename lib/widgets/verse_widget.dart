import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bible/models/verse.dart';
import 'package:bible/providers/main_provider.dart';

class VerseWidget extends StatelessWidget {
  final int index;
  final Verse verse;
  const VerseWidget({ super.key, required this.verse, required this.index });

  @override
  Widget build(BuildContext context) {
    // Using a Consumer widget to listen to changes in MainProvider

    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {
        // Check if the current verse is selected
        bool isSelected = mainProvider.selectedVerses.any((e) => e == verse);

        return ListTile(
          onTap: () {
            mainProvider.toggleVerse(verse: verse);
          },
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                // TextSpan for chapter or verse number
                TextSpan(
                  text: verse.verse == 1 ? '${verse.chapter}' : '${verse.verse.toString()} ',
                  style: TextStyle(
                    fontSize: verse.verse == 1 ? 45 : 12,
                    fontWeight: verse.verse == 1 ? FontWeight.bold : FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: verse.text.trim(),
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                    decorationColor: Theme.of(context).colorScheme.primary,
                    decorationStyle: TextDecorationStyle.dotted,
                    decoration: isSelected ? TextDecoration.underline : null,
                  )
                ),
              ],
            ),
          )
        );
      }
    );
  }
}
