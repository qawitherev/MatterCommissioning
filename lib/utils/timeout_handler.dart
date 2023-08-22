import 'dart:async';


@Deprecated("Don't use this, use timeout(duration) instead")
class AsyncTimeoutHandler {
  static Future<T> executeWithTimeout<T>(
      Future<T> Function() asyncFunction, Duration timeoutDuration, FutureOr<void> Function() onTimeout) async {

    Completer<T> completer = Completer<T>();
    Timer timeoutTimer = Timer(timeoutDuration, () {
      if (!completer.isCompleted) {
        completer.completeError("Operation timed out");
        onTimeout();
      }
    });

    try {
      T result = await asyncFunction();
      if (!completer.isCompleted) {
        completer.complete(result);
      }
    } catch (e) {
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    } finally {
      timeoutTimer.cancel();
    }

    return completer.future;
  }
}
