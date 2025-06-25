import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Deck.dart';
import '../models/FlashCard.dart';
import '../models/FlashCardData.dart';
import 'CardsSwipePage.dart';
import 'SchedulePage.dart';

class CardsListPage extends StatefulWidget {
  @override
  _CardsListPageState createState() => _CardsListPageState();
}

class _CardsListPageState extends State<CardsListPage> {
  final _formKey = GlobalKey<FormState>();
  String? _newDeckName;
  late Map<DateTime, List<FlashCard>> _events;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FlashCardData>(context, listen: false).read();
      Provider.of<Decks>(context, listen: false).getDecks();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _events = Provider.of<FlashCardData>(context, listen: false).getSchedule();
  }

  @override
  Widget build(BuildContext context) {
    final flashCardProvider = Provider.of<FlashCardData>(context);
    final decksProvider = Provider.of<Decks>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          elevation: 4.0,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Column(
            children: const [
              Text(
                "MEMOMATE",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "FLASHCARD APP",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, size: 34, color: Colors.white),
              onPressed: () => _showAddNewDeckForm(context),
            ),
          ],
        ),
        body: decksProvider.decksList.isEmpty
            ? const Center(
                child: Text(
                  "No Decks Available",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              )
            : Column(
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildDeckList(decksProvider, flashCardProvider),
                  ),
                  _buildHeader(context, flashCardProvider, decksProvider),
                ],
              ),
      ),
    );
  }

  Widget _buildDeckList(Decks decksProvider, FlashCardData fcProvider) {
    return ListView.builder(
      itemCount: decksProvider.decksList.length,
      itemBuilder: (ctx, index) {
        final deck = decksProvider.decksList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4.0,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: CircleAvatar(
              backgroundColor: Colors.purple.shade100,
              child: Text(
                deck.deckName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.purple,
                ),
              ),
            ),
            title: Text(
              deck.deckName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    fcProvider.getNumberOfDue(deck.id).toString(),
                    style: const TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
            onTap: () => Navigator.of(context).pushNamed(
              CardsSwipePage.routeName,
              arguments: deck,
            ),
            onLongPress: () =>
                _showDeleteConfirmationDialog(context, decksProvider, index),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
      BuildContext context, FlashCardData fcProvider, Decks decksProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.calendar_today,
                color: Colors.purple), // Icon for the button
            tooltip: 'Your Schedule', // Tooltip text
            onPressed: () {
              Navigator.of(context).pushNamed(
                SchedulePage.routeName,
                arguments: _events, // Pass the events as arguments
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.purple),
            tooltip: "View Stats",
            onPressed: () {
              Navigator.of(context).pushNamed('/stats');
            },
          ),
          Text(
            fcProvider.getStreakMessage(), // Show streak message
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddNewDeckForm(BuildContext context) async {
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
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  "ADD NEW DECK",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Add New Deck",
                    labelText: "Deck",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _newDeckName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Provider.of<Decks>(context, listen: false).addDeck(
                        Deck(
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          deckName: _newDeckName!,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("ADD"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Decks decks, int index) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: Text(
            "Do you want to remove this deck and its cards? \n${decks.decksList[index].deckName}",
          ),
          actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                decks.deleteDeckAndCards(decks.decksList[index].id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
