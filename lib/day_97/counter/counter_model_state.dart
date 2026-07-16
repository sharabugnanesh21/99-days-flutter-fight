class CounterModelState {
  final int counter;
  CounterModelState({this.counter = 0});

  CounterModelState copyWith({int? counter}) {
    return CounterModelState(counter: counter ?? this.counter);
  }
}
