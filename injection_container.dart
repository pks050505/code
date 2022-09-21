import 'package:digital_marketing/api/community_repository.dart';
import 'package:digital_marketing/bloc/auth/login_cubit.dart';
import 'package:digital_marketing/bloc/cource/cource_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/auth_repository.dart';

final sl = GetIt.instance;
//This is dependency injection  page which is use for populate the data between entire screen.
//Term
//BlocProvider
//BlocMultiProvider
//BlocBuilder
//BlocConsumer
//and some more
Future<void> init() async {
  //bloc

  // sl.registerFactory<AuthenticationBloc>(
  //     () => AuthenticationBloc(authRepository: sl()));

  // sl.registerFactory<InstructorBloc>(() => InstructorBloc(sl()));
  sl.registerFactory<CourceBloc>(() => CourceBloc(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
  sl.registerLazySingleton<CommunityRepository>(
      () => CommunityRepository(database: sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
  //repository
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
  // sl.registerLazySingleton<UserRepository>(() => UserRepository());
  // sl.registerLazySingleton<CourceService>(() => CourceServiceImpl());

  // External
  final realtimeDatabase = FirebaseDatabase.instance;
  sl.registerLazySingleton<FirebaseDatabase>(() => realtimeDatabase);
  final preference = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => preference);
}
