import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource remoteDataSource;
  final BlogLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  const BlogRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required List<String> topics,
    required String posterId,
  }) async {
    try {
      if (await connectionChecker.isDisconnected) {
        return left(Failure("No internet connection"));
      }

      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        title: title,
        content: content,
        topics: topics,
        posterId: posterId,
        imageUrl: "",
        updatedAt: DateTime.now(),
      );
      final imageUrl = await remoteDataSource.uploadBlogImage(image: image, blog: blogModel);

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadedBlog = await remoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (await connectionChecker.isDisconnected) {
        final blogs = localDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await remoteDataSource.getAllBlogs();
      localDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> deleteBlog(String blogId) async {
    try {
      await remoteDataSource.deleteBlog(blogId);
      return right([]);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
