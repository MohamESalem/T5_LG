import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: MovableRectangle(),
            ),
          ],
        ),
      ),
    );
  }
}

class MovableRectangle extends StatefulWidget {
  const MovableRectangle({super.key});

  @override
  MovableRectangleState createState() => MovableRectangleState();
}

class MovableRectangleState extends State<MovableRectangle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<double> _gradientAnimation;
  List<String> _words = [];
  int _currentWordIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _heightAnimation = Tween<double>(
      begin: 0.0,
      end: 200.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuint,
    ));
    _gradientAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.8),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 0.1),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: 0.8),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 0.0),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.8),
        weight: 15,
      ),
    ]).animate(_controller);

    _heightAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _words =
            'Hey Andreu and Yash, hope you like my Google voice and you can check the code on Github.'
                .split(' ');
        _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
          setState(() {
            if (_currentWordIndex < _words.length) {
              _currentWordIndex++;
            } else {
              timer.cancel();
            }
          });
        });
        _heightAnimation = Tween<double>(
          begin: 200.0,
          end: 200.0,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.fastEaseInToSlowEaseOut,
        ));
        _controller.duration = Duration(seconds: 4);
        _controller.repeat();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_heightAnimation, _gradientAnimation]),
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: _heightAnimation.value,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 3, 8, 10),
                Colors.black87,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.lerp(
                            Colors.blue, Colors.red, _gradientAnimation.value)!,
                        Color.lerp(Colors.red, Colors.yellow,
                            _gradientAnimation.value)!,
                        Color.lerp(Colors.yellow, Colors.green,
                            _gradientAnimation.value)!,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(8, 6),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: AnimatedOpacity(
                  opacity: _currentWordIndex > 0 ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 450),
                  curve: Curves.easeInOutExpo,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      String text = _words.take(_currentWordIndex).join(' ');
                      double marginLeft = 20.0;
                      double marginRight = 5.0;
                      while (text.length > 0 &&
                          (TextPainter(
                            text: TextSpan(
                              text: text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            maxLines: 1,
                            textDirection: TextDirection.rtl,
                          )..layout(
                                  maxWidth: constraints.maxWidth -
                                      marginLeft -
                                      marginRight))
                              .didExceedMaxLines) {
                        text = text.substring(text.indexOf(' ') + 1);
                        text = text.substring(text.indexOf(' ') + 1);
                        text = text.substring(text.indexOf(' ') + 1);
                        text = text.substring(text.indexOf(' ') + 1);
                      }
                      return Padding(
                        padding: EdgeInsets.only(
                            left: marginLeft, right: marginRight),
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 80),
                          child: Text(
                            key: ValueKey<String>(text),
                            text,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 24),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.keyboard, color: Colors.white),
                  padding: EdgeInsets.all(25),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
