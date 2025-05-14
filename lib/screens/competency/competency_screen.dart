import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CompetencyInputScreen extends StatefulWidget {
  const CompetencyInputScreen({super.key});

  @override
  _CompetencyInputScreenState createState() => _CompetencyInputScreenState();
}

class _CompetencyInputScreenState extends State<CompetencyInputScreen> {
  final TextEditingController _jsonInputController = TextEditingController();
  String? _copilotResponse;
  List<dynamic> _localMatches = [];
  bool _isLoading = false;

  Future<void> _submitCompetencyData() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://<your-backend-url>/suggest-programs'),
        headers: {'Content-Type': 'application/json'},
        body: _jsonInputController.text,
      );

      final result = json.decode(response.body);

      setState(() {
        _copilotResponse = result['copilot_suggestions'];
        _localMatches = result['local_matches'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('University Program Copilot')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _jsonInputController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Paste learner competency JSON here...'
                ),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitCompetencyData,
              child: _isLoading ? CircularProgressIndicator() : Text('Get Suggestions'),
            ),
            SizedBox(height: 16),
            if (_copilotResponse != null) ...[
              Text('Copilot Suggestions:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(_copilotResponse!),
            ],
            if (_localMatches.isNotEmpty) ...[
              Divider(),
              Text('Matching Kenyan Programs:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._localMatches.map((program) => ListTile(
                    title: Text(program['program']),
                    subtitle: Text('${program['institution']} - ${program['field']} (${program['level']})'),
                  ))
            ]
          ],
        ),
      ),
    );
  }
}
