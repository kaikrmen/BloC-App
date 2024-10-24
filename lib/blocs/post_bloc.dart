import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  int currentPage = 0;
  static const int postsPerPage = 10;

  PostBloc(this.postRepository) : super(PostInitial()) {
    on<FetchPosts>((event, emit) async {
      try {
        if (state is PostLoading) return;

        final posts = await postRepository.fetchPosts(
            currentPage * postsPerPage, postsPerPage);

        if (posts.isEmpty) {
          emit(PostSuccess(
              posts: (state is PostSuccess) ? (state as PostSuccess).posts : [],
              hasReachedMax: true));
        } else {
          currentPage++;
          emit(PostSuccess(
            posts: (state is PostSuccess)
                ? (state as PostSuccess).posts + posts
                : posts,
            hasReachedMax: false,
          ));
        }
      } catch (error) {
        emit(PostFailure());
      }
    });
  }
}
