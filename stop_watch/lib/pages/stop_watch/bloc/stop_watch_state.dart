part of 'stop_watch_bloc.dart';

class StepWatch {
  final Duration totalDuration;
  final Duration endDuration;

  const StepWatch({
    required this.totalDuration,
    required this.endDuration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StepWatch &&
          runtimeType == other.runtimeType &&
          totalDuration == other.totalDuration &&
          endDuration == other.endDuration);

  @override
  int get hashCode => totalDuration.hashCode ^ endDuration.hashCode;

  @override
  String toString() {
    return 'StepWatch{' +
        ' totalDuration: $totalDuration,' +
        ' startDuration: $endDuration,' +
        '}';
  }

  StepWatch copyWith({
    Duration? totalDuration,
    Duration? startDuration,
  }) {
    return StepWatch(
      totalDuration: totalDuration ?? this.totalDuration,
      endDuration: startDuration ?? this.endDuration,
    );
  }
}

class StopWatchData {
  final DateTime startTime;
  final DateTime currentTime;
  final List<StepWatch> steps;
  final Duration duration;

  const StopWatchData({
    required this.startTime,
    required this.currentTime,
    required this.duration,
    required this.steps,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StopWatchData &&
          runtimeType == other.runtimeType &&
          startTime == other.startTime &&
          steps == other.steps &&
          currentTime == other.currentTime &&
          duration == other.duration);

  @override
  int get hashCode =>
      startTime.hashCode ^ currentTime.hashCode ^ duration.hashCode;

  @override
  String toString() {
    return 'StopWatchData{startTime: $startTime, currentTime: $currentTime, duration: $duration, steps: ${steps.length}}';
  }

  StopWatchData copyWith({
    DateTime? startTime,
    DateTime? currentTime,
    Duration? duration,
    List<StepWatch>? steps,
  }) {
    return StopWatchData(
      startTime: startTime ?? this.startTime,
      steps: steps ?? this.steps,
      currentTime: currentTime ?? this.currentTime,
      duration: duration ?? this.duration,
    );
  }
}

@immutable
abstract class StopWatchState {
  final StopWatchData? data;

  const StopWatchState([this.data]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StopWatchState &&
          runtimeType == other.runtimeType &&
          data == other.data);

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() {
    return 'StopWatchState { data: $data }';
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
    };
  }
}

class StopWatchInitial extends StopWatchState {}

class StopWatchStart extends StopWatchState {
  const StopWatchStart(StopWatchData data) : super(data);

  @override
  String toString() {
    return 'StopWatchStart { data: $data }';
  }
}

class StopWatchStop extends StopWatchState {
  const StopWatchStop(StopWatchData data) : super(data);

  @override
  String toString() {
    return 'StopWatchStop { data: $data }';
  }
}

class StopWatchPause extends StopWatchState {
  const StopWatchPause(StopWatchData data) : super(data);

  @override
  String toString() {
    return 'StopWatchPause { data: $data }';
  }
}

class StopWatchProgress extends StopWatchState {
  const StopWatchProgress(StopWatchData data) : super(data);

  @override
  String toString() {
    return 'StopWatchProgress { data: $data }';
  }
}
