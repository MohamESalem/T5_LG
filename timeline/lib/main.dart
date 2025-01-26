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
  List<bool> isCompleted = [false, false, false, false, false, false];
  List<bool> isInProgress = [false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations() async {
    for (int i = 0; i < isCompleted.length; i++) {
      setState(() {
        isInProgress[i] = true;
      });
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        isInProgress[i] = false;
        isCompleted[i] = true;
      });
    }
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
                isPast: isCompleted[0],
                isInProgress: isInProgress[0],
                text: 'Selected Movie',
                icon: Icons.movie),
            _buildTimelineTile(
                isPast: isCompleted[1],
                isInProgress: isInProgress[1],
                text: 'Chosen Seats',
                icon: Icons.event_seat),
            _buildTimelineTile(
                isPast: isCompleted[2],
                isInProgress: isInProgress[2],
                text: 'Added Snacks',
                icon: Icons.fastfood),
            _buildTimelineTile(
                isPast: isCompleted[3],
                isInProgress: isInProgress[3],
                text: 'Payment',
                icon: Icons.payment),
            _buildTimelineTile(
                isPast: isCompleted[4],
                isInProgress: isInProgress[4],
                text: 'Review Order',
                icon: Icons.receipt),
            _buildTimelineTile(
                isLast: true,
                isPast: isCompleted[5],
                isInProgress: isInProgress[5],
                text: 'Booking Confirmed',
                icon: Icons.check_circle),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTile({
    bool isFirst = false,
    bool isLast = false,
    bool isPast = false,
    bool isInProgress = false,
    required String text,
    required IconData icon,
  }) {
    return CustomTimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      isPast: isPast,
      isInProgress: isInProgress,
      text: text,
      icon: icon,
    );
  }
}

class CustomTimelineTile extends StatefulWidget {
  final bool isFirst, isLast, isPast, isInProgress;
  final String text;
  final IconData icon;

  const CustomTimelineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.isInProgress,
    required this.text,
    required this.icon,
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
        if (!widget.isPast && !widget.isInProgress) {
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
                : (widget.isInProgress ? Colors.orange : Colors.red),
          ),
          indicatorStyle: IndicatorStyle(
            width: 40,
            color: widget.isPast
                ? Colors.green
                : (widget.isInProgress ? Colors.orange : Colors.red),
            iconStyle: IconStyle(
              iconData: widget.isPast
                  ? widget.icon
                  : (widget.isInProgress ? Icons.autorenew : Icons.not_started),
              color: Colors.white,
            ),
          ),
          endChild: EventCard(
            text: widget.text,
            isPast: widget.isPast,
            isInProgress: widget.isInProgress,
            animation: _animation,
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String text;
  final bool isPast, isInProgress;
  final Animation<double> animation;

  const EventCard({
    super.key,
    required this.text,
    required this.isPast,
    required this.isInProgress,
    required this.animation,
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
            child: isPast || !isInProgress
                ? Icon(isPast ? Icons.check_circle : Icons.not_started,
                    key: ValueKey<bool>(isPast),
                    color: isPast
                        ? Colors.green
                        : (isInProgress ? Colors.orange : Colors.red))
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
                opacity: isPast ? 1.0 : (isInProgress ? 1.0 : 0.5),
                duration: Duration(seconds: 1),
                child: Text(
                    isPast
                        ? 'Completed'
                        : (isInProgress ? 'In Progress' : 'Not Started'),
                    style: TextStyle(
                        color: isPast
                            ? Colors.green
                            : (isInProgress ? Colors.orange : Colors.red))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
