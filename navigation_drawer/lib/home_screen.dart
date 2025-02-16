import 'package:flutter/material.dart';
import 'package:navigation_drawer/screen_two.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff764abc),
        foregroundColor: Colors.white,
        title: const Center(child: Text('Navigation Drawer')),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsNWPhXbh68-pBV7iNSR76TAgOVQRSqkuogA&s'),
                ),
                accountName: Text('Apurva Nair'),
                accountEmail: Text('apurvanair@gmail.com')),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Page 1'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ScreenTwo()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Page 2'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.login_outlined),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const ScreenTwo()));
                  },
                  child: const Text('Screen 1')))
        ],
      ),
    );
  }
}
