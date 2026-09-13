import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  static const String baseUrl = 'http://192.168.1.8:3026';

  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/posts'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      final List<dynamic> data = jsonResponse['data'];

      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> getPostById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/posts/$id'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      return Post.fromJson(jsonResponse['data']);
    } else if (response.statusCode == 404) {
      throw Exception('Post not found');
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<int> createPost({
    required String title,
    String? excerpt,
    required String content,
    String? image,
    required int idCategory,
    required String authorName,
    int? idDriver,
    int? idTeam,
    int? idRace,
    bool isFeatured = false,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'excerpt': excerpt,
        'content': content,
        'image': image,
        'id_category': idCategory,
        'author_name': authorName,
        'id_driver': idDriver,
        'id_team': idTeam,
        'id_race': idRace,
        'is_featured': isFeatured,
      }),
    );

    print('STATUS CODE: ${response.statusCode}');
    print('RESPONSE BODY: ${response.body}');

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);

      return jsonResponse['data']['id_post'];
    } else if (response.statusCode == 400) {
      final jsonResponse = jsonDecode(response.body);

      throw Exception(
        jsonResponse['message'] ?? 'Invalid article data',
      );
    } else {
      throw Exception(
        'Server error ${response.statusCode}: ${response.body}',
      );
    }
  }

  Future<void> updatePost({
    required int id,
    required String title,
    String? excerpt,
    required String content,
    String? image,
    required int idCategory,
    required String authorName,
    int? idDriver,
    int? idTeam,
    int? idRace,
    bool isFeatured = false,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/posts/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'excerpt': excerpt,
        'content': content,
        'image': image,
        'id_category': idCategory,
        'author_name': authorName,
        'id_driver': idDriver,
        'id_team': idTeam,
        'id_race': idRace,
        'is_featured': isFeatured,
      }),
    );

    print('UPDATE STATUS CODE: ${response.statusCode}');
    print('UPDATE RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      throw Exception('Invalid article data');
    } else if (response.statusCode == 404) {
      throw Exception('Post not found');
    } else {
      throw Exception(
        'Server error ${response.statusCode}: ${response.body}',
      );
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/posts/$id'));

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Post not found');
    } else {
      throw Exception('Failed to delete article');
    }
  }
}
