import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_datasource.dart';

/// Concrete implementation wiring the domain interface to the datasource.
/// Swap this class (e.g. for a remote backend) without touching domain/presentation.
class CounterRepositoryImpl implements CounterRepository {
  const CounterRepositoryImpl(this._datasource);

  final CounterLocalDatasource _datasource;

  @override
  Future<BigInt> loadCounter() => _datasource.loadCounter();

  @override
  Future<void> saveCounter(BigInt count) => _datasource.saveCounter(count);
}
