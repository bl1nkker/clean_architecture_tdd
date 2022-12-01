import 'package:equatable/equatable.dart';

// Step 2
abstract class Failure extends Equatable {
  const Failure();
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
