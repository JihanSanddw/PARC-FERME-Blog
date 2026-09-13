import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/race.dart';

class RaceService {
  static const String baseUrl = 'http://192.168.1.8:3026';

  Future<List<Race>> getUpcomingRaces() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/races/upcoming'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Race.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load upcoming races');
    }
  }


  Future<List<Race>> getCompletedRaces() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/races/completed'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Race.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load completed races');
    }
  }
}