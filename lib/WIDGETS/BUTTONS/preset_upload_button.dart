import 'dart:ui';
import 'package:flutter/material.dart';

class UploadPresetButton extends StatefulWidget {
  final Function(String) onUpload;

  const UploadPresetButton({super.key, required this.onUpload});

  @override
  _UploadPresetButtonState createState() => _UploadPresetButtonState();
}

class _UploadPresetButtonState extends State<UploadPresetButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _blurAnimation = Tween<double>(begin: 0, end: 5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showCustomPopupMenu(BuildContext context) {
    showDialog(
      barrierColor: Colors.black12,
      context: context,
      barrierDismissible: true,
      builder: (context) {
        _controller.forward();

        return AnimatedBuilder(
          animation: _blurAnimation,
          builder: (context, child) {
            return Dialog(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: _blurAnimation.value,
                        sigmaY: _blurAnimation.value,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  // Actual Menu Content
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading:
                              const Icon(Icons.file_upload, color: Colors.blue),
                          title: const Text('Upload Single Preset'),
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onUpload('single');
                            _controller.reverse();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.folder, color: Colors.blue),
                          title: const Text('Upload Preset Pack'),
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onUpload('pack');
                            _controller.reverse();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      // Reset the animation on dialog dismiss
      _controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showCustomPopupMenu(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.cloud_upload_rounded,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }
}
