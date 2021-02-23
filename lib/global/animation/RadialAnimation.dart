import 'package:flutter/material.dart';
import 'package:givenergy/global/colors/Color.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class RadialAnimation extends StatefulWidget {
  final double goalCompleted, loadedPercent;
  final firstColor, secondColor, thirdColor;

  const RadialAnimation(
      {Key key,
      this.goalCompleted,
      this.loadedPercent,
      this.firstColor,
      this.secondColor,
      this.thirdColor})
      : super(key: key);

  @override
  _RadialAnimationState createState() => _RadialAnimationState();
}

class _RadialAnimationState extends State<RadialAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _radialAnimationController;
  Animation<double> _progressAnimation;
  final Duration fadeInDuration = Duration(milliseconds: 500);
  final Duration fillDuration = Duration(seconds: 2);

  double progressDegrees = 0;
  var count = 0;

  @override
  void initState() {
    super.initState();
    _radialAnimationController =
        AnimationController(vsync: this, duration: fillDuration);
    _progressAnimation = Tween(begin: 0.0, end: 360.0).animate(CurvedAnimation(
        parent: _radialAnimationController, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {
          progressDegrees = widget.goalCompleted * _progressAnimation.value;
        });
      });

    _radialAnimationController.forward();
  }

  @override
  void dispose() {
    _radialAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 130,
        width: 130,
        child: AnimatedOpacity(
          opacity: progressDegrees > 30 ? 1.0 : 0.5,
          duration: fadeInDuration,
          child: Center(
            child: Text(
              widget.loadedPercent.toString() + " kWh",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.gWhiteColor,
              ),
            ),
          ),
        ),
      ),
      painter: RadialPainter(progressDegrees, widget.firstColor,
          widget.secondColor, widget.thirdColor),
    );
  }
}

class RadialPainter extends CustomPainter {
  final double progressInDegrees;
  final firstColor, secondColor, thirdColor;

  RadialPainter(this.progressInDegrees, this.firstColor, this.secondColor,
      this.thirdColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey[800]
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paint);

    Paint progressPaint = Paint()
      ..shader = LinearGradient(colors: [firstColor, secondColor, thirdColor])
          .createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90),
        math.radians(progressInDegrees),
        false,
        progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
