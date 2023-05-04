import 'package:flutter/material.dart';
import 'package:ground_break/constants/constants.dart';

class DraggableText extends StatefulWidget {
  const DraggableText({
    Key? key,
    required this.customText,
    required this.selectedColor,
    required this.selectedTextStyle,
  }) : super(key: key);

  final String customText;
  final Color selectedColor;
  final TextStyle selectedTextStyle;

  @override
  State<DraggableText> createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText> {
  late Offset dragPosition = const Offset(0.0, 80);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: dragPosition.dx,
          top: dragPosition.dy - 80,
          child: Draggable(
            onDraggableCanceled: (Velocity velocity, Offset offset) {
              setState(() => dragPosition = offset);
            },
            childWhenDragging: Container(),
            feedback: Material(
              color: AppColors.transparent,
              child: Text(
                widget.customText,
                style: widget.selectedTextStyle.copyWith(
                  color: widget.selectedColor,
                ),
              ),
            ),
            child: Text(
              widget.customText,
              style: widget.selectedTextStyle.copyWith(
                color: widget.selectedColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
