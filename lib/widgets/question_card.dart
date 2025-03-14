import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final List<Map<String, dynamic>>? drawing;

  const QuestionCard({
    Key? key,
    required this.question,
    this.drawing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildQuestionContent(),
        ),
      ),
    );
  }

  Widget _buildQuestionContent() {
    final parts = question.split('[شکل]');
    List<Widget> contentWidgets = [];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].trim().isNotEmpty) {
        contentWidgets.add(
          _buildTextWithFormulas(parts[i].trim()),
        );
      }

      if (i < parts.length - 1 && drawing != null) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  painter: SavedDrawingPainter(
                    drawingData: drawing!,
                    maxWidth: constraints.maxWidth,
                  ),
                  size: Size(constraints.maxWidth, 200),
                );
              },
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: contentWidgets,
    );
  }

  Widget _buildTextWithFormulas(String text) {
    final List<InlineSpan> spans = [];
    final parts = text.split(r'$');

    for (var i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        if (parts[i].isNotEmpty) {
          spans.add(TextSpan(
            text: parts[i],
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ));
        }
      } else {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Math.tex(
              parts[i],
              textStyle: const TextStyle(fontSize: 18),
              onErrorFallback: (error) => Text(
                parts[i],
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(children: spans),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class SavedDrawingPainter extends CustomPainter {
  final List<Map<String, dynamic>> drawingData;
  final double maxWidth;

  SavedDrawingPainter({
    required this.drawingData,
    required this.maxWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var pointData in drawingData) {
      final points = (pointData['points'] as List).cast<Offset>();
      final color = Color(pointData['color'] as int);
      final width = pointData['width'] as double;

      Paint paint = Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = width
        ..style = PaintingStyle.stroke;

      if (points.length < 2) continue;

      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);

      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SavedDrawingPainter oldDelegate) => true;
}
