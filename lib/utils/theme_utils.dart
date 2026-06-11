import 'package:flutter/material.dart';

Color getColor(String colorName, {int shade = 500}) {
  switch (colorName) {
    case 'indigo':
      return Colors.indigo[shade] ?? Colors.indigo;
    case 'rose':
      return Colors.pink[shade] ?? Colors.pink;
    case 'amber':
      return Colors.amber[shade] ?? Colors.amber;
    case 'emerald':
      return Colors.teal[shade] ?? Colors.teal;
    case 'violet':
      return Colors.purple[shade] ?? Colors.purple;
    case 'slate':
      return Colors.blueGrey[shade] ?? Colors.blueGrey;
    case 'zinc':
      return Colors.grey[shade] ?? Colors.grey;
    case 'yellow':
      return Colors.yellow[shade] ?? Colors.yellow;
    case 'sky':
      return Colors.lightBlue[shade] ?? Colors.lightBlue;
    case 'red':
      return Colors.red[shade] ?? Colors.red;
    case 'orange':
      return Colors.orange[shade] ?? Colors.orange;
    default:
      return Colors.blue;
  }
}

LinearGradient getGradient(String colorName) {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      getColor(colorName, shade: 600),
      getColor(colorName, shade: 400),
    ],
  );
}

LinearGradient getLightGradient(String colorName) {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      getColor(colorName, shade: 100),
      getColor(colorName, shade: 50),
    ],
  );
}

String getCategoryColor(String categoryStr) {
  final cat = categoryStr.toLowerCase();
  if (cat.contains('phone') || cat.contains('laptop') || cat.contains('electronic')) return 'indigo';
  if (cat.contains('shirt') || cat.contains('cloth') || cat.contains('dress')) return 'rose';
  if (cat.contains('shoe') || cat.contains('sneaker')) return 'emerald';
  if (cat.contains('book')) return 'amber';
  if (cat.contains('watch') || cat.contains('jewelry') || cat.contains('accessory')) return 'violet';
  if (cat.contains('fragrance') || cat.contains('perfume')) return 'sky';
  if (cat.contains('skin') || cat.contains('beauty')) return 'pink';
  if (cat.contains('grocery') || cat.contains('food')) return 'green';
  if (cat.contains('home') || cat.contains('furniture')) return 'orange';
  return 'slate';
}

String getCategoryIcon(String categoryStr) {
  final cat = categoryStr.toLowerCase();
  if (cat.contains('phone')) return '📱';
  if (cat.contains('laptop') || cat.contains('computer')) return '💻';
  if (cat.contains('electronic')) return '🎧';
  if (cat.contains('shirt') || cat.contains('cloth') || cat.contains('dress')) return '👕';
  if (cat.contains('shoe') || cat.contains('sneaker')) return '👟';
  if (cat.contains('book')) return '📚';
  if (cat.contains('watch')) return '⌚';
  if (cat.contains('jewelry') || cat.contains('accessory')) return '💍';
  if (cat.contains('fragrance') || cat.contains('perfume')) return '✨';
  if (cat.contains('skin') || cat.contains('beauty')) return '🧴';
  if (cat.contains('grocery') || cat.contains('food')) return '🛒';
  if (cat.contains('home') || cat.contains('furniture')) return '🏠';
  return '📦';
}
