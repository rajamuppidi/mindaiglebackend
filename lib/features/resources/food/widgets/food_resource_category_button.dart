import 'package:flutter/material.dart';

class FoodResourceCategoryButton extends StatelessWidget {
  final String category;
  final VoidCallback onPressed;
  final bool isSelected;

  const FoodResourceCategoryButton({
    super.key,
    required this.category,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor:
            isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: isSelected ? 2 : 1,
      ),
      child: Text(category.capitalize()),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
