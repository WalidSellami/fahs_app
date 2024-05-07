import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {

  final String os;
  final Color? color;
  final Color? bgColor;
  final double? value;

  const LoadingIndicator({super.key, required this.os, this.color, this.bgColor, this.value});

  @override
  Widget build(BuildContext context) {
    if (os == 'android') {
      return CircularProgressIndicator(
        color: color ?? Theme.of(context).colorScheme.primary,
        backgroundColor: bgColor,
        value: value,
        strokeCap: StrokeCap.round,
      );
    } else {
      return CupertinoActivityIndicator(
        color: color ?? Theme.of(context).colorScheme.primary,
      );
    }
  }
}
