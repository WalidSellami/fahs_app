import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {

  final String os;
  final Color? color;
  final Color? bgColor;
  final double? value;
  final double? strokeWidth;

  const LoadingIndicator({super.key, required this.os, this.color, this.bgColor, this.value, this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    if (os == 'android') {
      return CircularProgressIndicator(
        color: color ?? Theme.of(context).colorScheme.primary,
        backgroundColor: bgColor,
        value: value,
        strokeWidth: strokeWidth ?? 4.0,
        strokeCap: StrokeCap.round,
      );
    } else {
      return CupertinoActivityIndicator(
        color: color ?? Theme.of(context).colorScheme.primary,
      );
    }
  }
}
