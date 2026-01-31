class FoodItem {
  final String name;
  final int calories;
  bool isSelected;

  FoodItem({
    required this.name,
    required this.calories,
    this.isSelected = false,
  });
}