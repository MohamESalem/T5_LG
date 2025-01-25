import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  int _selectedIndex = -1;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      setState(() {
        _selectedIndex = -1;
        _controller.reverse();
      });
    } else {
      setState(() {
        _selectedIndex = index;
        _controller.forward(from: 0.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color selectedColor =
        isDarkMode ? Colors.purpleAccent : Colors.blueAccent;
    final Color unselectedColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.black, Colors.grey[900]!]
                : [Colors.white, Colors.grey[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(118, 96, 125, 139),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _buildAnimatedIcon(
                  AnimatedIcons.menu_arrow,
                  0,
                  selectedColor,
                  unselectedColor,
                ),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: _buildAnimatedIcon(
                  AnimatedIcons.play_pause,
                  1,
                  selectedColor,
                  unselectedColor,
                ),
                label: 'Play',
              ),
              BottomNavigationBarItem(
                icon: _buildAnimatedIcon(
                  AnimatedIcons.add_event,
                  2,
                  selectedColor,
                  unselectedColor,
                ),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: _buildAnimatedIcon(
                  AnimatedIcons.view_list,
                  3,
                  selectedColor,
                  unselectedColor,
                ),
                label: 'List',
              ),
            ],
            currentIndex: _selectedIndex == -1 ? 0 : _selectedIndex,
            selectedItemColor: selectedColor,
            unselectedItemColor: unselectedColor,
            onTap: _onItemTapped,
            selectedLabelStyle: TextStyle(
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: selectedColor,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(AnimatedIconData icon, int index,
      Color selectedColor, Color unselectedColor) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: IconTheme(
        data: IconThemeData(
          color: _selectedIndex == index ? selectedColor : unselectedColor,
        ),
        child: AnimatedIcon(
          key: ValueKey<int>(_selectedIndex),
          icon: icon,
          progress: _controller,
        ),
      ),
    );
  }
}
