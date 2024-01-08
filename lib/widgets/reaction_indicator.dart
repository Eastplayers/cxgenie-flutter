import 'package:flutter/material.dart';

class ReactionIndicator extends StatelessWidget {
  const ReactionIndicator({
    super.key,
    required this.child,
  });

  // /// The id of the current user.
  final Widget child;

  // /// {@macro message}
  // final Message message;

  // /// The callback to perform when the widget is tapped or clicked.
  // final VoidCallback onTap;

  // /// {@macro reverse}
  // final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(0, 0, 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 22 * 6.0,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            // onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }
}
