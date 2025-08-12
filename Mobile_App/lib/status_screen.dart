import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../state/app_state.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  static const Color kPrimary = Color(0xFF1E88E5); // modern blue
  static const Color kAccent = Color(0xFF43A047);  // modern green
  static const Color kDanger = Color(0xFFEF5350);  // soft red
  static const Color kNeutral = Color(0xFFBDBDBD); // grey for default

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text("File Status"),
        centerTitle: true,
        backgroundColor: kPrimary,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async => await appState.fetchStatuses(),
        child: appState.files.isEmpty
            ? ListView(
          children: const [
            SizedBox(height: 120),
            Center(
              child: Text(
                "No files found.\nPull down to refresh.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
          ],
        )
            : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: appState.files.length,
          itemBuilder: (context, index) {
            final file = appState.files[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                leading: CircleAvatar(
                  backgroundColor: _statusColor(file.state),
                  radius: 10,
                ),
                title: Text(
                  "File #${file.id}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _statusLabel(file.state),
                  style: TextStyle(
                    fontSize: 14,
                    color: _statusColor(file.state),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _statusColor(FileState state) {
    switch (state) {
      case FileState.Charged:
        return kAccent;
      case FileState.Decharged:
        return kDanger;
      case FileState.Default:
        return kNeutral;
    }
  }

  String _statusLabel(FileState state) {
    switch (state) {
      case FileState.Charged:
        return "Loaded";
      case FileState.Decharged:
        return "Unloaded";
      case FileState.Default:
        return "Default";
    }
  }
}
