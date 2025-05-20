import 'dart:async'; // لاستخدام Timer للـ debounce
import 'package:auti_warrior_app/models/ChatModels/message_model.dart';
import 'package:auti_warrior_app/services/message_service.dart';
import 'package:auti_warrior_app/services/storage_service.dart'; // For getting logged-in user's email
import 'package:auti_warrior_app/widgets/Chat%20Widgets/chat_bubble.dart';
import 'package:auti_warrior_app/widgets/Chat%20Widgets/reverse_chat_bubble.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatefulWidget {
  final String?
      email; // This is the email of the OTHER person (e.g., Mother or Doctor)

  ChatsView(
      {super.key,
      required this.email}); // Made email required for a chat screen

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  final StorageService _storageService = StorageService();
  final ScrollController _scrollController = ScrollController();

  List<MessageModel> _messages = [];
  String? _loggedInUserEmail; // Email of the currently logged-in user
  bool _isLoading = true;
  bool _isSending = false;
  String? _errorLoadingMessages;
  Timer? _debounceSendMessage; // Timer للـ debounce الخاص بدالة _sendMessage

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _debounceSendMessage?.cancel(); // إلغاء الـ Timer عند التخلص من الـ widget
    super.dispose();
  }

  Future<void> _initializeChat() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorLoadingMessages = null;
    });
    try {
      final emailFromStorage = await _storageService.getEmail();
      if (!mounted) return;

      setState(() {
        _loggedInUserEmail = emailFromStorage;
      });

      print(
          "Current logged-in user (e.g., Doctor/Mother): $_loggedInUserEmail");
      print("Chatting with (other participant): ${widget.email}");

      if (!_isValidEmail(_loggedInUserEmail) || !_isValidEmail(widget.email)) {
        final errorMessage =
            "Cannot initiate chat: Your email ('$_loggedInUserEmail') or recipient's email ('${widget.email}') is invalid or missing.";
        print(errorMessage);
        if (mounted) {
          setState(() {
            _errorLoadingMessages = errorMessage;
            _isLoading = false;
          });
        }
        return;
      }
      await _fetchMessages();
    } catch (e) {
      print("Error initializing chat (getting user email): $e");
      if (mounted) {
        setState(() {
          _errorLoadingMessages = "Error initializing chat: $e";
          _isLoading = false;
        });
      }
    }
  }

  bool _isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> _fetchMessages() async {
    if (!_isValidEmail(_loggedInUserEmail) || !_isValidEmail(widget.email)) {
      print(
          "Fetch Aborted: Invalid emails. LoggedIn: $_loggedInUserEmail, Other: ${widget.email}");
      if (mounted) {
        setState(() {
          _errorLoadingMessages =
              "Cannot fetch messages: Invalid email configuration.";
          _isLoading = false;
        });
      }
      return;
    }

    // إذا لم يكن تحميلًا أوليًا، لا نظهر مؤشر التحميل الكامل
    // (هذا مفيد إذا أضفت pull-to-refresh لاحقًا)
    // if (mounted && _messages.isEmpty) { // فقط إذا كانت القائمة فارغة
    //   setState(() { _isLoading = true; });
    // }

    try {
      final fetchedMessages = await _messageService.fetchMessages(
        _loggedInUserEmail!,
        widget.email!,
      );

      if (!mounted) return;
      setState(() {
        _messages = fetchedMessages;
      });

      _scrollToBottom();
    } catch (e) {
      print("Error in ChatsView _fetchMessages: $e");
      if (mounted) {
        setState(() {
          _errorLoadingMessages = "Failed to load messages: $e";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // دائمًا أوقف التحميل (سواء الأولي أو التحديث)
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && _messages.isNotEmpty) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    // --- بداية Debounce ---
    if (_debounceSendMessage?.isActive ?? false) _debounceSendMessage!.cancel();
    _debounceSendMessage = Timer(const Duration(milliseconds: 100), () async {
      // زيادة طفيفة للتأخير
      // --- نهاية Debounce ---

      if (!mounted) return; // تحقق مبكر من mounted داخل الـ Timer

      if (_isSending) {
        print(
            "SendMessage blocked by _isSending flag: Already sending a message.");
        return;
      }

      final messageText = _messageController.text.trim();
      if (messageText.isEmpty) {
        return;
      }

      if (!_isValidEmail(_loggedInUserEmail) || !_isValidEmail(widget.email)) {
        print(
            "Cannot send: Invalid emails. LoggedIn: $_loggedInUserEmail, Other: ${widget.email}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Cannot send message: Email configuration error.')),
          );
        }
        return;
      }

      if (mounted) {
        setState(() {
          _isSending = true;
        });
      } else {
        return; // إذا لم يكن mounted، لا تكمل
      }

      final clientSideMessage = MessageModel(
        senderEmail: _loggedInUserEmail!,
        receiverEmail: widget.email!,
        content: messageText,
        timestamp: DateTime.now(),
      );

      _messageController.clear();

      if (mounted) {
        setState(() {
          _messages.add(clientSideMessage);
        });
        _scrollToBottom(); // استدعِ التمرير بعد إضافة الرسالة محليًا
      } else {
        // إذا لم يكن mounted، تراجع عن _isSending
        if (mounted) {
          // هذا التحقق يبدو زائدًا هنا، لكن للتأكيد
          setState(() {
            _isSending = false;
          });
        }
        return;
      }

      try {
        await _messageService.sendMessage(clientSideMessage);
        print("Message sent successfully to server.");
      } catch (e) {
        print("Error sending message to server: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send message. Error: $e'),
            ),
          );
          setState(() {
            _messages.remove(clientSideMessage);
            // _messageController.text = messageText; // لإعادة النص للمستخدم إذا فشل الإرسال
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSending = false;
          });
        }
      }
    }); // نهاية دالة الـ Timer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title:
            Text(widget.email != null ? 'Chat With: ${widget.email}' : 'Chat'),
        // actions: [ // يمكنك إزالة هذا الجزء إذا كان اسم الشخص الآخر في العنوان كافيًا
        //   if (widget.email != null)
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Center(
        //         child: Text(
        //           widget.email!,
        //           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        //         ),
        //       ),
        //     ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorLoadingMessages != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red, size: 48),
                              const SizedBox(height: 16),
                              Text('Error: $_errorLoadingMessages',
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _initializeChat,
                                child: const Text('Try Again'),
                              )
                            ],
                          ),
                        ),
                      )
                    : _messages.isEmpty
                        ? const Center(
                            child: Text(
                                'No messages yet. Start the conversation!'))
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: _messages.length,
                            padding: const EdgeInsets.all(8.0),
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              final bool isSender =
                                  message.senderEmail == _loggedInUserEmail;

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
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isSending ? null : _sendMessage,
                  icon: _isSending
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.blueGrey.shade700),
                        )
                      : Icon(Icons.send,
                          color: Colors.blueGrey.shade700, size: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
