import 'dart:convert';
import 'package:http/http.dart' as http;

const String BASE_URL = "http://192.168.5.100:3000"; // CHANGE THIS TO YOUR IP AND IT WILL REACH THE API

enum FileState { Default, Charged, Decharged }

class FileStatus {
  final String id;
  final FileState state;

  FileStatus({required this.id, required this.state});

  factory FileStatus.fromJson(Map<String, dynamic> json) {
    String status = json['status'].toLowerCase();
    FileState state;
    if (status == 'default') {
      state = FileState.Default;
    } else if (status == 'charge') {
      state = FileState.Charged;
    } else {
      state = FileState.Decharged;
    }
    return FileStatus(id: json['id'].toString(), state: state);
  }
}

class ApiService {
  Future<String> loadFile(String number) async {
    final response = await http.post(Uri.parse('$BASE_URL/load/$number'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'] ?? 'Loaded';
    } else {
      throw Exception('Failed to load file');
    }
  }

  Future<String> unloadFile(String number) async {
    final response = await http.post(Uri.parse('$BASE_URL/unload/$number'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'] ?? 'Unloaded';
    } else {
      throw Exception('Failed to unload file');
    }
  }

  Future<List<FileStatus>> getStatuses() async {
    final response = await http.get(Uri.parse('$BASE_URL/status'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => FileStatus.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch statuses');
    }
  }
}
