import 'package:equatable/equatable.dart';
import '../models/post_model.dart';

abstract class PostState extends Equatable {
  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostSuccess extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  PostSuccess({required this.posts, required this.hasReachedMax});

  @override
  List<Object> get props => [posts, hasReachedMax];
}

class PostFailure extends PostState {}
