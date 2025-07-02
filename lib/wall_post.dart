import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WallPost extends StatelessWidget {
  final String message;
  final String email;
  final Timestamp timestamp;
  final String? postId;

  WallPost({
    super.key,
    required this.message,
    required this.email,
    required this.timestamp,
    this.postId,
  });

  final currentUser = FirebaseAuth.instance.currentUser;

  String get username {
    if (email.contains('@')) {
      return email.split('@')[0];
    }
    return email;
  }

  String getFormattedTime() {
    final dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy – hh:mm a').format(dateTime);
  }

  void deletePost(BuildContext context) async {
    if (postId != null) {
      await FirebaseFirestore.instance.collection('User Posts').doc(postId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post deleted")),
      );
    }
  }

  void editPost(BuildContext context) {
    final TextEditingController editController = TextEditingController(text: message);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Post"),
        content: TextField(
          controller: editController,
          maxLines: null,
          decoration: const InputDecoration(hintText: "Update your message"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (postId != null) {
                await FirebaseFirestore.instance
                    .collection('User Posts')
                    .doc(postId)
                    .update({'Message': editController.text});
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void copyPost(BuildContext context) {
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post copied")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = currentUser != null && currentUser!.email == email;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        //color here
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row: Profile Pic, Username and Menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[600],
                child: Text(
                  username[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      email,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (isOwner)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Edit') {
                      editPost(context);
                    } else if (value == 'Delete') {
                      deletePost(context);
                    } else if (value == 'Copy') {
                      copyPost(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'Delete', child: Text('Delete')),
                    const PopupMenuItem(value: 'Copy', child: Text('Copy')),
                  ],
                  color: Colors.white,
                  icon: const Icon(Icons.more_vert, size: 20),
                  
                ),
            ],
          ),
          const SizedBox(height: 12),

          /// Message
          Text(
            message,
            style: const TextStyle(fontSize: 15),
          ),

          const SizedBox(height: 8),

          /// Timestamp
          Text(
            getFormattedTime(),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
