import 'package:auti_warrior_app/widgets/Chat%20Widgets/chat_bubble.dart';
import 'package:auti_warrior_app/widgets/Chat%20Widgets/reverse_chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:auti_warrior_app/models/ChatModels/message_model.dart';
import 'package:auti_warrior_app/services/message_service.dart';
import 'package:auti_warrior_app/services/storage_service.dart';

class ChatsView extends StatefulWidget {
  final String? email;

  ChatsView({super.key, this.email});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  final StorageService _storageService = StorageService();
  final ScrollController _scrollController = ScrollController();

  List<MessageModel> messages = [];
  String? userEmail;
  bool isLoading = true;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getUserEmail() async {
    try {
      // Use the StorageService to get the email
      final email = await _storageService.getEmail();

      setState(() {
        userEmail = email;
        isLoading = false;
      });

      print("Current user email from storage: $userEmail");
      print("Doctor email: ${widget.email}");

      if (userEmail != null && userEmail!.isNotEmpty && widget.email != null) {
        _fetchMessages();
      }
    } catch (e) {
      print("Error getting user email: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  bool _isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;

    // Simple email validation
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> _fetchMessages() async {
    if (!_isValidEmail(userEmail) || !_isValidEmail(widget.email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Invalid email addresses. Please check your login.')),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final fetchedMessages = await _messageService.fetchMessages(
        widget.email!,
        userEmail!,
      );

      setState(() {
        messages = fetchedMessages;
        isLoading = false;
      });

      // Scroll to bottom after messages are loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      print("Error fetching messages: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load messages: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    // Prevent multiple sends while one is in progress
    if (isSending) return;

    // Check if message is empty
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) {
      return;
    }

    // Ensure we have both required emails
    if (userEmail == null || userEmail!.isEmpty) {
      print("Cannot send: Missing sender email");
      // Try to get email again in case it wasn't loaded properly
      await _getUserEmail();

      if (userEmail == null || userEmail!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Cannot send message: Your email is not available. Please log in again.')),
        );
        return;
      }
    }

    if (widget.email == null || widget.email!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Cannot send message: Recceiver email is missing.')),
      );
      return;
    }

    // Validate email formats
    if (!_isValidEmail(userEmail) || !_isValidEmail(widget.email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Invalid email addresses. Please check your login.')),
      );
      return;
    }

    print("Sending message from: $userEmail to: ${widget.email}");
    print("Message content: $messageText");

    final newMessage = MessageModel(
      senderEmail: userEmail!,
      receiverEmail: widget.email!,
      content: messageText,
    );

    // Clear input field immediately for better UX
    _messageController.clear();

    // Add message to local list immediately
    setState(() {
      messages.add(newMessage);
      isSending = true;
    });

    // Scroll to show the new message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      // Send message to server
      await _messageService.sendMessage(newMessage);
      print("Message sent successfully");
    } catch (e) {
      print("Error sending message: $e");

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message. Please try again.'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () async {
              try {
                await _messageService.sendMessage(newMessage);
                print("Message sent successfully on retry");
              } catch (e) {
                print("Error sending message on retry: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to send message again: $e')),
                );
              }
            },
          ),
        ),
      );
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(widget.email != null ? 'Chat With' : 'Chat'),
        actions: [
          if (widget.email != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  widget.email!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Debug information - remove in production
                if (userEmail == null ||
                    userEmail!.isEmpty ||
                    widget.email == null)
                  Container(
                    color: Colors.red.shade100,
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Debug: Email missing! User: $userEmail, Receiver: ${widget.email}',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                Expanded(
                  child: messages.isEmpty
                      ? Center(child: Text('No messages yet'))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isSender = message.senderEmail == userEmail;

                            return isSender
                                ? ReverseChatBubble(message: message.content)
                                : ChatBubble(message: message.content);
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              _sendMessage();
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: _sendMessage,
                        icon: isSending
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.blueGrey,
                                ),
                              )
                            : Icon(Icons.send, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
