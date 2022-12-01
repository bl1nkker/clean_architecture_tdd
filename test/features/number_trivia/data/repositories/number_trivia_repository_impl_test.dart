import 'package:clean_architecture_tdd/core/platform/network_info.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([NumberTriviaRemoteDatasource])
@GenerateMocks([NumberTriviaLocalDatasource])
@GenerateMocks([NetworkInfo])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late NumberTriviaRemoteDatasource mockNumberTriviaRemoteDatasource;
  late NumberTriviaLocalDatasource mockNumberTriviaLocalDatasource;
  late NetworkInfo mockNetworkInfo;
  setUp((() {
    mockNumberTriviaRemoteDatasource = MockNumberTriviaRemoteDatasource();
    mockNumberTriviaLocalDatasource = MockNumberTriviaLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDatasource: mockNumberTriviaRemoteDatasource,
        localDatasource: mockNumberTriviaLocalDatasource,
        networkInfo: mockNetworkInfo);
  }));

  test('', () {
    // arrange
    // act
    // assert
  });
}
