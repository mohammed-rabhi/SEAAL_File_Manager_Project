import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  // Simple, adjustable palette — change these if you want
  static const Color kPrimary = Color(0xFF1E88E5);   // modern blue
  static const Color kAccent = Color(0xFF43A047);    // modern green
  static const Color kDanger = Color(0xFFEF6C6C);    // gentle red
  static const Color kBg = Color(0xFFF7FAFC);        // very light background

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('SEAAL File Manager'),
        centerTitle: true,
        backgroundColor: kPrimary,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      'File Manager',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter the file ID and choose Load or Unload.',
                      style: TextStyle(color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),

                    // Input
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'File Number',
                        hintText: 'e.g. 4',
                        prefixIcon: Icon(Icons.numbers, color: kPrimary),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Buttons — keep logic exactly the same, just nicer visuals
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: appState.isLoading
                                ? null
                                : () {
                              FocusScope.of(context).unfocus();
                              appState.loadFile(_controller.text.trim());
                            },
                            icon: const Icon(Icons.cloud_upload),
                            label: const Text('Load File'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: appState.isLoading
                                ? null
                                : () {
                              FocusScope.of(context).unfocus();
                              appState.unloadFile(_controller.text.trim());
                            },
                            icon: const Icon(Icons.cloud_download),
                            label: const Text('Unload File'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kDanger,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Status area — kept simple and clear
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          // small indicator
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _statusColor(appState.statusMessage),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              appState.statusMessage.isNotEmpty
                                  ? appState.statusMessage
                                  : 'No status yet',
                              style: TextStyle(
                                fontSize: 15,
                                color: appState.statusMessage.isNotEmpty ? Colors.black87 : Colors.black45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (appState.isLoading) const SizedBox(width: 8),
                          if (appState.isLoading) const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),

                    // small hint
                    const Text(
                      'Tip: Use IDs 1–10 for testing (auto-created on the server).',
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String msg) {
    final lc = msg.toLowerCase();
    if (lc.contains('loaded') || lc.contains('loaded successfully') || lc.contains('loaded')) return kAccent;
    if (lc.contains('unloaded') || lc.contains('decharg') || lc.contains('decharge')) return kDanger;
    if (lc.contains('error')) return Colors.orange.shade700;
    return Colors.grey.shade300;
  }
}
