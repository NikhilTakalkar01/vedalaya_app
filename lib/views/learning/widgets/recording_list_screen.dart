// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:vedalaya_app/views/learning/controller/recording_storage.dart';
// // import 'recording_storage.dart';

// class RecordingsListScreen extends StatefulWidget {
//   const RecordingsListScreen({super.key});

//   @override
//   State<RecordingsListScreen> createState() => _RecordingsListScreenState();
// }

// class _RecordingsListScreenState extends State<RecordingsListScreen> {
//   List<String> recordings = [];
//   final player = AudioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     loadRecordings();
//   }

//   Future<void> loadRecordings() async {
//     final data = await RecordingStorage.getRecordings();
//     setState(() => recordings = data);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Saved Recordings')),
//       body: ListView.builder(
//         itemCount: recordings.length,
//         itemBuilder: (_, index) {
//           return ListTile(
//             title: Text('Recording ${index + 1}'),
//             subtitle: Text(recordings[index]),
//             trailing: IconButton(
//               icon: Icon(Icons.play_arrow),
//               onPressed: () {
//                 player.play(DeviceFileSource(recordings[index]));
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vedalaya_app/utils/recording_database.dart';
import 'package:vedalaya_app/views/learning/model/recording_model.dart';
import 'package:video_player/video_player.dart';

class RecordingsScreen extends StatefulWidget {
  final VideoPlayerController? videoController;

  const RecordingsScreen({super.key, this.videoController});

  @override
  State<RecordingsScreen> createState() => _RecordingsScreenState();
}

class _RecordingsScreenState extends State<RecordingsScreen> {
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  List<Recording> _recordings = [];
  bool _isLoading = true;
  int? _currentlyPlayingId;
  bool _wasVideoPlaying = false;
  Duration? _playbackPausePosition;

  @override
  void initState() {
    super.initState();
    _loadRecordings();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.closePlayer();
    super.dispose();
  }

  Future<void> _initAudioPlayer() async {
    await _audioPlayer.openPlayer();
  }

  Future<void> _loadRecordings() async {
    setState(() {
      _isLoading = true;
    });
    final recordings = await RecordingDatabase.instance.readAllRecordings();
    setState(() {
      _recordings = recordings;
      _isLoading = false;
    });
  }

  Future<void> _playRecording(Recording recording) async {
    if (_currentlyPlayingId == recording.id) {
      await _stopPlaying();
      return;
    }

    setState(() {
      _currentlyPlayingId = recording.id;
    });

    try {
      // Store current video state if we have a video controller
      if (widget.videoController != null) {
        _wasVideoPlaying = widget.videoController!.value.isPlaying;
        _playbackPausePosition = widget.videoController!.value.position;

        // Pause video and seek to recording position
        if (_wasVideoPlaying) {
          await widget.videoController!.pause();
        }
        await widget.videoController!.seekTo(recording.backgroundPosition);
      }

      // Start playing the voice recording
      await _audioPlayer.startPlayer(
        fromURI: recording.voicePath,
        codec: Codec.aacADTS,
        whenFinished: () async {
          if (mounted) {
            setState(() {
              _currentlyPlayingId = null;
            });
            _resumeBackgroundIfNeeded();
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing recording: $e')),
        );
        setState(() {
          _currentlyPlayingId = null;
        });
        _resumeBackgroundIfNeeded();
      }
    }
  }

  Future<void> _stopPlaying() async {
    await _audioPlayer.stopPlayer();
    if (mounted) {
      setState(() {
        _currentlyPlayingId = null;
      });
    }
    _resumeBackgroundIfNeeded();
  }

  Future<void> _resumeBackgroundIfNeeded() async {
    if (widget.videoController != null &&
        _wasVideoPlaying &&
        _playbackPausePosition != null) {
      await widget.videoController!.seekTo(_playbackPausePosition!);
      await widget.videoController!.play();
      _playbackPausePosition = null;
    }
  }

  Future<void> _deleteRecording(int id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Recording'),
        content: Text('Are you sure you want to delete this recording?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await RecordingDatabase.instance.deleteRecording(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording deleted')),
        );
      }
      await _loadRecordings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Recordings',
          style: GoogleFonts.poppins(
              color: Color.fromRGBO(74, 0, 179, 1),
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _recordings.isEmpty
              ? Center(
                  child: Text(
                    'No recordings yet',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _recordings.length,
                  itemBuilder: (context, index) {
                    final recording = _recordings[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        // leading: Icon(
                        //   Icons.mic,
                        //   color: _currentlyPlayingId == recording.id
                        //       ? Colors.purple
                        //       : Colors.grey,
                        // ),
                        title: Text(
                          recording.title,
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          '${_formatDuration(recording.duration)} - ${recording.createdAt.toString().split(' ')[0]}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                _currentlyPlayingId == recording.id
                                    ? Icons.stop
                                    : Icons.play_arrow,
                                color: Colors.purple,
                              ),
                              onPressed: () => _playRecording(recording),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteRecording(recording.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
