import 'dart:io';
import 'package:flutter/material.dart';

import 'Deck.dart';

enum Rating { Again, Hard, Good, Easy }

class FlashCard {
  String id;
  Deck? deck;
  String title;
  String content;
  File? titleImage;
  Rating rating;
  DateTime ts;
  DateTime dueDate;
  TimeOfDay? reminderTime;
  double easeFactor;
  int reviews;

  FlashCard({
    required this.id,
    this.deck,
    required this.title,
    required this.content,
    this.titleImage,
    required this.rating,
    required this.ts,
    required this.dueDate,
    this.reminderTime,
    this.easeFactor = 2.5,
    this.reviews = 0,
  });

  // Convert FlashCard to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "deck": deck!.toMap(),
      "title": title,
      "content": content,
      "ts": ts.toIso8601String(),
      "dueDate": dueDate.toIso8601String(),
      "easeFactor": easeFactor,
      "reviews": reviews,
    };
  }

  // Create a FlashCard instance from a Map
  static FlashCard fromMap(Map<String, dynamic> map) {
    return FlashCard(
      id: map["id"].toString(),
      deck: Deck.fromMap(map["deck"]),
      title: map["title"] ?? "",
      content: map["content"] ?? "",
      ts: DateTime.parse(map["ts"]),
      dueDate: DateTime.parse(map["dueDate"]),
      easeFactor: map["easeFactor"] ?? 2.5,
      reviews: map["reviews"] ?? 0,
      rating: Rating.values[map["rating"] ?? 0],
    );
  }

  // Update card state based on user rating
  void updateCardState(Rating rate) {
    ts = DateTime.now().toUtc();
    reviews += 1;
    rating = rate;
    calculateEaseFactor();
    calculateDueDate();
  }

  // Adjust ease factor based on rating
  void calculateEaseFactor() {
    easeFactor += 0.1 - (3 - rating.index) * (0.08 + (3 - rating.index) * 0.02);
    if (easeFactor < 1.3) easeFactor = 1.3; // Minimum ease factor threshold
  }

  // Determine the next due date for the card
  void calculateDueDate() {
    if (reviews == 1 || rating.index < 2) {
      dueDate = ts.add(Duration(days: 1));
    } else if (reviews == 2) {
      dueDate = ts.add(Duration(days: 6));
    } else {
      int interval = ((reviews - 1) * easeFactor).floor();
      dueDate = ts.add(Duration(days: interval));
    }
    // Set due date to 3 PM (UTC) for consistency
    dueDate = DateTime(dueDate.year, dueDate.month, dueDate.day, 15).toUtc();
  }

  // Check if the card is due for review
  bool isDue() {
    final now = DateTime.now().toUtc();
    return dueDate.isBefore(now) ||
        dueDate.isAtSameMomentAs(now) ||
        reviews == 0;
  }

  // Check if the card's due date is in the future
  bool isLater() {
    return dueDate.isAfter(DateTime.now().toUtc());
  }
}
