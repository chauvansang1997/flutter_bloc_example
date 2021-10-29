part of 'stop_watch_bloc.dart';

@immutable
abstract class StopWatchEvent {}

class StopWatchStarted extends StopWatchEvent {}

class StopWatchStopped extends StopWatchEvent {}

class StopWatchPaused extends StopWatchEvent {}

class StopWatchResumed extends StopWatchEvent {}

class StopWatchProgressed extends StopWatchEvent {}

class StopWatchSplit extends StopWatchEvent {}
