import 'package:flutter/material.dart';
import 'dart:math' as math;

class BasicShape {
  final String name;
  final List<Offset> Function(Rect bounds) generatePoints;
  final IconData icon;

  BasicShape({
    required this.name,
    required this.generatePoints,
    required this.icon,
  });
}

class ShapeGenerator {
  static final List<BasicShape> shapes = [
    BasicShape(
      name: 'مربع',
      icon: Icons.square_outlined,
      generatePoints: (Rect bounds) {
        final size = math.min(bounds.width, bounds.height);
        final centerX = bounds.left + bounds.width / 2;
        final centerY = bounds.top + bounds.height / 2;
        final halfSize = size / 2;

        return [
          Offset(centerX - halfSize, centerY - halfSize),
          Offset(centerX + halfSize, centerY - halfSize),
          Offset(centerX + halfSize, centerY + halfSize),
          Offset(centerX - halfSize, centerY + halfSize),
          Offset(centerX - halfSize, centerY - halfSize),
        ];
      },
    ),
    BasicShape(
      name: 'مستطیل',
      icon: Icons.rectangle_outlined,
      generatePoints: (Rect bounds) {
        const padding = 20.0;
        return [
          Offset(bounds.left + padding, bounds.top + padding),
          Offset(bounds.right - padding, bounds.top + padding),
          Offset(bounds.right - padding, bounds.bottom - padding),
          Offset(bounds.left + padding, bounds.bottom - padding),
          Offset(bounds.left + padding, bounds.top + padding),
        ];
      },
    ),
    BasicShape(
      name: 'مثلث',
      icon: Icons.change_history,
      generatePoints: (Rect bounds) {
        final centerX = bounds.left + bounds.width / 2;
        const padding = 20.0;
        return [
          Offset(centerX, bounds.top + padding),
          Offset(bounds.right - padding, bounds.bottom - padding),
          Offset(bounds.left + padding, bounds.bottom - padding),
          Offset(centerX, bounds.top + padding),
        ];
      },
    ),
    BasicShape(
      name: 'ذوزنقه',
      icon: Icons.crop_landscape,
      generatePoints: (Rect bounds) {
        final inset = bounds.width * 0.2;
        const padding = 20.0;
        final top = bounds.top + padding;
        final bottom = bounds.bottom - padding;
        final left = bounds.left + padding;
        final right = bounds.right - padding;

        return [
          Offset(left + inset, top),
          Offset(right - inset, top),
          Offset(right, bottom),
          Offset(left, bottom),
          Offset(left + inset, top),
        ];
      },
    ),
    BasicShape(
      name: 'دایره',
      icon: Icons.circle_outlined,
      generatePoints: (Rect bounds) {
        final List<Offset> points = [];
        const padding = 20.0;
        final centerX = bounds.left + bounds.width / 2;
        final centerY = bounds.top + bounds.height / 2;
        final radius = math.min(bounds.width, bounds.height) / 2 - padding;
        const steps = 32;

        for (int i = 0; i <= steps; i++) {
          final theta = (i / steps) * 2 * math.pi;
          points.add(Offset(
            centerX + radius * math.cos(theta),
            centerY + radius * math.sin(theta),
          ));
        }
        return points;
      },
    ),
    BasicShape(
      name: 'فلش راست',
      icon: Icons.arrow_right_alt,
      generatePoints: (Rect bounds) {
        const padding = 20.0;
        final left = bounds.left + padding;
        final right = bounds.right - padding;
        final centerY = bounds.top + bounds.height / 2;
        final headSize = (right - left) * 0.2;

        return [
          Offset(left, centerY),
          Offset(right - headSize, centerY),
          Offset(right - headSize, centerY - headSize),
          Offset(right, centerY),
          Offset(right - headSize, centerY + headSize),
          Offset(right - headSize, centerY),
        ];
      },
    ),
    BasicShape(
      name: 'فلش چپ',
      icon: Icons.arrow_left,
      generatePoints: (Rect bounds) {
        const padding = 20.0;
        final left = bounds.left + padding;
        final right = bounds.right - padding;
        final centerY = bounds.top + bounds.height / 2;
        final headSize = (right - left) * 0.2;

        return [
          Offset(right, centerY),
          Offset(left + headSize, centerY),
          Offset(left + headSize, centerY - headSize),
          Offset(left, centerY),
          Offset(left + headSize, centerY + headSize),
          Offset(left + headSize, centerY),
        ];
      },
    ),
    BasicShape(
      name: 'فلش بالا',
      icon: Icons.arrow_upward,
      generatePoints: (Rect bounds) {
        const padding = 20.0;
        final top = bounds.top + padding;
        final bottom = bounds.bottom - padding;
        final centerX = bounds.left + bounds.width / 2;
        final headSize = (bottom - top) * 0.2;

        return [
          Offset(centerX, top),
          Offset(centerX - headSize, top + headSize),
          Offset(centerX, top),
          Offset(centerX + headSize, top + headSize),
          Offset(centerX, top),
          Offset(centerX, bottom),
        ];
      },
    ),
    BasicShape(
      name: 'فلش پایین',
      icon: Icons.arrow_downward,
      generatePoints: (Rect bounds) {
        const padding = 20.0;
        final top = bounds.top + padding;
        final bottom = bounds.bottom - padding;
        final centerX = bounds.left + bounds.width / 2;
        final headSize = (bottom - top) * 0.2;

        return [
          Offset(centerX, bottom),
          Offset(centerX - headSize, bottom - headSize),
          Offset(centerX, bottom),
          Offset(centerX + headSize, bottom - headSize),
          Offset(centerX, bottom),
          Offset(centerX, top),
        ];
      },
    ),
    BasicShape(
      name: 'فلش مورب ↗',
      icon: Icons.north_east,
      generatePoints: (Rect bounds) {
        const padding = 20.0;
        final left = bounds.left + padding;
        final right = bounds.right - padding;
        final top = bounds.top + padding;
        final bottom = bounds.bottom - padding;
        final headSize = (right - left) * 0.2;
        final angle = math.atan2(bottom - top, right - left);

        return [
          Offset(left, bottom),
          Offset(right - headSize * math.cos(angle),
              top + headSize * math.sin(angle)),
          Offset(right - headSize * (math.cos(angle) + math.sin(angle)),
              top + headSize * (math.sin(angle) - math.cos(angle))),
          Offset(right, top),
          Offset(right - headSize * (math.cos(angle) - math.sin(angle)),
              top + headSize * (math.sin(angle) + math.cos(angle))),
          Offset(right - headSize * math.cos(angle),
              top + headSize * math.sin(angle)),
        ];
      },
    ),
    BasicShape(
      name: 'فلش مورب ↙',
      icon: Icons.south_west,
      generatePoints: (Rect bounds) {
        const padding = 20.0;
        final left = bounds.left + padding;
        final right = bounds.right - padding;
        final top = bounds.top + padding;
        final bottom = bounds.bottom - padding;
        final headSize = (right - left) * 0.2;
        final angle = math.atan2(bottom - top, right - left);

        return [
          Offset(right, top),
          Offset(left + headSize * math.cos(angle),
              bottom - headSize * math.sin(angle)),
          Offset(left + headSize * (math.cos(angle) + math.sin(angle)),
              bottom - headSize * (math.sin(angle) - math.cos(angle))),
          Offset(left, bottom),
          Offset(left + headSize * (math.cos(angle) - math.sin(angle)),
              bottom - headSize * (math.sin(angle) + math.cos(angle))),
          Offset(left + headSize * math.cos(angle),
              bottom - headSize * math.sin(angle)),
        ];
      },
    ),
  ];
}
