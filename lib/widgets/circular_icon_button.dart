import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sound_service.dart';

class AdjustButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final double size;
  final double iconSize;

  const AdjustButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.iconColor,
    this.backgroundColor,
    this.gradient,
    this.borderColor,
    this.borderWidth = 1.0,
    this.boxShadow,
    this.size = 45.0,
    this.iconSize = 24.0,
  })  : assert(backgroundColor != null || gradient != null,
            'Either backgroundColor or gradient must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final soundService = Provider.of<SoundService>(context, listen: false);

    return InkWell(
      onTap: () {
        soundService.playTapSound();
        onPressed();
      },
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: gradient == null ? backgroundColor : null,
          gradient: gradient,
          border: borderColor != null
              ? Border.all(
                  color: borderColor!,
                  width: borderWidth,
                )
              : null,
          boxShadow: boxShadow,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
