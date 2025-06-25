import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../models/Deck.dart';
import '../models/FlashCard.dart';
import '../models/FlashCardData.dart';
import '../widgets/FlashCardItem.dart';
import '../widgets/congrats.dart';

class CardsSwipePage extends StatefulWidget {
  static const routeName = "cardSwipe";

  @override
  _CardsSwipePageState createState() => _CardsSwipePageState();
}

class _CardsSwipePageState extends State<CardsSwipePage> {
  Deck? currentDeck;
  final SwipableStackController _swipeController = SwipableStackController();
  bool showCongratsCard = false;
  bool showInstructions = true; // Toggle for swipe instructions

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Deck) {
      currentDeck = args;
    } else {
      // Fallback or error handling if no valid deck is passed
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentDeck == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "No deck selected",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            currentDeck!.deckName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: Icon(
                  showInstructions ? Icons.visibility_off : Icons.visibility),
              tooltip:
                  showInstructions ? "Hide Instructions" : "Show Instructions",
              onPressed: () {
                setState(() {
                  showInstructions = !showInstructions;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: "Add Flashcard",
              onPressed: () {
                _showAddNewFlashCardForm(context);
              },
            ),
          ],
        ),
        body: Consumer<FlashCardData>(
          builder: (context, flashcards, child) {
            final dueCards = flashcards.getDueCards(currentDeck!.id);

            return Stack(
              children: [
                if (dueCards.isNotEmpty)
                  SwipableStack(
                    controller: _swipeController,
                    itemCount: dueCards.length,
                    onSwipeCompleted: (index, direction) {
                      _handleSwipe(direction, flashcards, dueCards[index]);
                    },
                    builder: (context, properties) {
                      return FlashCardItem(fc: dueCards[properties.index]);
                    },
                  )
                else
                  const Center(
                    child: Text(
                      "No cards left to review!",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                // Swipe instructions widget
                if (showInstructions)
                  Positioned(
                    top: 10,
                    left: 16,
                    right: 16,
                    child: SwipeInstructions(),
                  ),
                _buildFlashcardStats(flashcards),
                if (showCongratsCard) _showCongrats(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFlashcardStats(FlashCardData flashcards) {
    final numDue = flashcards.getNumberOfDue(currentDeck!.id);
    return Positioned(
      bottom: 30,
      right: 30,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          "$numDue Due Cards",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void _handleSwipe(
      SwipeDirection direction, FlashCardData flashcards, FlashCard card) {
    final rating = _mapDirectionToRating(direction);
    if (rating != null) {
      card.updateCardState(rating);
      flashcards.update(card);
    }

    if (flashcards.getNumberOfDue(currentDeck!.id) < 1) {
      setState(() {
        showCongratsCard = true;
      });
    }
  }

  Rating? _mapDirectionToRating(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.left:
        return Rating.Again;
      case SwipeDirection.right:
        return Rating.Good;
      case SwipeDirection.up:
        return Rating.Easy;
      case SwipeDirection.down:
        return Rating.Hard;
      default:
        return null;
    }
  }

  Future<void> _showAddNewFlashCardForm(BuildContext context) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String? title, content;

    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  "ADD NEW FLASHCARD",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter the card's title",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => title = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a title";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter the card's content",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => content = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter content for the card";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      Provider.of<FlashCardData>(context, listen: false).add(
                        FlashCard(
                          id: DateTime.now().toIso8601String(),
                          deck: currentDeck!,
                          title: title!,
                          content: content!,
                          rating: Rating.Again,
                          ts: DateTime.now(),
                          dueDate: DateTime.now().add(const Duration(days: 1)),
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("ADD FLASHCARD"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _showCongrats() {
    return Center(
      child: CongratsCard(
        allDone: true,
        message: "Congrats! You've finished all your due cards!",
        onClose: () {
          setState(() {
            showCongratsCard = false;
          });
        },
      ),
    );
  }
}

class SwipeInstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Swipe Instructions",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              DirectionLegend(
                icon: Icons.arrow_left,
                direction: "Left",
                description: "Again",
              ),
              DirectionLegend(
                icon: Icons.arrow_upward,
                direction: "Up",
                description: "Easy",
              ),
              DirectionLegend(
                icon: Icons.arrow_downward,
                direction: "Down",
                description: "Hard",
              ),
              DirectionLegend(
                icon: Icons.arrow_right,
                direction: "Right",
                description: "Good",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DirectionLegend extends StatelessWidget {
  final IconData icon;
  final String direction;
  final String description;

  const DirectionLegend({
    Key? key,
    required this.icon,
    required this.direction,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24.0),
        const SizedBox(height: 4.0),
        Text(
          direction,
          style: const TextStyle(color: Colors.white, fontSize: 12.0),
        ),
        Text(
          description,
          style: const TextStyle(color: Colors.white, fontSize: 10.0),
        ),
      ],
    );
  }
}
