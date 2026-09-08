import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:studydocs/core/constants/app_colors.dart';

class VoiceSearchBottomSheet extends StatefulWidget {
  const VoiceSearchBottomSheet({super.key});

  @override
  State<VoiceSearchBottomSheet> createState() => _VoiceSearchBottomSheetState();
}

class _VoiceSearchBottomSheetState extends State<VoiceSearchBottomSheet> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Đang lắng nghe...';
  
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _listen();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done') {
            setState(() => _isListening = false);
            Future.delayed(const Duration(milliseconds: 800), () {
              if (mounted && _text != 'Đang lắng nghe...' && _text.isNotEmpty) {
                Navigator.pop(context, _text);
              } else if (mounted) {
                Navigator.pop(context, null);
              }
            });
          }
        },
        onError: (val) {
          setState(() {
            _isListening = false;
            _text = 'Không nghe rõ, thử lại...';
          });
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      } else {
        setState(() {
          _isListening = false;
          _text = 'Mic không hoạt động hoặc không có quyền.';
        });
      }
    }
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const Text(
            'Tìm kiếm bằng giọng nói',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Container(
            padding: EdgeInsets.all(_isListening ? 12 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: _isListening ? 0.2 : 0.0),
            ),
            child: FloatingActionButton(
              onPressed: _isListening ? _speech.stop : _listen,
              backgroundColor: AppColors.primary,
              elevation: 0,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none, color: AppColors.white),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
