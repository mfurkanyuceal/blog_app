part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final File image;
  final String title;
  final String content;
  final List<String> topics;
  final String posterId;

  BlogUpload({
    required this.image,
    required this.title,
    required this.content,
    required this.topics,
    required this.posterId,
  });
}

final class BlogDelete extends BlogEvent {
  final String blogId;

  BlogDelete({required this.blogId});
}

final class BlogGetAll extends BlogEvent {}
