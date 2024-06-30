import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<Motor>> getItems() async {
    final response = await http.get(Uri.parse('$baseUrl/list.php'));

    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Motor.fromJson(item)).toList();
  }

  Future<List<Motor>> searchItems(String keyword) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?keyword=$keyword'));

    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Motor.fromJson(item)).toList();
  }
}
