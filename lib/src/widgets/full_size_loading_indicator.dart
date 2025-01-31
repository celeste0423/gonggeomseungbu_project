import 'package:flutter/material.dart';
import 'package:ggsb_project/src/widgets/loading_indicator.dart';

class FullSizeLoadingIndicator extends StatelessWidget {
  final Color? backgroundColor;
  const FullSizeLoadingIndicator({this.backgroundColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.white,
      child: Center(
        child: loadingIndicator(),
      ),
    );
  }
}
