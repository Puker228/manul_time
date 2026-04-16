/// Abstract contract for counter persistence.
/// The domain layer depends on this interface; concrete implementations
/// live in the data layer — keeping business logic storage-agnostic.
abstract class CounterRepository {
  /// Returns the last saved counter value, or [BigInt.zero] if none exists.
  Future<BigInt> loadCounter();

  /// Persists [count] to local storage.
  Future<void> saveCounter(BigInt count);
}
