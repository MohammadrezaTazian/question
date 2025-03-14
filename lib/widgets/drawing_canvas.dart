import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'shapes/basic_shapes.dart';

class DrawingCanvas extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onSave;

  const DrawingCanvas({Key? key, required this.onSave}) : super(key: key);

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<DrawingPoint> points = [];
  Color selectedColor = Colors.black;
  double selectedWidth = 2.0;
  bool isDrawing = false;
  bool isShapeMode = false;
  BasicShape? selectedShape;
  Offset? shapeStart;
  Offset? shapeEnd;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text('رسم شکل',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 160),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildColorButton(Colors.black),
                                _buildColorButton(Colors.blue),
                                _buildColorButton(Colors.red),
                                _buildColorButton(Colors.green),
                                _buildColorButton(Colors.orange),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildWidthButton(1.0, 'نازک'),
                                const SizedBox(width: 4),
                                _buildWidthButton(2.0, 'متوسط'),
                                const SizedBox(width: 4),
                                _buildWidthButton(3.0, 'ضخیم'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: _buildShapesBar(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onPanStart: _handlePanStart,
                  onPanUpdate: _handlePanUpdate,
                  onPanEnd: _handlePanEnd,
                  child: CustomPaint(
                    painter: DrawingPainter(
                      points: points,
                      previewShape:
                          isShapeMode && shapeStart != null && shapeEnd != null
                              ? _generatePreviewShape()
                              : null,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 60),
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    final isSelected = selectedColor == color;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: () => setState(() => selectedColor = color),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildWidthButton(double width, String label) {
    final isSelected = selectedWidth == width;
    return InkWell(
      onTap: () => setState(() => selectedWidth = width),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.blue : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildShapesBar() {
    final allShapes = [null, ...ShapeGenerator.shapes];

    return Container(
      margin: const EdgeInsets.only(top: 4),
      height: 76,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          _scrollController.position.moveTo(
            _scrollController.offset - details.delta.dx,
            clamp: true,
          );
        },
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: allShapes.length,
          itemBuilder: (context, index) {
            final shape = allShapes[index];
            final isShapeSelected = shape == selectedShape;
            final isFreehandSelected = shape == null && !isShapeMode;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (shape == null) {
                      isShapeMode = false;
                      selectedShape = null;
                    } else {
                      isShapeMode = true;
                      selectedShape = shape;
                    }
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: (isShapeSelected || isFreehandSelected)
                        ? Colors.blue.shade50
                        : Colors.white,
                    border: Border.all(
                      color: (isShapeSelected || isFreehandSelected)
                          ? Colors.blue
                          : Colors.grey,
                      width: (isShapeSelected || isFreehandSelected) ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        shape?.icon ?? Icons.edit,
                        color: (isShapeSelected || isFreehandSelected)
                            ? Colors.blue
                            : Colors.black,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shape?.name ?? 'رسم آزاد',
                        style: TextStyle(
                          fontSize: 11,
                          color: (isShapeSelected || isFreehandSelected)
                              ? Colors.blue
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  DrawingPoint? _generatePreviewShape() {
    if (selectedShape == null || shapeStart == null || shapeEnd == null) {
      return null;
    }

    final bounds = Rect.fromPoints(shapeStart!, shapeEnd!);
    final points = selectedShape!.generatePoints(bounds);

    return DrawingPoint(
      points: points,
      color: selectedColor,
      width: selectedWidth,
      shapeName: selectedShape!.name,
    );
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() {
      if (isShapeMode) {
        shapeStart = details.localPosition;
        shapeEnd = details.localPosition;
      } else {
        isDrawing = true;
        points.add(DrawingPoint(
          points: [details.localPosition],
          color: selectedColor,
          width: selectedWidth,
        ));
      }
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      if (isShapeMode) {
        shapeEnd = details.localPosition;
      } else if (isDrawing) {
        points.last.points.add(details.localPosition);
      }
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    if (isShapeMode &&
        shapeStart != null &&
        shapeEnd != null &&
        selectedShape != null) {
      final shape = _generatePreviewShape();
      if (shape != null) {
        setState(() {
          points.add(DrawingPoint(
            points: shape.points,
            color: shape.color,
            width: shape.width,
            shapeName: shape.shapeName,
          ));
          shapeStart = null;
          shapeEnd = null;
        });
      }
    } else {
      setState(() {
        isDrawing = false;
      });
    }
  }

  void _saveDrawing() {
    if (points.isNotEmpty) {
      List<Map<String, dynamic>> drawingData = [];

      for (var point in points) {
        drawingData.add({
          'points': point.points,
          'color': point.color.value,
          'width': point.width,
          'shapeName': point.shapeName,
        });
      }
      widget.onSave(drawingData);
    }
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              setState(() => points.clear());
            },
            icon: const Icon(Icons.clear),
            label: const Text('پاک کردن'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _saveDrawing,
            icon: const Icon(Icons.save),
            label: const Text('ذخیره'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {}); // Trigger rebuild when scrolling
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class DrawingPoint {
  final List<Offset> points;
  final Color color;
  final double width;
  final String? shapeName;

  DrawingPoint({
    required this.points,
    required this.color,
    required this.width,
    this.shapeName,
  });
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;
  final DrawingPoint? previewShape;

  DrawingPainter({
    required this.points,
    this.previewShape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var point in points) {
      _drawPoints(canvas, point);
    }

    if (previewShape != null) {
      _drawPoints(canvas, previewShape!);
    }
  }

  void _drawPoints(Canvas canvas, DrawingPoint point) {
    Paint paint = Paint()
      ..color = point.color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = point.width
      ..style = PaintingStyle.stroke;

    if (point.points.length < 2) return;

    final path = Path();
    path.moveTo(point.points[0].dx, point.points[0].dy);

    for (int i = 1; i < point.points.length; i++) {
      path.lineTo(point.points[i].dx, point.points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
