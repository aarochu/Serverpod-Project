import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Demo walkthrough overlay with step-by-step highlighting
class DemoOverlay extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final VoidCallback? onComplete;

  const DemoOverlay({
    super.key,
    required this.child,
    this.enabled = false,
    this.onComplete,
  });

  @override
  State<DemoOverlay> createState() => _DemoOverlayState();
}

class _DemoOverlayState extends State<DemoOverlay> {
  int _currentStep = 0;
  final List<DemoStep> _steps = [
    DemoStep(
      id: 'login',
      title: 'Step 1: GitHub Login',
      description: 'Authenticate with GitHub to access your repositories',
      targetKey: 'github_login_button',
    ),
    DemoStep(
      id: 'sync',
      title: 'Step 2: Sync Repository',
      description: 'Sync a repository from GitHub to Code Butler',
      targetKey: 'sync_repo_button',
    ),
    DemoStep(
      id: 'pr',
      title: 'Step 3: Select Pull Request',
      description: 'Choose a pull request to review',
      targetKey: 'pr_list',
    ),
    DemoStep(
      id: 'review',
      title: 'Step 4: Start Review',
      description: 'Initiate the AI-powered code review',
      targetKey: 'start_review_button',
    ),
    DemoStep(
      id: 'progress',
      title: 'Step 5: Watch Progress',
      description: 'Monitor real-time agent activity and progress',
      targetKey: 'review_progress',
    ),
    DemoStep(
      id: 'findings',
      title: 'Step 6: View Findings',
      description: 'Review issues discovered by AI agents',
      targetKey: 'findings_list',
    ),
    DemoStep(
      id: 'fix',
      title: 'Step 7: Apply Fix',
      description: 'Automatically apply suggested fixes',
      targetKey: 'apply_fix_button',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        if (_currentStep < _steps.length)
          _buildOverlay(context),
      ],
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final step = _steps[_currentStep];

    return GestureDetector(
      onTap: () => _nextStep(),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        step.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        step.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Step ${_currentStep + 1} of ${_steps.length}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (_currentStep > 0)
                            TextButton(
                              onPressed: () => _previousStep(),
                              child: const Text('Previous'),
                            ),
                          FilledButton(
                            onPressed: () => _nextStep(),
                            child: Text(_currentStep == _steps.length - 1 ? 'Complete' : 'Next'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Step indicators
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _steps.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentStep
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      widget.onComplete?.call();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Listen for keyboard shortcuts
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (!widget.enabled) return;

    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.space) {
        _nextStep();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _previousStep();
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        widget.onComplete?.call();
      }
    }
  }
}

class DemoStep {
  final String id;
  final String title;
  final String description;
  final String targetKey;

  DemoStep({
    required this.id,
    required this.title,
    required this.description,
    required this.targetKey,
  });
}

