import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_butler_client/code_butler_client.dart';
import '../config/serverpod_client.dart';

/// Autofix status enum
enum AutofixStatus {
  pending,
  applying,
  success,
  failed,
}

/// Autofix state
class AutofixState {
  final AutofixStatus status;
  final int? findingId;
  final String? prUrl;
  final String? error;
  final Map<int, AutofixState> batchStates; // For tracking multiple fixes

  AutofixState({
    this.status = AutofixStatus.pending,
    this.findingId,
    this.prUrl,
    this.error,
    Map<int, AutofixState>? batchStates,
  }) : batchStates = batchStates ?? {};

  AutofixState copyWith({
    AutofixStatus? status,
    int? findingId,
    String? prUrl,
    String? error,
    Map<int, AutofixState>? batchStates,
  }) {
    return AutofixState(
      status: status ?? this.status,
      findingId: findingId ?? this.findingId,
      prUrl: prUrl ?? this.prUrl,
      error: error ?? this.error,
      batchStates: batchStates ?? this.batchStates,
    );
  }
}

/// Autofix notifier for managing fix operations
class AutofixNotifier extends StateNotifier<AutofixState> {
  AutofixNotifier() : super(AutofixState());

  /// Apply fix for a single finding
  Future<void> applyFix(int findingId) async {
    state = state.copyWith(
      status: AutofixStatus.applying,
      findingId: findingId,
      error: null,
    );

    try {
      final client = ClientManager.client;
      
      // Try to use autofix endpoint if available
      if (client.autofix != null) {
        try {
          final result = await client.autofix.applyFix(findingId);
          
          state = state.copyWith(
            status: AutofixStatus.success,
            prUrl: result.prUrl,
          );
        } catch (e) {
          // Endpoint might not exist yet
          state = state.copyWith(
            status: AutofixStatus.failed,
            error: 'Autofix endpoint not available. Please ensure backend is updated.',
          );
        }
      } else {
        // Fallback: simulate success for demo purposes
        state = state.copyWith(
          status: AutofixStatus.failed,
          error: 'Autofix service not available. Backend endpoint needs to be implemented.',
        );
      }
    } catch (error) {
      state = state.copyWith(
        status: AutofixStatus.failed,
        error: error.toString(),
      );
    }
  }

  /// Apply fixes for multiple findings in batch
  Future<void> batchApplyFix(List<int> findingIds) async {
    final batchStates = <int, AutofixState>{};
    
    // Initialize all batch states
    for (final findingId in findingIds) {
      batchStates[findingId] = AutofixState(
        status: AutofixStatus.applying,
        findingId: findingId,
      );
    }
    
    state = state.copyWith(
      status: AutofixStatus.applying,
      batchStates: batchStates,
    );

    try {
      final client = ClientManager.client;
      
      // Try to use autofix endpoint if available
      if (client.autofix != null) {
        try {
          final results = await client.autofix.batchApplyFix(findingIds);
          
          // Update batch states with results
          final updatedBatchStates = <int, AutofixState>{};
          for (final result in results) {
            updatedBatchStates[result.findingId] = AutofixState(
              status: result.success ? AutofixStatus.success : AutofixStatus.failed,
              findingId: result.findingId,
              prUrl: result.prUrl,
              error: result.error,
            );
          }
          
          // Mark any missing findings as failed
          for (final findingId in findingIds) {
            if (!updatedBatchStates.containsKey(findingId)) {
              updatedBatchStates[findingId] = AutofixState(
                status: AutofixStatus.failed,
                findingId: findingId,
                error: 'Fix application failed',
              );
            }
          }
          
          state = state.copyWith(
            status: AutofixStatus.success,
            batchStates: updatedBatchStates,
          );
        } catch (e) {
          // Endpoint might not exist yet
          final failedStates = <int, AutofixState>{};
          for (final findingId in findingIds) {
            failedStates[findingId] = AutofixState(
              status: AutofixStatus.failed,
              findingId: findingId,
              error: 'Autofix endpoint not available',
            );
          }
          
          state = state.copyWith(
            status: AutofixStatus.failed,
            batchStates: failedStates,
            error: 'Autofix endpoint not available. Please ensure backend is updated.',
          );
        }
      } else {
        // Fallback: mark all as failed
        final failedStates = <int, AutofixState>{};
        for (final findingId in findingIds) {
          failedStates[findingId] = AutofixState(
            status: AutofixStatus.failed,
            findingId: findingId,
            error: 'Autofix service not available',
          );
        }
        
        state = state.copyWith(
          status: AutofixStatus.failed,
          batchStates: failedStates,
          error: 'Autofix service not available. Backend endpoint needs to be implemented.',
        );
      }
    } catch (error) {
      final failedStates = <int, AutofixState>{};
      for (final findingId in findingIds) {
        failedStates[findingId] = AutofixState(
          status: AutofixStatus.failed,
          findingId: findingId,
          error: error.toString(),
        );
      }
      
      state = state.copyWith(
        status: AutofixStatus.failed,
        batchStates: failedStates,
        error: error.toString(),
      );
    }
  }

  /// Reset state
  void reset() {
    state = AutofixState();
  }

  /// Get state for a specific finding (for batch operations)
  AutofixState? getFindingState(int findingId) {
    return state.batchStates[findingId];
  }
}

/// Provider for autofix operations
final autofixProvider = StateNotifierProvider<AutofixNotifier, AutofixState>((ref) {
  return AutofixNotifier();
});

