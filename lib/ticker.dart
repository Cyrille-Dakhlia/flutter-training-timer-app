class Ticker {
  const Ticker();

  Stream<int> tickWithYield(int max) async* {
    for (var i = 0; i <= max; i++) {
      yield max - i;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Stream<int> tickWithStreamPeriodic({required int ticks}) {
    return Stream.periodic(
      const Duration(seconds: 1),
      (computationCount) => ticks - computationCount - 1,
    ).take(ticks);
  }
}
