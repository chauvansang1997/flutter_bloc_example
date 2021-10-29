import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'stop_watch_event.dart';

part 'stop_watch_state.dart';

class StopWatchBloc extends Bloc<StopWatchEvent, StopWatchState> {
  StopWatchBloc() : super(StopWatchInitial()) {
    on<StopWatchStarted>(_onStarted);

    on<StopWatchPaused>(_onPaused);

    on<StopWatchStopped>(_onStopped);

    on<StopWatchProgressed>(_onProgressed);

    on<StopWatchResumed>(_onResumed);

    on<StopWatchSplit>(_onSplit);
  }

  Timer? _timer;

  Future<void> _onStarted(
      StopWatchStarted event, Emitter<StopWatchState> emit) async {
    ///cancel if we call start more time
    _timer?.cancel();
    final DateTime now = DateTime.now();
    emit(
      StopWatchStart(StopWatchData(
        currentTime: now,
        startTime: now,
        duration: const Duration(milliseconds: 0),
        steps: [],
      )),
    );

    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      add(StopWatchProgressed());
    });
  }

  Future<void> _onPaused(
      StopWatchPaused event, Emitter<StopWatchState> emit) async {
    _timer?.cancel();
    if (state.data != null) {
      emit(
        StopWatchPause(state.data!),
      );
    }
  }

  Future<void> _onStopped(
      StopWatchStopped event, Emitter<StopWatchState> emit) async {
    _timer?.cancel();
    if (state.data != null) {
      emit(
        StopWatchStop(state.data!),
      );
    }
  }

  Future<void> _onProgressed(
      StopWatchProgressed event, Emitter<StopWatchState> emit) async {
    final data = state.data;
    if (data != null) {
      final DateTime now = DateTime.now();
      final differenceDuration = now.difference(data.currentTime);

      final newDuration = Duration(
        microseconds:
            data.duration.inMicroseconds + differenceDuration.inMicroseconds,
      );

      emit(
        StopWatchProgress(
          data.copyWith(
            currentTime: now,
            duration: newDuration,
          ),
        ),
      );
    }
  }

  Future<void> _onResumed(
      StopWatchResumed event, Emitter<StopWatchState> emit) async {
    ///cancel if we call start more time
    _timer?.cancel();
    final data = state.data;
    if (data != null) {
      final DateTime now = DateTime.now();
      emit(
        StopWatchProgress(data.copyWith(
          currentTime: now,
        )),
      );

      _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
        add(StopWatchProgressed());
      });
    }
  }

  Future<void> _onSplit(
      StopWatchSplit event, Emitter<StopWatchState> emit) async {
    final data = state.data;
    if (data != null) {
      late StepWatch stepWatch;

      final steps = List<StepWatch>.from(data.steps);

      final currentDuration =
          Duration(milliseconds: data.duration.inMilliseconds);

      if (steps.isNotEmpty) {
        stepWatch = StepWatch(
          endDuration: currentDuration,
          totalDuration: Duration(
            milliseconds: currentDuration.inMilliseconds -
                steps.last.endDuration.inMilliseconds,
          ),
        );
      } else {
        stepWatch =
            StepWatch(endDuration: data.duration, totalDuration: data.duration);
      }

      steps.add(stepWatch);


      emit(
        StopWatchProgress(
          data.copyWith(
            steps: steps,
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
