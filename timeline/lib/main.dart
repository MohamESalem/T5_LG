import 'package:flutter/material.dart';
import 'package:timeline_tile_plus/timeline_tile_plus.dart';

void main() {
  runApp(MaterialApp(home: Timeline()));
}

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  bool isThirdCompleted = false;
  bool isFourthInProgress = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isThirdCompleted = true;
        isFourthInProgress = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            _buildTimelineTile(
                isFirst: true,
                isPast: true,
                text: 'Selected Movie',
                icon: Icons.movie),
            _buildTimelineTile(
                isPast: true, text: 'Chosen Seats', icon: Icons.event_seat),
            _buildTimelineTile(
                isPast: isThirdCompleted,
                text: 'Added Snacks',
                icon: Icons.fastfood,
                inProgressColor: Colors.orange,
                wasInProgress: !isThirdCompleted && isFourthInProgress),
            _buildTimelineTile(
                text: 'Payment',
                icon: Icons.payment,
                inProgressColor: Colors.orange,
                notStarted: !isFourthInProgress),
            _buildTimelineTile(
                text: 'Review Order',
                icon: Icons.receipt,
                inProgressColor: Colors.orange,
                notStarted: true),
            _buildTimelineTile(
                isLast: true,
                text: 'Booking Confirmed',
                icon: Icons.check_circle,
                notStarted: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTile({
    bool isFirst = false,
    bool isLast = false,
    bool isPast = false,
    bool notStarted = false,
    required String text,
    required IconData icon,
    Color? inProgressColor,
    bool wasInProgress = false,
  }) {
    return CustomTimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      isPast: isPast,
      text: text,
      icon: icon,
      notStarted: notStarted,
      inProgressColor: inProgressColor,
      wasInProgress: wasInProgress,
    );
  }
}

class CustomTimelineTile extends StatefulWidget {
  final bool isFirst, isLast, isPast, notStarted, wasInProgress;
  final String text;
  final IconData icon;
  final Color? inProgressColor;

  const CustomTimelineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.text,
    required this.icon,
    this.notStarted = false,
    this.inProgressColor,
    this.wasInProgress = false,
  });

  @override
  _CustomTimelineTileState createState() => _CustomTimelineTileState();
}

class _CustomTimelineTileState extends State<CustomTimelineTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isPast && !widget.notStarted) {
          setState(() {
            _controller.forward(from: 0.0);
          });
        }
      },
      child: SizedBox(
        height: 120,
        child: TimelineTile(
          isFirst: widget.isFirst,
          isLast: widget.isLast,
          beforeLineStyle: LineStyle(
            color: widget.isPast
                ? Colors.green
                : (widget.notStarted
                    ? Colors.red
                    : widget.inProgressColor ?? Colors.orange),
          ),
          indicatorStyle: IndicatorStyle(
            width: 40,
            color: widget.isPast
                ? Colors.green
                : (widget.notStarted
                    ? Colors.red
                    : widget.inProgressColor ?? Colors.orange),
            iconStyle: IconStyle(
              iconData: widget.isPast
                  ? widget.icon
                  : (widget.notStarted ? Icons.not_started : Icons.autorenew),
              color: Colors.white,
            ),
          ),
          endChild: EventCard(
            text: widget.text,
            isPast: widget.isPast,
            notStarted: widget.notStarted,
            animation: _animation,
            wasInProgress: widget.wasInProgress,
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String text;
  final bool isPast, notStarted, wasInProgress;
  final Animation<double> animation;

  const EventCard({
    super.key,
    required this.text,
    required this.isPast,
    this.notStarted = false,
    required this.animation,
    this.wasInProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: isPast || notStarted
                ? Icon(isPast ? Icons.check_circle : Icons.not_started,
                    key: ValueKey<bool>(isPast),
                    color: isPast
                        ? Colors.green
                        : (notStarted ? Colors.red : Colors.orange))
                : RotationTransition(
                    turns: animation,
                    child: Icon(Icons.autorenew,
                        key: ValueKey<bool>(isPast), color: Colors.orange)),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              AnimatedOpacity(
                opacity: isPast ? 1.0 : (notStarted ? 0.5 : 1.0),
                duration: Duration(seconds: 1),
                child: Text(
                    isPast
                        ? 'Completed'
                        : (notStarted ? 'Not Started' : 'In Progress'),
                    style: TextStyle(
                        color: isPast
                            ? Colors.green
                            : (notStarted ? Colors.red : Colors.orange))),
              ),
              if (isPast && wasInProgress)
                FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: Text('Completed',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
