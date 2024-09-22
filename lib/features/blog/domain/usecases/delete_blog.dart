import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlog implements UseCase<void, DeleteBlogParams> {
  final BlogRepository repository;

  DeleteBlog(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteBlogParams params) async {
    return await repository.deleteBlog(params.blogId);
  }
}

class DeleteBlogParams {
  final String blogId;

  DeleteBlogParams({required this.blogId});
}
