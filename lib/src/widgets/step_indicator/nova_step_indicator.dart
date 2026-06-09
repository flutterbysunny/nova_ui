import 'package:flutter/material.dart';

/// Defines the visual style of a [NovaStepIndicator].
enum NovaStepIndicatorStyle {
  /// Numbered circles with connecting line (default).
  numbered,

  /// Dot indicators with connecting line.
  dots,

  /// Progress bar style — filled left to right.
  progress,
}

/// Defines the state of a single step.
enum NovaStepState {
  /// Step is completed — shows checkmark.
  completed,

  /// Step is currently active.
  active,

  /// Step is not yet reached.
  inactive,

  /// Step has an error.
  error,
}

/// A step progress indicator for Nova UI.
///
/// Use for onboarding flows, checkout steps, and multi-step forms.
/// Supports numbered, dots, and progress bar styles.
///
/// Example:
/// ```dart
/// // Numbered steps
/// NovaStepIndicator(
///   totalSteps: 4,
///   currentStep: 1,
/// )
///
/// // With labels
/// NovaStepIndicator(
///   totalSteps: 3,
///   currentStep: 0,
///   labels: ['Account', 'Profile', 'Done'],
/// )
///
/// // Dots style
/// NovaStepIndicator(
///   totalSteps: 5,
///   currentStep: 2,
///   style: NovaStepIndicatorStyle.dots,
/// )
///
/// // Progress bar
/// NovaStepIndicator(
///   totalSteps: 4,
///   currentStep: 2,
///   style: NovaStepIndicatorStyle.progress,
/// )
/// ```
class NovaStepIndicator extends StatelessWidget {
  /// Creates a [NovaStepIndicator] widget.
  const NovaStepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.style = NovaStepIndicatorStyle.numbered,
    this.labels,
    this.activeColor,
    this.completedColor,
    this.inactiveColor,
    this.errorColor,
    this.stepStates,
    this.size = 32,
    this.lineThickness = 2,
  }) : assert(
  currentStep >= 0 && currentStep < totalSteps,
  'currentStep must be between 0 and totalSteps - 1',
  );

  /// Total number of steps.
  final int totalSteps;

  /// Index of the currently active step (0-based).
  final int currentStep;

  /// Visual style — numbered, dots, or progress.
  final NovaStepIndicatorStyle style;

  /// Optional labels shown below each step.
  final List<String>? labels;

  /// Color for the active step. Defaults to theme primary.
  final Color? activeColor;

  /// Color for completed steps. Defaults to theme primary.
  final Color? completedColor;

  /// Color for inactive steps.
  final Color? inactiveColor;

  /// Color for error steps.
  final Color? errorColor;

  /// Override state for each step. Auto-computed if null.
  final List<NovaStepState>? stepStates;

  /// Size of step circles. Defaults to 32px.
  final double size;

  /// Thickness of connecting lines. Defaults to 2px.
  final double lineThickness;

  NovaStepState _stateForIndex(int index) {
    if (stepStates != null) return stepStates![index];
    if (index < currentStep) return NovaStepState.completed;
    if (index == currentStep) return NovaStepState.active;
    return NovaStepState.inactive;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final active = activeColor ?? scheme.primary;
    final completed = completedColor ?? scheme.primary;
    final inactive = inactiveColor ?? scheme.onSurface.withValues(alpha: 0.2);
    final error = errorColor ?? scheme.error;

    if (style == NovaStepIndicatorStyle.progress) {
      return _buildProgress(context, active, scheme);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Step row
        Row(
          children: List.generate(totalSteps * 2 - 1, (i) {
            // Connector line
            if (i.isOdd) {
              final stepIndex = i ~/ 2;
              final isCompleted = stepIndex < currentStep;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: lineThickness,
                  color: isCompleted ? completed : inactive,
                ),
              );
            }

            // Step circle/dot
            final index = i ~/ 2;
            final state = _stateForIndex(index);

            if (style == NovaStepIndicatorStyle.dots) {
              return _buildDot(state, active, completed, inactive, error);
            }

            return _buildNumbered(
              index, state, active, completed, inactive, error, scheme,
            );
          }),
        ),

        // Labels
        if (labels != null && labels!.length == totalSteps) ...[
          const SizedBox(height: 8),
          Row(
            children: List.generate(totalSteps * 2 - 1, (i) {
              if (i.isOdd) return const Expanded(child: SizedBox());
              final index = i ~/ 2;
              final state = _stateForIndex(index);
              final labelColor = state == NovaStepState.active
                  ? active
                  : state == NovaStepState.completed
                  ? completed
                  : scheme.onSurfaceVariant;

              return SizedBox(
                width: size,
                child: Text(
                  labels![index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 11,
                    fontWeight: state == NovaStepState.active
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildNumbered(
      int index,
      NovaStepState state,
      Color active,
      Color completed,
      Color inactive,
      Color error,
      ColorScheme scheme,
      ) {
    final Color bgColor;
    final Color borderColor;
    final Widget child;

    switch (state) {
      case NovaStepState.completed:
        bgColor = completed;
        borderColor = completed;
        child = Icon(Icons.check_rounded, color: Colors.white, size: size * 0.5);
        break;
      case NovaStepState.active:
        bgColor = active;
        borderColor = active;
        child = Text(
          '${index + 1}',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w700,
          ),
        );
        break;
      case NovaStepState.error:
        bgColor = error;
        borderColor = error;
        child = Icon(Icons.close_rounded, color: Colors.white, size: size * 0.5);
        break;
      case NovaStepState.inactive:
        bgColor = Colors.transparent;
        borderColor = inactive;
        child = Text(
          '${index + 1}',
          style: TextStyle(
            color: inactive,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w600,
          ),
        );
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Center(child: child),
    );
  }

  Widget _buildDot(
      NovaStepState state,
      Color active,
      Color completed,
      Color inactive,
      Color error,
      ) {
    final double dotSize;
    final Color color;

    switch (state) {
      case NovaStepState.active:
        dotSize = size * 0.5;
        color = active;
        break;
      case NovaStepState.completed:
        dotSize = size * 0.35;
        color = completed;
        break;
      case NovaStepState.error:
        dotSize = size * 0.35;
        color = error;
        break;
      case NovaStepState.inactive:
        dotSize = size * 0.35;
        color = inactive;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildProgress(
      BuildContext context,
      Color active,
      ColorScheme scheme,
      ) {
    final progress = (currentStep + 1) / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Step count text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (labels != null && currentStep < labels!.length)
              Text(
                labels![currentStep],
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              )
            else
              Text(
                'Step ${currentStep + 1}',
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            Text(
              '${currentStep + 1}/$totalSteps',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: Stack(
            children: [
              Container(
                height: lineThickness * 3,
                width: double.infinity,
                color: active.withValues(alpha: 0.15),
              ),
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                widthFactor: progress,
                child: Container(
                  height: lineThickness * 3,
                  decoration: BoxDecoration(
                    color: active,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}