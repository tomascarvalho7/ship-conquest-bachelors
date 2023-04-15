import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconSwitch extends StatelessWidget {
  final bool condition;
  final IconData icon;
  final double size;
  final Color enabled;
  final Color disabled;
  // constructor
  const IconSwitch({super.key, required this.condition, required this.icon, required this.size, required this.enabled, required this.disabled});

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return Icon(icon, size: size, color: enabled);
    } else {
      return Icon(icon, size: size, color: disabled);
    }
  }
}