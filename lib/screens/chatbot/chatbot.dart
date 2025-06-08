import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:techhackportal/config.dart';

class ChatBotPage extends StatefulWidget {

  final List<Map<String, dynamic>> schoolHistory;
  const ChatBotPage({super.key, required this.schoolHistory});
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final List<Map<String, String>> _competencyMessages = [];
  final ScrollController _scrollController = ScrollController();
  final ScrollController _competencyScrollController = ScrollController();
  bool _isBotTyping = false;
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _sendMessage(String message, {bool isCompetencyTab = false}) async {
    if (message.trim().isEmpty) return;

    setState(() {
      if (isCompetencyTab) {
        _competencyMessages.add({'sender': 'user', 'text': message});
      } else {
        _messages.add({'sender': 'user', 'text': message});
      }
      _isBotTyping = true;
    });

    _scrollToBottom(isCompetencyTab);

    try {
      final response = await http.post(
        Uri.parse(CHATBOT), // Replace with your endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      String botResponse =
          'Oops! Something went wrong. Please try again later.';

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        botResponse = data['response'] ?? botResponse;
      }

      await _animateBotResponse(botResponse, isCompetencyTab: isCompetencyTab);
    } catch (e) {
      await _animateBotResponse(
          'Oops! Something went wrong. Please try again later.',
          isCompetencyTab: isCompetencyTab);
    }

    _controller.clear();
    _isBotTyping = false;
  }

  Future<void> _animateBotResponse(String fullResponse,
      {bool isCompetencyTab = false}) async {
    String displayedText = '';
    for (int i = 0; i < fullResponse.length; i++) {
      await Future.delayed(Duration(milliseconds: 20));
      displayedText += fullResponse[i];

      if (i == 0) {
        setState(() {
          if (isCompetencyTab) {
            _competencyMessages.add({'sender': 'bot', 'text': displayedText});
          } else {
            _messages.add({'sender': 'bot', 'text': displayedText});
          }
        });
      } else {
        setState(() {
          if (isCompetencyTab) {
            _competencyMessages[_competencyMessages.length - 1]['text'] =
                displayedText;
          } else {
            _messages[_messages.length - 1]['text'] = displayedText;
          }
        });
      }
      _scrollToBottom(isCompetencyTab);
    }
  }

  void _scrollToBottom(bool isCompetencyTab) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller =
          isCompetencyTab ? _competencyScrollController : _scrollController;
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['sender'] == 'user';
    final bgColor = isUser ? Colors.blue.shade100 : Colors.grey.shade300;
    final avatar = isUser
        ? CircleAvatar(
            backgroundColor: Colors.deepOrangeAccent,
            child: Icon(Icons.person, color: Colors.white),
          )
        : CircleAvatar(
            backgroundColor: Color(0xFF006600),
            child: Icon(Icons.support_agent_outlined, color: Colors.white),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) avatar,
          SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message['text'] ?? '',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          if (isUser) SizedBox(width: 8),
          if (isUser) avatar,
        ],
      ),
    );
  }

String _generateCompetencyPrompt() {
  String prompt = "I have a student with the following school history and competencies:\n\n";

  //If the school history is empty, return a message
  if (widget.schoolHistory.isEmpty) {
    return "The student has no school history or competencies to analyze.";
  }

  for (int i = 0; i < widget.schoolHistory.length; i++) {
    final school = widget.schoolHistory[i];
    prompt += "🏫 School: ${school['schoolName']} (Code: ${school['schoolCode']})\n";
    prompt += "- Admission Number: ${school['admissionNumber']}\n";
    prompt += "- Enrollment Date: ${school['enrollmentDate']}\n";
    prompt += "- Status: ${school['currentStatus']}\n";

    final competencies = school['competencies'] as List<dynamic>?;
    if (competencies != null && competencies.isNotEmpty) {
      prompt += "  Competencies:\n";
      for (int j = 0; j < competencies.length; j++) {
        final c = competencies[j];
        prompt +=
            "    ${j + 1}️⃣ Competency Name: ${c['competencyName']}\n";
        prompt += "    - Level: ${c['achievementLevel']}\n";
        prompt += "    - Description: ${c['description']}\n";
        prompt += "    - Grade Level: ${c['gradeLevel']}\n";
      }
    } else {
      prompt += "  No competencies listed.\n";
    }

    prompt += "\n"; // space between schools
  }

  prompt +=
      "Based on this data, suggest career pathways, courses, or activities that might align with these competencies and school history. Please be detailed and tailor your suggestions to each competency and school context.";

  return prompt;
}

  void _getCompetencyAdvice() {
    final prompt = _generateCompetencyPrompt();
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No school history or competencies available.')),
      );
      return;
    }
    _sendMessage(prompt, isCompetencyTab: true);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Career Advisor'),
           // backgroundColor: Color(0xFF006600),
            bottom: TabBar(
              controller: _tabController,
              // indicatorColor: Colors.white,
              // labelColor: Colors.white,
              // unselectedLabelColor: Colors.white70,
              // labelStyle: TextStyle(fontWeight: FontWeight.bold),
              // unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                indicatorColor: Color(0xFF006600),
                labelColor: Color(0xFF006600),
                unselectedLabelColor: Color(0xFF006600).withOpacity(0.6),
                indicatorWeight: 3,
              tabs: [
                Tab(text: 'Chat'),
                Tab(text: 'Competency'),
              ],
            ),
          ),
          body: Container(
            //color: Color(0xFFFFFDE7),
            color:Color(0xFFF5F5F5),
            child: TabBarView(
            controller: _tabController,
            
            children: [
              // 1️⃣ Manual Chat Tab
              _buildChatTab(_messages, _scrollController, false),
              // 2️⃣ Competency Chat Tab
              _buildChatTab(_competencyMessages, _competencyScrollController, true),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildChatTab(
      List<Map<String, String>> messages, ScrollController controller, bool isCompetencyTab) {
    return Column(
      children: [
        if (_isBotTyping)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF006600),
                  child: Icon(Icons.support_agent_outlined, color: Colors.white, size: 16),
                  radius: 12,
                ),
                SizedBox(width: 8),
                Text(
                  'Agent is typing...',
                  style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: controller,
            padding: EdgeInsets.all(12),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return _buildMessage(message);
            },
          ),
        ),
        Divider(height: 1),
        if (!isCompetencyTab)
          Container(
            color: Colors.grey.shade100,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (text) => _sendMessage(text),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            color: Colors.teal.shade50,
            child: TextButton.icon(
              icon: Icon(Icons.school, color: Colors.teal),
              label: Text('Get Career & Course Advice', style: TextStyle(color: Colors.teal)),
              onPressed: _getCompetencyAdvice,
            ),
          ),
      ],
    );
  }
}
