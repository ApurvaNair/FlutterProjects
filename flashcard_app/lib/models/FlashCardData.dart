import 'package:collection/collection.dart'; // Grouping utility
import 'package:flutter/widgets.dart'; // ChangeNotifier, used for state management
import './FlashCard.dart'; // FlashCard model
import '../utils/database.dart'; // Database helper methods

class FlashCardData with ChangeNotifier {
  List<FlashCard> _flashCardsList = <FlashCard>[]; // Holds all flashcards
  bool _isDone = false; // Flag indicating if there are any due cards left

  // Getter for the list of flashcards
  List<FlashCard> get flashCardsList => _flashCardsList;

  // Getter for the done status
  bool get allDone => _isDone;

  // Method to check if all flashcards for a specific deck are done
  void isDone(String deckID) {
    _isDone = nextCard(deckID) == null; // Check if there's a next due card
    notifyListeners(); // Notify listeners after change
  }

  // Get the number of cards due for a specific deck
  int getNumberOfDue(String deckID) {
    return _flashCardsList
        .where((fc) =>
            fc.deck!.id == deckID &&
            fc.isDue()) // Filters cards by deck ID and due status
        .length;
  }

  // Get the number of cards to review later for a specific deck
  int getNumberOfLater(String deckID) {
    return _flashCardsList
        .where((fc) =>
            fc.deck!.id == deckID &&
            fc.isLater()) // Filters cards by deck ID and later status
        .length;
  }

  // Get the total number of cards in a specific deck
  int getNumberOfCards(String deckID) {
    return _flashCardsList.where((fc) => fc.deck!.id == deckID).length;
  }

  // Get the next due card for a specific deck
  FlashCard? nextCard(String deckID) {
    try {
      return _flashCardsList
          .firstWhere((fc) => fc.deck!.id == deckID && fc.isDue());
    } catch (e) {
      return null; // If no due card is found, return null
    }
  }

  // Get all cards that are due for review (based on deck ID)
  List<FlashCard> getDueCards(String deckId) {
    final currentDate = DateTime.now();
    return _flashCardsList.where((card) {
      return card.deck!.id == deckId &&
          (card.rating != Rating.Good || card.dueDate.isBefore(currentDate));
    }).toList();
  }

  // Get a schedule map (grouping cards by due date)
  Map<DateTime, List<FlashCard>> getSchedule() {
    // Grouping flashcards by their due date
    return groupBy(_flashCardsList, (FlashCard fc) => fc.dueDate);
  }

  // Add a new flashcard to the list and database
  Future<void> add(FlashCard fc) async {
    _flashCardsList.add(fc);
    await Database.insert(fc); // Insert the new card into the database
    notifyListeners(); // Notify listeners after the state change
  }

  // Update an existing flashcard in the database
  Future<void> update(FlashCard fc) async {
    await Database.update(fc); // Update the card in the database
    notifyListeners(); // Notify listeners after the update
  }

  // Delete a flashcard by its ID
  Future<void> delete(String id) async {
    _flashCardsList
        .removeWhere((fc) => fc.id == id); // Remove the card from the list
    await Database.delete(id); // Delete the card from the database
    notifyListeners(); // Notify listeners after deletion
  }

  // Read flashcards from the database
  Future<void> read() async {
    _flashCardsList =
        await Database.read(); // Read all flashcards from the database
    notifyListeners(); // Notify listeners after reading data
  }

  UserStats userStats = UserStats();

  // Method to review a flashcard
  void reviewFlashcard(FlashCard flashCard) {
    userStats.updateStreak(); // Update streak count
    notifyListeners();
  }

  // Get streak message for display
  String getStreakMessage() {
    return userStats.getStreakMessage();
  }
}

class UserStats {
  int streakCount = 0; // Days in a row studying
  DateTime? lastStudyDate;

  // Method to update streak
  void updateStreak() {
    final today = DateTime.now();
    if (lastStudyDate == null || lastStudyDate!.difference(today).inDays > 1) {
      streakCount = 1; // Reset streak if there's a break
    } else if (lastStudyDate!.difference(today).inDays == 1) {
      streakCount++; // Increment streak if it’s the next day
    }

    lastStudyDate = today; // Update the last study date
  }

  // Get streak message
  String getStreakMessage() {
    return "You have studied for $streakCount day(s) in a row!";
  }
}
