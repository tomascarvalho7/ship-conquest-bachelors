import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String content;
  final bool isSelected;
  final void Function() onClick;

  const FilterButton(
      {super.key,
        required this.content,
        required this.isSelected,
        required this.onClick});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.32,
      child: ElevatedButton(
        onPressed: onClick,
        style: isSelected
            ? Theme.of(context).elevatedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.primary),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          )),
        )
            : Theme.of(context).elevatedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.secondary),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          )),
        ),
        child: isSelected
            ? Text(content,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 15.0, color: Colors.white))
            : Text(content,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 15.0)),
      ),
    );
  }
}