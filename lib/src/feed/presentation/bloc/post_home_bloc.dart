import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'post_home_event.dart';
part 'post_home_state.dart';

class PostHomeBloc extends Bloc<PostHomeEvent, PostHomeState> {
  PostHomeBloc() : super(PostHomeInitial()) {
    on<PostHomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
