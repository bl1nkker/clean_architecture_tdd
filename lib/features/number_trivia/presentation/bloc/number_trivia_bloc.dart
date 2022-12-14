import 'package:bloc/bloc.dart';
import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage = 'Invalid input';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(
        (event, emit) => _onGetTriviaForConcreteNumberEvent(event, emit));
  }

  _onGetTriviaForConcreteNumberEvent(
      GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    inputEither.fold(
      (failure) => emit(const Error(message: invalidInputFailureMessage)),
      (value) => emit(Empty()),
    );
  }
}
