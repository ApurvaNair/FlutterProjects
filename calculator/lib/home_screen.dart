import 'package:calculator/components/my_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      MYButton(title: 'AC', onPress: () {}),
                      MYButton(title: '+/-', onPress: () {}),
                      MYButton(title: '%', onPress: () {}),
                      MYButton(
                          title: '/', color: const Color(0xffffa00a), onPress: () {}),
                    ],
                  ),
                  Row(children: [
                    MYButton(title: 'AC', onPress: () {}),
                    MYButton(title: '+/-', onPress: () {}),
                    MYButton(title: '%', onPress: () {}),
                    MYButton(
                        title: '/', color: const Color(0xffffa00a), onPress: () {}),
                  ]),
                  Row(children: [
                    MYButton(title: 'AC', onPress: () {}),
                    MYButton(title: '+/-', onPress: () {}),
                    MYButton(title: '%', onPress: () {}),
                    MYButton(
                        title: '/', color: const Color(0xffffa00a), onPress: () {}),
                  ]),
                  Row(children: [
                    MYButton(title: 'AC', onPress: () {}),
                    MYButton(title: '+/-', onPress: () {}),
                    MYButton(title: '%', onPress: () {}),
                    MYButton(
                        title: '/', color: const Color(0xffffa00a), onPress: () {}),
                  ])
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      )),
    );
  }
}
