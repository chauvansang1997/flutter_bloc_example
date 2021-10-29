import 'package:stop_watch/pages/stop_watch/bloc/stop_watch_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StopWatchPage extends StatefulWidget {
  const StopWatchPage({Key? key}) : super(key: key);

  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StopWatchBloc>(
      create: (BuildContext context) => StopWatchBloc(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('StopWatch'),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<StopWatchBloc, StopWatchState>(
      listener: (context, state) {
        // if (state is StopWatchStart) {
        //   showToast('StopWatch is started');
        //   return;
        // }
        //
        // if (state is StopWatchPause) {
        //   showToast('StopWatch is paused');
        //   return;
        // }
        //
        // if (state is StopWatchStop) {
        //   showToast('StopWatch is stopped');
        //   return;
        // }
      },
      builder: (context, state) {
        return SafeArea(
          child: SizedBox(
            height: double.infinity,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: _buildTime(
                        state.data?.duration ?? const Duration(milliseconds: 0),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _buildSplitList(),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: _buildButton(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSplitList() {
    return Builder(builder: (context) {
      final bloc = context.read<StopWatchBloc>();

      final data = bloc.state.data;

      if (data != null) {
        return ListView.separated(
          itemCount: data.steps.length,
          itemBuilder: (BuildContext context, int index) {
            return _StepWatchItem(
              stepWatch: data.steps[index],
              index: index + 1,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 5);
          },
        );
      }

      return const SizedBox();
    });
  }

  Widget _buildButton() {
    return Builder(builder: (context) {
      final bloc = context.read<StopWatchBloc>();

      switch (bloc.state.runtimeType) {
        case StopWatchInitial:
        case StopWatchStop:
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CircleButton(
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () => bloc.add(StopWatchStarted()),
              ),
            ],
          );
        case StopWatchStart:
        case StopWatchProgress:
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CircleButton(
                child: const Icon(
                  Icons.splitscreen,
                  color: Colors.white,
                ),
                onPressed: () => bloc.add(StopWatchSplit()),
              ),
              const SizedBox(width: 30),
              _CircleButton(
                child: const Icon(
                  Icons.pause,
                  color: Colors.white,
                ),
                onPressed: () => bloc.add(StopWatchPaused()),
              ),
            ],
          );

        case StopWatchPause:
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CircleButton(
                child: const Icon(
                  Icons.stop,
                  color: Colors.white,
                ),
                onPressed: () => bloc.add(StopWatchStopped()),
              ),
              const SizedBox(width: 30),
              _CircleButton(
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () => bloc.add(StopWatchResumed()),
              ),
            ],
          );
      }

      return const SizedBox();
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 24.0,
    );
  }

  Widget _buildTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    String treeDigits(int n) => n.toString().padLeft(3, '0');
    String twoDigitMilliseconds =
        treeDigits(duration.inMilliseconds.remainder(1000));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TimeDigits(
          text: twoDigitHours,
        ),
        const Text(':',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
        _TimeDigits(
          text: twoDigitMinutes,
        ),
        const Text(':',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
        _TimeDigits(
          text: twoDigitSeconds,
        ),
        const Text(':',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
        _TimeDigits(
          text: twoDigitMilliseconds,
        ),
      ],
    );
  }
}

class _TimeDigits extends StatefulWidget {
  const _TimeDigits({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  State<_TimeDigits> createState() => _TimeDigitsState();
}

class _TimeDigitsState extends State<_TimeDigits> {
  double _firstSize = -1;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 30,
    );
    final Size size = (TextPainter(
      text: TextSpan(text: widget.text, style: style),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout())
        .size;
    if (_firstSize == -1) {
      _firstSize = size.width;
    }

    return SizedBox(
      width: _firstSize + 10,
      child: Center(
        child: Text(widget.text, textAlign: TextAlign.center, style: style),
      ),
    );
  }
}

String displayTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  String treeDigits(int n) => n.toString().padLeft(3, '0');
  String twoDigitMilliseconds =
      treeDigits(duration.inMilliseconds.remainder(1000));
  return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds:$twoDigitMilliseconds';
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({Key? key, required this.child, this.onPressed})
      : super(key: key);

  final Widget child;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 40,
        height: 40,
        child: Material(
          color: Colors.blue,
          child: IconButton(
            onPressed: onPressed,
            icon: child,
          ),
        ),
      ),
    );
  }
}

class _StepWatchItem extends StatelessWidget {
  const _StepWatchItem({Key? key, required this.stepWatch, required this.index})
      : super(key: key);

  final StepWatch stepWatch;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$index',
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              '+${displayTime(stepWatch.totalDuration)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              displayTime(stepWatch.endDuration),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
