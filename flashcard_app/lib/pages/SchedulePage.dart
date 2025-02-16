import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/FlashCard.dart';

class SchedulePage extends StatefulWidget {
  static const routeName = "schedule";

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Map<DateTime, List<FlashCard>> _events;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _events = ModalRoute.of(context)!.settings.arguments
        as Map<DateTime, List<FlashCard>>;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Schedule"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddReminderForm,
            ),
          ],
        ),
        body: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 01, 01),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: CalendarFormat.month,
            ),
            Expanded(
              child: _buildEventList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final selectedEvents = _events[_selectedDay] ?? [];
    return selectedEvents.isEmpty
        ? const Center(child: Text("No events today"))
        : ListView.builder(
            itemCount: selectedEvents.length,
            itemBuilder: (context, index) {
              final event = selectedEvents[index];
              return ListTile(
                leading: Icon(Icons.notifications),
                title: Text(event.title),
                subtitle: Text(
                    "${event.content} - ${event.reminderTime != null ? event.reminderTime!.format(context) : 'No reminder'}"),
                onTap: () {
                  _showEventDetails(event);
                },
              );
            },
          );
  }

  // Show a form to add a reminder
  Future<void> _showAddReminderForm() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    TimeOfDay? reminderTime;

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              children: [
                const Text(
                  "Add New Reminder",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a title";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: "Content",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter content";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    reminderTime = await _selectReminderTime(context);
                    if (titleController.text.isNotEmpty &&
                        contentController.text.isNotEmpty &&
                        reminderTime != null) {
                      final newFlashCard = FlashCard(
                        id: DateTime.now().toIso8601String(),
                        deck: null, // You can set a specific deck if needed
                        title: titleController.text,
                        content: contentController.text,
                        rating:
                            Rating.Again, // Default rating, change as needed
                        ts: DateTime.now(),
                        dueDate: DateTime.now().add(const Duration(days: 1)),
                        reminderTime: reminderTime,
                      );

                      setState(() {
                        if (_events[_selectedDay] == null) {
                          _events[_selectedDay] = [];
                        }
                        _events[_selectedDay]?.add(newFlashCard);
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Save Reminder"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show a time picker to select reminder time
  Future<TimeOfDay?> _selectReminderTime(BuildContext context) async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  // Show event details when tapped
  void _showEventDetails(FlashCard event) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event.title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Content: ${event.content}"),
              Text(
                  "Reminder Time: ${event.reminderTime != null ? event.reminderTime!.format(context) : 'No reminder'}"),
              Text("Due Date: ${event.dueDate.toString()}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
