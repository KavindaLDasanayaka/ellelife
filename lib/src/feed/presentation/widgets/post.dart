import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/core/utils/constants.dart';
import 'package:ellelife/core/utils/mood.dart';
import 'package:ellelife/src/feed/data/post_repo_impl.dart';
import 'package:ellelife/src/feed/data/post_storage.dart';
import 'package:ellelife/src/feed/domain/entities/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final String currentUserId;

  const PostWidget({
    super.key,
    required this.post,
    required this.currentUserId,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isLiked = false;

  //check if the user has liked the post
  Future<void> _checkIfUserLiked() async {
    final bool hasLiked = await PostRepoImpl().hasUserLikedPost(
      postId: widget.post.postId,
      userId: widget.currentUserId,
    );
    setState(() {
      _isLiked = hasLiked;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkIfUserLiked();
  }

  //method to like and dislike a post
  void _likedOrDisLikePost() async {
    try {
      if (_isLiked) {
        await PostRepoImpl().disLikePost(
          postId: widget.post.postId,
          userId: widget.currentUserId,
        );
        setState(() {
          _isLiked = false;
        });
      } else {
        await PostRepoImpl().likePost(
          postId: widget.post.postId,
          userId: widget.currentUserId,
        );
        setState(() {
          _isLiked = true;
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  //post deleting method
  Future<void> deletePost(
    String imageUrl,
    String postId,
    BuildContext context,
  ) async {
    try {
      final String publicId = PostStorage().extractPublicIdFromUrl(imageUrl);

      Navigator.of(context).pop();
      await PostRepoImpl().deletePost(postId: postId, publicId: publicId);
    } catch (err) {
      print("error post deleting ui :$err");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Post deleting error"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(widget.post.datePublished);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  widget.post.profImage.isEmpty
                      ? profileImage
                      : widget.post.profImage,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: mainWhite,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: mainWhite.withOpacity(0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              // ignore: deprecated_member_use
              color: mainColor.withOpacity(0.5),
            ),
            child: Text(
              "Feeling ${widget.post.mood.name} ${widget.post.mood.emoji}",
              style: TextStyle(color: mainWhite),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.post.postCaption,
            // ignore: deprecated_member_use
            style: TextStyle(color: mainWhite.withOpacity(0.9), fontSize: 16),
          ),
          const SizedBox(height: 10),
          if (widget.post.postImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.post.postImage,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _likedOrDisLikePost,
                    icon: _isLiked
                        ? Icon(Icons.favorite, color: mainColor)
                        : Icon(Icons.favorite_border_outlined),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${widget.post.likes.toString()} likes",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              if (widget.post.userId == widget.currentUserId)
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shrinkWrap: true,
                            children: [
                              // _buildDialogOption(
                              //   context: context,
                              //   icon: Icons.edit,
                              //   text: "Edit",
                              //   onTap: () {},
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Divider(
                              //     // ignore: deprecated_member_use
                              //     color: mainWhite.withOpacity(0.5),
                              //   ),
                              // ),
                              _buildDialogOption(
                                context: context,
                                icon: Icons.delete,
                                text: "Delete",
                                onTap: () {
                                  deletePost(
                                    widget.post.postImage,
                                    widget.post.postId,
                                    context,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.more_vert),
                ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildDialogOption({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: mainWhite),
            const SizedBox(width: 12),
            Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: mainWhite),
            ),
          ],
        ),
      ),
    );
  }
}
