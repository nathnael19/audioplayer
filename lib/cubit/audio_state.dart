part of 'audio_cubit.dart';

class AudioState {
  final Duration position;
  final Duration buffered;
  final Duration duration;
  final bool isPlaying;
  final String? errorMessage;

  const AudioState({
    required this.position,
    required this.buffered,
    required this.duration,
    required this.isPlaying,
    this.errorMessage,
  });

  factory AudioState.initial() {
    return const AudioState(
      position: Duration.zero,
      buffered: Duration.zero,
      duration: Duration.zero,
      isPlaying: false,
      errorMessage: null,
    );
  }

  AudioState copyWith({
    Duration? position,
    Duration? buffered,
    Duration? duration,
    bool? isPlaying,
    String? errorMessage,
  }) {
    return AudioState(
      position: position ?? this.position,
      buffered: buffered ?? this.buffered,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    position,
    buffered,
    duration,
    isPlaying,
    errorMessage,
  ];
}
