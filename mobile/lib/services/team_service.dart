import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/team.dart';
import '../models/driver.dart';

class TeamService {
  static const String baseUrl = 'http://192.168.1.8:3026';

  // GET semua teams
  Future<List<Team>> getTeams() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/teams'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Team.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load teams');
    }
  }

  // GET drivers berdasarkan team
  Future<List<Driver>> getDriversByTeam(int teamId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/teams/$teamId/drivers'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Driver.fromJson(json))
          .toList();
    } else if (response.statusCode == 404) {
      throw Exception('Team not found');
    } else {
      throw Exception('Failed to load drivers');
    }
  }
}