//
// 	 Author: 			    Jiří Sedlák (xsedla2e)
// 	 Create Time: 		13-05-2025 16:09:22
// 	 Modified time: 	13-05-2025 21:04:31
// 	 Description: 	  This is the main application file
//                    It contains the theme settings and app initialization
//

import 'package:app/screens/devices/devices.dart';
import 'package:app/screens/play/play.dart';
import 'package:app/services/storage.dart';
import 'package:flutter/material.dart';

void main() async {
  await Storage().init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LPED',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 21, 82, 158), 
          brightness: Brightness.dark,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity
        ),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: 
        NavigationBar(
          onDestinationSelected: (destinationIndex) {
            setState(() {
              currentPage = destinationIndex;
            });
          },
          selectedIndex: currentPage,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.casino), 
              label: "Devices"
            ),
            NavigationDestination(
              icon: Icon(Icons.play_arrow), 
              label: "Play"
            )
          ]
        ),
        body: [
            DevicesPage(key: ValueKey(currentPage),),
            PlayPage(key: ValueKey(currentPage))
        ][currentPage],
    );
  }
}
