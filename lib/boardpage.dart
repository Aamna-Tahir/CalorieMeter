import 'package:calorieMeter/wall_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'text_field.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final AuthService auth = AuthService();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController textController = TextEditingController();

  void postMessage() {
    if (textController.text.isNotEmpty && currentUser != null) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser!.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
      });

      setState(() {
        textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //color here
      backgroundColor: Colors.white,
      body: currentUser == null
          ? const Center(child: Text("User not logged in"))
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("User Posts")
                        .orderBy("TimeStamp", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index];
                            return WallPost(
                              message: post['Message'],
                              email: post['UserEmail'],
                              timestamp: post['TimeStamp'],
                              postId: post.id, // pass post ID
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: textController,
                          hintText: "Share your achievement... 🎯",
                          obscureText: false,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: postMessage,
                        icon: const Icon(Icons.send),
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 16),
                //   child: Text(
                //     "Logged in as: ${currentUser?.email ?? "Guest"}",
                //     style: const TextStyle(color: Colors.grey),
                //   ),
                // ),
              ],
            ),
    );
  }
}
