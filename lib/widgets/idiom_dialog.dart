
import 'package:flutter/material.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/providers/tts_provider.dart';
import 'package:provider/provider.dart';

class IdiomDialog extends StatefulWidget {
  final Idiom idiom;
  final VoidCallback? onLearnedPressed;

  const IdiomDialog({
    super.key,
    required this.idiom,
    this.onLearnedPressed,
  });

  @override
  State<IdiomDialog> createState() => _IdiomDialogState();
}

class _IdiomDialogState extends State<IdiomDialog> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _idiomFadeAnimation;
  late Animation<double> _definitionFadeAnimation;
  late Animation<double> _exampleFadeAnimation;
  late Animation<double> _translationFadeAnimation;
  late Animation<double> _buttonFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _idiomFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    _definitionFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
      ),
    );

    _exampleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
      ),
    );

    _translationFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.8, curve: Curves.easeOut),
      ),
    );

    _buttonFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    final ttsProvider = Provider.of<TtsProvider>(context, listen: false);
    await ttsProvider.speak(text);
  }

  Future<void> _stop() async {
    final ttsProvider = Provider.of<TtsProvider>(context, listen: false);
    await ttsProvider.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _idiomFadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.idiom.idiom,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _speak(widget.idiom.idiom),
                          icon: const Icon(Icons.volume_up),
                          color: Theme.of(context).primaryColor,
                          tooltip: 'Speak idiom',
                        ),
                        IconButton(
                          onPressed: () {
                            _stop();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.black,
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _definitionFadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Definition',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => _speak(widget.idiom.definition),
                                    icon: const Icon(Icons.volume_up),
                                    color: Theme.of(context).primaryColor,
                                    iconSize: 20,
                                    tooltip: 'Speak definition',
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(minHeight: 24, minWidth: 24),
                                  ),
                                  Icon(
                                    Icons.info_outline,
                                    color: Theme.of(context).primaryColor,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.idiom.definition,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _exampleFadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Example',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[700],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      String examplesText = widget.idiom.examples.join('. ');
                                      _speak(examplesText);
                                    },
                                    icon: const Icon(Icons.volume_up),
                                    color: Colors.blue[700],
                                    iconSize: 20,
                                    tooltip: 'Speak examples',
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(minHeight: 24, minWidth: 24),
                                  ),
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.blue[700],
                                    size: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.idiom.examples.asMap().entries.map((entry) =>
                                Text('${entry.key + 1}. ${entry.value}')
                            ).toList(),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _translationFadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Translation',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[700],
                                ),
                              ),
                              Icon(
                                Icons.translate,
                                color: Colors.blue[700],
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.idiom.translations["de"]!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _buttonFadeAnimation,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.onLearnedPressed != null) {
                            widget.onLearnedPressed!();
                          }
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Got it',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}