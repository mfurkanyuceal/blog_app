part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await dotenv.load(fileName: ".env", mergeWith: Platform.environment);
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: dotenv.get("SUPABASE_URL"),
    anonKey: dotenv.get("SUPABASE_ANON_KEY"),
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(
    () => Hive.box(name: "blogs"),
  );

  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<UserSignUp>(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory<UserSignIn>(
      () => UserSignIn(
        serviceLocator(),
      ),
    )
    ..registerFactory<CurrentUser>(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // Auth Bloc
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<UploadBlog>(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory<DeleteBlog>(
      () => DeleteBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetAllBlogs>(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton<BlogBloc>(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        deleteBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
