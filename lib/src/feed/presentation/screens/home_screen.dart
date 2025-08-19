import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/src/feed/data/post_repo_impl.dart';
import 'package:ellelife/src/feed/domain/entities/post.dart';
import 'package:ellelife/src/feed/presentation/bloc/post_home_bloc.dart';
import 'package:ellelife/src/feed/presentation/widgets/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _refreshPosts(BuildContext context) async {
    BlocProvider.of<PostHomeBloc>(context).add(PostRefresh());
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
      ),
      body: BlocBuilder<PostHomeBloc, PostHomeState>(
        builder: (context, state) {
          if (state is PostsLoaded) {
            final List<Post> posts = state.posts;
            posts.sort((a, b) => b.datePublished.compareTo(a.datePublished));
            return RefreshIndicator(
              onRefresh: () => _refreshPosts(context),
              child: ListView.builder(
                itemCount: posts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final Post post = posts[index];
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: PostWidget(
                      post: post,
                      currentUserId: FirebaseAuth.instance.currentUser!.uid,
                    ),
                  );
                },
              ),
            );
          } else if (state is PostHomeInitial) {
            return StreamBuilder(
              stream: PostRepoImpl().getPostStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Failed to fetch posts"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No post available"));
                }

                // final List<Post> posts = snapshot.data!;

                // posts.sort(
                //   (a, b) => b.datePublished.compareTo(a.datePublished),
                // );
                _refreshPosts(context);
                return SizedBox();
                // return RefreshIndicator(
                //   onRefresh: () => _refreshPosts(context),
                //   child: ListView.builder(
                //     itemCount: posts.length,
                //     shrinkWrap: true,
                //     itemBuilder: (context, index) {
                //       final Post post = posts[index];
                //       return Padding(
                //         padding: const EdgeInsets.all(20),
                //         child: PostWidget(
                //           post: post,
                //           currentUserId: FirebaseAuth.instance.currentUser!.uid,
                //         ),
                //       );
                //     },
                //   ),
                // );
              },
            );
          } else {
            return const Center(
              child: Text(
                "Please Refresh Page",
                style: TextStyle(
                  fontSize: 16,
                  color: mainWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
