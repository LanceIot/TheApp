import 'package:flutter/material.dart';

class BottomNavWidget extends StatelessWidget {
  BottomNavWidget({
    super.key,
    this.onTap,
    this.icon,
  });

  final void Function()? onTap;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 36,
        width: 36,
        child: icon,
      ),
    );
  }
}
