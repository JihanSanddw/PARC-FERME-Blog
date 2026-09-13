import 'package:flutter/material.dart';

class TeamColors {
  static const Color mclaren = Color(0xFFEA7600);
  static const Color mercedes = Color(0xFF21E0C0);
  static const Color redBullRacing = Color(0xFF3166B2);
  static const Color ferrari = Color(0xFFD10029);
  static const Color williams = Color(0xFF155CC1);
  static const Color racingBulls = Color(0xFF5582F4);
  static const Color astonMartin = Color(0xFF1F8A66);
  static const Color haas = Color(0xFFC9CECF);
  static const Color audi = Color(0xFFE82900);
  static const Color alpine = Color(0xFF0094D5);
  static const Color cadillac = Color(0xFF9C9C9F);

  static Color getColor(String teamName) {
    switch (teamName.toLowerCase()) {
      case 'mclaren':
        return mclaren;

      case 'mercedes':
        return mercedes;

      case 'red bull racing':
        return redBullRacing;

      case 'ferrari':
        return ferrari;

      case 'williams':
        return williams;

      case 'racing bulls':
        return racingBulls;

      case 'aston martin':
        return astonMartin;

      case 'haas f1 team':
        return haas;

      case 'audi':
        return audi;

      case 'alpine':
        return alpine;

      case 'cadillac':
        return cadillac;

      default:
        return Colors.white;
    }
  }
}