import 'package:flutter/material.dart';
import 'package:bible/models/book.dart';
import 'package:bible/models/verse.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// MainProvider class extends ChangeNotifier for state management

class MainProvider extends ChangeNotifier {
  // Controllers and listeners for managing scroll positions and items
  ItemScrollController itemScrollController = ItemScrollController();
  ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  // List to store Verse objects
  List<Verse> verses = [];

  // Methods to add a Verse to the list and notify listeners
  void addVerse({ required Verse verse }) {
    verses.add(verse);
    notifyListeners();
  }

  // List to store Book objects
  List<Book> books = [];

  // Method to add a Book to the list and notify listeners
  void addBook({ required Book book }) {
    books.add(book);
    notifyListeners();
  }

  // Variable to store the current Verse
  Verse? currentVerse;

  // Method to update the current Verse and notify listeners
  void updateCurrentVerse({ required Verse verse }) {
    currentVerse = verse;
    notifyListeners();
  }

  // Method to scroll to a specific index in the list and notify listeners
  void scrollToIndex({ required int index }) {
    itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 800)
    );
    notifyListeners();
  } 

  // List to store selected verse objects
  List<Verse> selectedVerses = [];

  // Method to toggle the selected of a verse and notify listeners
  void toggleVerse({ required Verse verse }) {
    bool contains = selectedVerses.any((element) => element == verse);
    if (contains) {
      selectedVerses.remove(verse);
    } else {
      selectedVerses.add(verse);
    }

    notifyListeners();
  }

  // Method to clear the selected Verse list and notify listeners
  void clearSelectedVerses() {
    selectedVerses.clear();
    notifyListeners();
  }
}

