import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class AudioWidget extends StatefulWidget {
  final String audioUrl;
  const AudioWidget({super.key, required this.audioUrl});

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  void _initAudioPlayer() async {
    try {
      // Load the audio from URL
      await _audioPlayer.setUrl(widget.audioUrl);

      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      });

      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position;
        });
      });

      _audioPlayer.playerStateStream.listen((playerState) {
        setState(() {
          _isPlaying = playerState.playing;
        });
      });

       // Listen for playback completion
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
          });
          _safeDisableWakeLock();
        }
      });
      
    } catch (e) {
      print('Error initializing audio player: $e');
      _showErrorSnackBar('Error initializing audio');
    }
  }

  void _playPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        await _safeDisableWakeLock();
      } else {
        await _audioPlayer.play();
        await _safeEnableWakeLock();
      }
    } catch (e) {
      print('Error in play/pause: $e');
      _showErrorSnackBar('Audio playback error');
    }
  }

  Future<void> _safeEnableWakeLock() async {
    try {
      await WakelockPlus.enable();
    } catch (e) {
      print('Error enabling wake lock: $e');
    }
  }

  Future<void> _safeDisableWakeLock() async {
    try {
      await WakelockPlus.disable();
    } catch (e) {
      print('Error disabling wake lock: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _safeDisableWakeLock();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: PColors.red,
          ),
          onPressed: _playPause,
        ),
        Slider(
          value: _position.inSeconds.toDouble(),
          max: _duration.inSeconds.toDouble(),
          onChanged: (value) {
            final position = Duration(seconds: value.toInt());
            _audioPlayer.seek(position);
          },
        ),
        // Text(
        //   '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
        //   style: TextStyle(color: PColors.black),
        // ),
      ],
    );
  }

  // String _formatDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   final minutes = twoDigits(duration.inMinutes.remainder(60));
  //   final seconds = twoDigits(duration.inSeconds.remainder(60));
  //   return '$minutes:$seconds';
  // }
}
