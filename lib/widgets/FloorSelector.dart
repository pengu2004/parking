import 'package:flutter/material.dart';

class FloorSelector extends StatelessWidget {
  final List<String> floors;
  final int selectedIndex;
  final Function(int) onFloorSelected;

  const FloorSelector({
    super.key,
    required this.floors,
    required this.selectedIndex,
    required this.onFloorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.green.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(floors.length, (index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => {
              onFloorSelected(index),
              print("Selected floor: ${floors[index]}"),
              print(index)
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                floors[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
