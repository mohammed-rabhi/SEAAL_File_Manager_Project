import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  final ApiService api;
  String statusMessage = 'Idle';
  bool isLoading = false;
  List<FileStatus> files = [];

  AppState(this.api);

  Future<void> loadFile(String id) async {
    _setLoading(true);
    try {
      statusMessage = await api.loadFile(id);
    } catch (e) {
      statusMessage = "Error: ${e.toString()}";
    }
    _setLoading(false);
    await fetchStatuses();
  }

  Future<void> unloadFile(String id) async {
    _setLoading(true);
    try {
      statusMessage = await api.unloadFile(id);
    } catch (e) {
      statusMessage = "Error: ${e.toString()}";
    }
    _setLoading(false);
    await fetchStatuses();
  }

  Future<void> fetchStatuses() async {
    try {
      files = await api.getStatuses();
    } catch (e) {
      statusMessage = "Error fetching statuses";
    }
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}


