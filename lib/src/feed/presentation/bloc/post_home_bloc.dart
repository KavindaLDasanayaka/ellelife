import 'package:ellelife/src/feed/data/post_repo_impl.dart';
import 'package:ellelife/src/feed/domain/entities/post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_home_event.dart';
part 'post_home_state.dart';

class PostHomeBloc extends Bloc<PostHomeEvent, PostHomeState> {
  PostHomeBloc() : super(PostHomeInitial()) {
    on<PostHomeEvent>((event, emit) {});
    on<PostRefresh>(_postRefresh);
  }

  Future<void> _postRefresh(PostRefresh event, Emitter emit) async {
    try {
      final List<Post> posts = await PostRepoImpl().getNewPosts();
      emit(PostsLoaded(posts: posts));
    } catch (err) {
      throw Exception("Error in loading posts");
    }
  }
}
