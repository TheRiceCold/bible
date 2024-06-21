import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:clipboard/clipboard.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:bible/models/verse.dart';
import 'package:bible/screens/books.dart';
import 'package:bible/screens/search.dart';
import 'package:bible/widgets/verse_widget.dart';
import 'package:bible/providers/main_provider.dart';
import 'package:bible/services/read_last_index.dart';

class HomePage extends StatefulWidget {
  const HomePage({ super.key });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // We will resume to the last position the user was
    // Delayed execution to allow the UI build before scrolling
    Future.delayed(
      const Duration(milliseconds: 100),
      () async {
        MainProvider mainProvider = Provider.of<MainProvider>(context, listen: false);

        // Read the last index and scroll to it
        await ReadLastIndex.execute().then(
          (index) {
            if (index != null) {
              mainProvider.scrollToIndex(index: index);
            }
          },
        );
      },
    );
    super.initState();
  }

  // Process selected verse to create a formatted string
  String formattedSelectedVerses({ required List<Verse> verses }) {
    String result = verses.map((e) => ' [${e.book} ${e.chapter}:${e.verse}] ${e.text.trim()}').join();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // Using Consumer to listen to changes in MainProvider
    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {
        List<Verse> verses = mainProvider.verses;
        Verse? currentVerse = mainProvider.currentVerse;
        bool isSelected = mainProvider.selectedVerses.isNotEmpty;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          ),
          child: Scaffold(
            appBar: AppBar(
              title: currentVerse == null || isSelected 
                ? null : GestureDetector(
                  onTap: () {
                    // Navigate to BooksPage on top
                    Get.to(
                      () => BooksPage(
                        chapterIndex: currentVerse.chapter,
                        bookIndex: currentVerse.book),
                      transition: Transition.leftToRight,
                    );
                  },
                  child: Text(currentVerse.book),
                ),
              actions: [
                if (isSelected)
                  IconButton(
                    onPressed: () async {
                      // Copy selected verses to clipboard
                      String string = formattedSelectedVerses(
                        verses: mainProvider.selectedVerses);
                      await FlutterClipboard.copy(string).then(
                        (_) => mainProvider.clearSelectedVerses(),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded),
                  ),
                if (!isSelected)
                  IconButton(
                    onPressed: () async {
                       // Navigate to [SearchPage]
                      Get.to(
                        () => SearchPage(verses: verses),
                        transition: Transition.rightToLeft,
                      );
                    },
                    icon: const Icon(Icons.search_rounded),
                  ),
              ],
            ),
            // Body of the Scaffold with a ScrollablePositionedList
            body: ScrollablePositionedList.builder(
              itemCount: verses.length,
              itemBuilder: (context, index) {
                Verse verse = verses[index];
                return VerseWidget(verse: verse, index: index);
              },
              itemScrollController: mainProvider.itemScrollController,
              itemPositionsListener: mainProvider.itemPositionsListener,
              scrollOffsetController: mainProvider.scrollOffsetController,
              scrollOffsetListener: mainProvider.scrollOffsetListener,
            ),
          ),
        );
      },
    );
  }
}
