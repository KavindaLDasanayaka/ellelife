import 'package:ellelife/core/navigation/route_names.dart';
import 'package:ellelife/src/feed/data/post_repo_impl.dart';
import 'package:ellelife/src/feed/domain/entities/post.dart';
import 'package:ellelife/src/feed/presentation/widgets/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void clearDiskCache() async {
    await DefaultCacheManager().emptyCache(); // clears disk cache
  }

  void _onRefresh() {
    clearDiskCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 20),
        title: Image.asset(
          "assets/logo.png",
          width: MediaQuery.of(context).size.width * 0.4,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              context.pushNamed(RouteNames.createPost);
            },
            child: Row(children: [Icon(Icons.add), Text("Add Post")]),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: PostRepoImpl().getPostStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to fetch posts"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No post available"));
          }

          final List<Post> posts = snapshot.data!;

          posts.sort((a, b) => b.datePublished.compareTo(a.datePublished));

          return RefreshIndicator(
            onRefresh: () async => _onRefresh(),
            child: ListView.builder(
              itemCount: posts.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final Post post = posts[index];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () {
                      (context).pushNamed(RouteNames.singletPost, extra: post);
                    },
                    child: PostWidget(
                      post: post,
                      currentUserId: FirebaseAuth.instance.currentUser!.uid,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
