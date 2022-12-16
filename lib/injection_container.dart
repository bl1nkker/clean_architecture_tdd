import 'package:clean_architecture_tdd/core/network/network_info.dart';
import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future init() async {
  //! Features - number_trivia features (Repositories, UseCases, Datasources)
  // Bloc
  // Classes requiring cleanup (such as BLoCs) shouldn't be registered as singletons
  sl.registerFactory<NumberTriviaBloc>(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));

  // UseCases
  sl.registerLazySingleton<GetConcreteNumberTrivia>(
      (() => GetConcreteNumberTrivia(repository: sl())));
  sl.registerLazySingleton<GetRandomNumberTrivia>(
      (() => GetRandomNumberTrivia(repository: sl())));

  // Repositories
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDatasource: sl(), localDatasource: sl(), networkInfo: sl()));

  // Data Sources
  sl.registerLazySingleton<NumberTriviaRemoteDatasource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDatasource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core Stuff - InputConverter, NetworkInfo
  sl.registerLazySingleton<InputConverter>(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnectionChecker: sl()));
  //! External Http, etc.
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
}
