import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          title: const Text('WhatsApp'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(child: Icon(Icons.camera_alt)),
              Tab(child: Text('Chats')),
              Tab(child: Text('Status')),
              Tab(child: Text('Calls')),
            ],
          ),
          actions: [
            const Icon(Icons.search),
            const SizedBox(width: 10),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert_outlined),
              itemBuilder: (context) => [
                const PopupMenuItem(value: '1', child: Text('New Group')),
                const PopupMenuItem(value: '2', child: Text('Settings')),
                const PopupMenuItem(value: '3', child: Text('Logout')),
              ],
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: TabBarView(children: [
          const Text('Camera'),
          ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return const ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPCnjtYHR-JqDzR0UHJduZ_pHI9LveRmtYug&s'),
                ),
                title: Text('Vava'),
                subtitle: Text('Yeh dekha tune?'),
                trailing: Text('6:36 PM'),
              );
            },
          ),
          ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('New Updates'),
                      ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.green, width: 3)),
                          child: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPCnjtYHR-JqDzR0UHJduZ_pHI9LveRmtYug&s'),
                          ),
                        ),
                        title: const Text('Vava'),
                        subtitle: const Text('35m ago'),
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('New Updates'),
                      ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.green, width: 3)),
                          child: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPCnjtYHR-JqDzR0UHJduZ_pHI9LveRmtYug&s'),
                          ),
                        ),
                        title: const Text('Vava'),
                        subtitle: const Text('35m ago'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPCnjtYHR-JqDzR0UHJduZ_pHI9LveRmtYug&s'),
                ),
                title: const Text('Vava'),
                subtitle: Text(index / 2 == 0
                    ? 'you missed audio call'
                    : 'you missed video call'),
                trailing: Icon(index / 2 == 0 ? Icons.phone : Icons.video_call),
              );
            },
          ),
        ]),
      ),
    );
  }
}
