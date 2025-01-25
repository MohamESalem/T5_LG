import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(icon: Icon(Icons.star)),
                Tab(text: 'My tasks'),
                Tab(text: 'Plans'),
                Tab(text: 'Routines'),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
