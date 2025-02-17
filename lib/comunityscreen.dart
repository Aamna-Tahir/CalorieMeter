import 'package:flutter/material.dart';

class CommunityFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return Scaffold(
    body: NestedScrollView(
    physics: const BouncingScrollPhysics(),
    headerSliverBuilder: (context, innerBoxIsScrolled) {
    return [];
    },

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 5), // Add spacing for better alignment
            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.black54),
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Community Posts
            Expanded(
              child: ListView(
                children: [
                  buildPostCard(
                    username: 'Ritha',
                    handle: '@user109',
                    content:
                    '🎉 No Junk Food Success!\nJust completed the No Junk Food Challenge and feeling amazing! 💪🍎 Thanks for the motivation, everyone! On to the next goal! 🚀\n#HealthyHabits #FeelingGreat',
                  ),
                  buildPostCard(
                    username: 'Kevin',
                    handle: '@user759',
                    content:
                    '🎉 Water Intake Challenge Complete!\nFinished the Drink 2L Water Daily Challenge, and I feel so refreshed and energized! 💧💪 Excited for the next goal! 🚀\n#StayHydrated #HealthyHabits',
                  ),
                  buildPostCard(
                    username: 'Kevin',
                    handle: '@user759',
                    content:
                    '🎉 Water Intake Challenge Complete!\nFinished the Drink 2L Water Daily Challenge, and I feel so refreshed and energized! 💧💪 Excited for the next goal! 🚀\n#StayHydrated #HealthyHabits',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),

        );
  }

  Widget buildPostCard({
    required String username,
    required String handle,
    required String content,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[400],
                radius: 24,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    handle,
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
