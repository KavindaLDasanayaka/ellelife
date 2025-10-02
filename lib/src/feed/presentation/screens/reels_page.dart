import 'package:ellelife/core/auth/data/user_auth_repo_impl.dart';
import 'package:ellelife/core/navigation/route_names.dart';
import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/src/feed/data/reels_repo_impl.dart';
import 'package:ellelife/src/feed/domain/entities/reel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = UserAuthService().getCurrentUser();
    final bool canAddReel = currentUser?.email == 'ellelifesl@gmail.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reels"),
        backgroundColor: mainColor,
        actions: [
          if (canAddReel)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                context.pushNamed(RouteNames.createReel);
              },
            ),
        ],
      ),
      body: StreamBuilder<List<Reel>>(
        stream: ReelsRepoImpl().getReelsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load reels"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No reels available"));
          }

          final reels = snapshot.data!;
          return ListView.builder(
            itemCount: reels.length,
            itemBuilder: (context, index) {
              final reel = reels[index];
              return ReelItem(reel: reel);
            },
          );
        },
      ),
    );
  }
}

class ReelItem extends StatelessWidget {
  final Reel reel;

  const ReelItem({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    // Extract YouTube video ID from URL
    final videoId = YoutubePlayer.convertUrlToId(reel.videoUrl) ?? '';

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reel.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              reel.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            // Display YouTube thumbnail
            if (videoId.isNotEmpty)
              GestureDetector(
                onTap: () {
                  // Navigate to single reel page
                  context.pushNamed(RouteNames.singleReel, extra: reel);
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://img.youtube.com/vi/$videoId/0.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              'Posted on: ${reel.createdAt.toDate().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
