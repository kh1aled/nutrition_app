import 'package:flutter/material.dart';
import '../models/food_item.dart';

class CaloriesDataTable extends StatelessWidget {
  final List<FoodItem> foodList;
  final Function() onChanged;
  final int totalCalories;

  const CaloriesDataTable({
    super.key,
    required this.foodList,
    required this.onChanged,
    required this.totalCalories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Select')),
              DataColumn(label: Text('Food')),
              DataColumn(label: Text('Calories')),
            ],
            rows: foodList.map((food) {
              return DataRow(
                cells: [
                  DataCell(
                    Checkbox(
                      value: food.isSelected,
                      activeColor: Colors.blue,
                      onChanged: (bool? value) {
                        food.isSelected = value ?? false;
                        onChanged();
                      },
                    ),
                  ),
                  DataCell(Text(food.name)),
                  DataCell(Text(food.calories.toString())),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text(
                  'Total Calories',
                  style: TextStyle(color: Colors.blue),
                ),
                content: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      const TextSpan(text: 'You have selected '),
                      TextSpan(
                        text: '$totalCalories',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' calories.'),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Show Total Calories'),
        ),
      ],
    );
  }
}
