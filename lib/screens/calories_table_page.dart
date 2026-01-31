import 'package:flutter/material.dart';
import '../data/food_data.dart';
import '../widgets/calories_data_table.dart';

class CaloriesTablePage extends StatefulWidget {
  const CaloriesTablePage({super.key});

  @override
  State<CaloriesTablePage> createState() => _CaloriesTablePageState();
}

class _CaloriesTablePageState extends State<CaloriesTablePage> {
  int totalCalories = 0;

  void calculateTotalCalories() {
    setState(() {
      totalCalories = foodList
          .where((food) => food.isSelected)
          .fold(0, (sum, food) => sum + food.calories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back , color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Nutrition Tracker' , style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CaloriesDataTable(
                foodList: foodList,
                totalCalories: totalCalories,
                onChanged: calculateTotalCalories,
              ),
              const SizedBox(height: 20),
              Text(
                'Total Calories: $totalCalories',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
