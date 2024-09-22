import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final DeleteBlog _deleteBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required DeleteBlog deleteBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _deleteBlog = deleteBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogUpload>(_onBlogUpload);
    on<BlogDelete>(_onBlogDelete);
    on<BlogGetAll>(_onBlogGetAll);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final result = await _uploadBlog(UploadBlogParams(
      image: event.image,
      title: event.title,
      content: event.content,
      topics: event.topics,
      posterId: event.posterId,
    ));

    result.fold(
      (l) => emit(BlogFailure(message: l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onBlogDelete(BlogDelete event, Emitter<BlogState> emit) async {
    final result = await _deleteBlog(DeleteBlogParams(blogId: event.blogId));

    result.fold(
      (l) => emit(BlogFailure(message: l.message)),
      (r) => emit(BlogDeleteSuccess()),
    );
  }

  void _onBlogGetAll(BlogGetAll event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final result = await _getAllBlogs(NoParams());

    result.fold(
      (l) => emit(BlogFailure(message: l.message)),
      (r) => emit(BlogGetAllSuccess(r)),
    );
  }
}
