import 'dart:async';
import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: HoverAnimationStack(),
        ),
      ),
    );
  }
}

class HoverAnimationStack extends StatefulWidget {
  @override
  _HoverAnimationStackState createState() => _HoverAnimationStackState();
}

class _HoverAnimationStackState extends State<HoverAnimationStack>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _sizeController;
  late AnimationController _starRotationController;
  ShapeBorder currentShape = CircleBorder(); 
  late Timer _timer;
  int _shapeIndex = 0;

  final List<ShapeBorder> shapes = [
    CircleBorder(),
    StarShapeBorder(
      corners: 12,
      inset: 30.toPercentLength,
      cornerRadius: 15.toPXLength,
      cornerStyle: CornerStyle.rounded,
      insetRadius: 2.toPXLength,
      insetStyle: CornerStyle.rounded,
    ),
    RectangleShapeBorder(
      cornerStyles: RectangleCornerStyles.all(CornerStyle.rounded),
      borderRadius:
          DynamicBorderRadius.all(DynamicRadius.circular(20.toPXLength)),
    ),
    PolygonShapeBorder(
        sides: 6,
        cornerRadius: 30.toPXLength,
        cornerStyle: CornerStyle.rounded),
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _sizeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _starRotationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _sizeController.dispose();
    _starRotationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _timer = Timer.periodic(Duration(seconds: 3), (timer) {
          setState(() {
            _shapeIndex = (_shapeIndex + 1) % shapes.length;
            currentShape = shapes[_shapeIndex];
          });
        });
        _rotationController.repeat();
        _sizeController.forward();
        _starRotationController.forward();
      },
      onExit: (_) {
        _sizeController.reverseDuration = const Duration(milliseconds: 700);
        _sizeController.reverse();
        _rotationController.stop();
        _starRotationController.reverseDuration =
            const Duration(milliseconds: 900);
        _starRotationController.reverse();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotatingShape(
            rotationController: _rotationController,
            sizeController: _sizeController,
            shape: currentShape,
          ),
          RotatingStar(controller: _starRotationController),
        ],
      ),
    );
  }
}

class RotatingStar extends StatelessWidget {
  final AnimationController controller;

  RotatingStar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final _animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    final _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.white,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.50, curve: Curves.easeInOutQuad),
        reverseCurve: Curves.easeInOutQuad,
      ),
    );

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 3.14,
          child: Container(
            width: 140,
            height: 140,
            decoration: ShapeDecoration(
              color: _colorAnimation.value,
              shape: star,
            ),
          ),
        );
      },
    );
  }
}

class RotatingShape extends StatelessWidget {
  final AnimationController rotationController;
  final AnimationController sizeController;
  final ShapeBorder shape;

  RotatingShape({
    required this.rotationController,
    required this.sizeController,
    required this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14,
    ).animate(
      CurvedAnimation(
        parent: rotationController,
        curve: Curves.easeInOut,
      ),
    );

    final _sizeAnimation = Tween<double>(
      begin: 0,
      end: 300,
    ).animate(
      CurvedAnimation(
        parent: sizeController,
        curve: Interval(0.0, 0.99, curve: Curves.easeOutQuint),
      ),
    );

    return AnimatedBuilder(
      animation: Listenable.merge([rotationController, sizeController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _sizeAnimation.value / 250,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: AnimatedCircle(
              controller: rotationController,
              shape: shape,
            ),
          ),
        );
      },
    );
  }
}

class AnimatedCircle extends StatelessWidget {
  final AnimationController controller;
  final ShapeBorder shape;

  AnimatedCircle({
    required this.controller,
    required this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final _gradientBeginAnimation = AlignmentTween(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    final _gradientEndAnimation = AlignmentTween(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    final _colorAnimation2 = TweenSequence<Color?>(
      [
        TweenSequenceItem(
          tween: ColorTween(
                  begin: Colors.blue.shade300, end: Colors.purple.shade300)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: ColorTween(
                  begin: Colors.purple.shade300, end: Colors.blue.shade300)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: ColorTween(
                  begin: Colors.blue.shade300, end: Colors.purple.shade300)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: ColorTween(
                  begin: Colors.purple.shade300, end: Colors.blue.shade300)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: 250,
          height: 250,
          decoration: ShapeDecoration(
            shape: shape,
            gradient: LinearGradient(
              begin: _gradientBeginAnimation.value,
              end: _gradientEndAnimation.value,
              colors: [
                _colorAnimation2.value!,
                Colors.blue.shade300,
              ],
            ),
          ),
        );
      },
    );
  }
}

ShapeBorder star = RectangleShapeBorder(
  cornerStyles: RectangleCornerStyles.all(CornerStyle.concave),
  borderRadius:
      DynamicBorderRadius.all(DynamicRadius.circular(1000.toPXLength)),
);
