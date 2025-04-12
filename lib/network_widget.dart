import 'package:flutter/material.dart';
import 'dart:math';

class NetworkWidget extends StatefulWidget {
  const NetworkWidget({super.key});

  @override
  State<NetworkWidget> createState() => _NetworkWidgetState();
}

class _NetworkWidgetState extends State<NetworkWidget>
    with SingleTickerProviderStateMixin {
  final int nodeCount = 45;
  final Random _random = Random();
  late List<Offset> _positions;
  late List<Offset> _velocities;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _positions = List.generate(
      nodeCount,
      (_) => Offset(_random.nextDouble() * 400, _random.nextDouble() * 400),
    );
    _velocities = List.generate(
      nodeCount,
      (_) => Offset(
        (_random.nextDouble() - 0.3) * 2,
        (_random.nextDouble() - 0.3) * 2,
      ),
    );
    _controller =
        AnimationController(
            duration: const Duration(milliseconds: 5000),
            vsync: this,
          )
          ..addListener(_updatePositions)
          ..repeat();
  }

  void _updatePositions() {
    setState(() {
      for (int i = 0; i < nodeCount; i++) {
        _positions[i] += _velocities[i];
        if (_positions[i].dx <= 0 || _positions[i].dx >= 400) {
          _velocities[i] = Offset(-_velocities[i].dx, _velocities[i].dy);
        }
        if (_positions[i].dy <= 0 || _positions[i].dy >= 500) {
          _velocities[i] = Offset(_velocities[i].dx, -_velocities[i].dy);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: NetworkPainter(nodes: _positions));
  }
}

class NetworkPainter extends CustomPainter {
  final List<Offset> nodes;

  NetworkPainter({required this.nodes});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint =
        Paint()
          ..color = Colors.blueGrey.shade200
          ..strokeWidth = 1;

    final nodePaint = Paint()..color = Colors.blueAccent;

    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        if ((nodes[i] - nodes[j]).distance < 120) {
          canvas.drawLine(nodes[i], nodes[j], linePaint);
        }
      }
    }

    for (var node in nodes) {
      canvas.drawCircle(node, 3, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
