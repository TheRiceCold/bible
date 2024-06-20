import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/verse.dart';
import 'providers/main_provider.dart';

import 'package:bible/screens/home.dart';
import 'package:bible/services/fetch_books.dart';
import 'package:bible/services/fetch_verses.dart';
import 'package:bible/services/save_current_index.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => MainProvider())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _loading = true;

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () async {
        MainProvider mainProvider = Provider.of<MainProvider>(context, listen: false);

        mainProvider.itemPositionsListener.itemPositions.addListener(
          () {
            int index = mainProvider.itemPositionsListener.itemPositions.value.last.index;

            SaveCurrentIndex.execute(index: mainProvider.itemPositionsListener.itemPositions.value.first.index);

            Verse currentVerse = mainProvider.verses[index];

            if (mainProvider.currentVerse == null) {
              mainProvider.updateCurrentVerse(verse: mainProvider.verses.first);
            }

            Verse previousVerse = mainProvider.currentVerse == null
              ? mainProvider.verses.first
              : mainProvider.currentVerse!;

            if (currentVerse.book != previousVerse.book) {
              mainProvider.updateCurrentVerse(verse: currentVerse);
            }
          },
        );

        await FetchVerses.execute(mainProvider: mainProvider).then(
          (_) async {
            await FetchBooks.execute(mainProvider: mainProvider)
            .then((_) => setState(() {
              _loading = false;
            }));
          },
        );
      },
    ); // Future.delayed
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.brown,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.brown,
      ),
      home: _loading ? const Center(
        child: CircularProgressIndicator(strokeCap: StrokeCap.round)
      ) : const HomePage(),
    );
  }
}
