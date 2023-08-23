// FIXME: SAMPLE CODE
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/divisions/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/selectors.dart';
import 'package:native_app/store/state/ui/division_id/notifier.dart';
import 'package:native_app/store/state/ui/division_id/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';

import './add.dart';
import './edit.dart';

class DivisionListScreen extends HookConsumerWidget {
  const DivisionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initState = useCallback(() async {
      await ref
          .read(divisionsStateProvider.notifier)
          .fetchEntitiesIfNeeded(url: null, reset: true);
    }, []);

    useEffect(() {
      Future.delayed(Duration.zero, initState);
      return null;
    }, [initState]);

    final onRefresh = useCallback(() async {
      await ref
          .read(divisionsStateProvider.notifier)
          .fetchEntities(url: null, silent: true);
    }, []);

    final onBack = useCallback(() async {
      await ref.read(divisionsStateProvider.notifier).fetchEntities(url: null);
    }, []);
    final onPressedNew = useCallback(
        () => Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => const DivisionAddScreen()))
            .then((value) => onBack()),
        [onBack]);

    final onPressedEdit = useCallback((DivisionId divisionId) {
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => DivisionEditScreen(divisionId: divisionId)))
          .then((value) => onBack());
    }, [onBack]);

    final onTapSelect = useCallback((DivisionId divisionId) async {
      await ref.read(divisionIdStateProvider.notifier).set(divisionId);
      Navigator.of(context).popUntil((route) => route.isFirst);
    }, []);

    final status = ref.watch(divisionsStatusSelector);
    final error = ref.watch(divisionsErrorSelector);
    final divisions = ref.watch(divisionsSelector);
    final selectedId = ref.watch(divisionIdSelector);

    return _DivisionList(
      onPressedReload: initState,
      onRefresh: onRefresh,
      onPressedNew: onPressedNew,
      onPressedEdit: onPressedEdit,
      onTapSelect: onTapSelect,
      status: status,
      error: error,
      divisions: divisions,
      selectedId: selectedId,
    );
  }
}

class _DivisionList extends StatelessWidget {
  const _DivisionList({
    required this.onPressedReload,
    required this.onRefresh,
    required this.onPressedNew,
    required this.onPressedEdit,
    required this.onTapSelect,
    required this.status,
    required this.error,
    required this.divisions,
    required this.selectedId,
  });

  final VoidCallback onPressedReload;
  final Function0<Future> onRefresh;
  final VoidCallback onPressedNew;
  final Function1<DivisionId, void> onPressedEdit;
  final Function1<DivisionId, void> onTapSelect;
  final StateStatus status;
  final StoreError? error;
  final List<Division> divisions;
  final DivisionId? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Divisions')),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressedNew,
        child: const Icon(Icons.add),
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: onPressedReload,
        child: Loader(
          status: status,
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 60),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: divisions.length,
              itemBuilder: (context, index) {
                final division = divisions[index];
                return _ListItem(
                  division: division,
                  onTapItem: () => onTapSelect(division.id),
                  onPressedEdit: () => onPressedEdit(division.id),
                  selected: division.id == selectedId,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required Division division,
    required GestureTapCallback onTapItem,
    required VoidCallback onPressedEdit,
    required bool selected,
  })  : _division = division,
        _onTapItem = onTapItem,
        _onPressedEdit = onPressedEdit,
        _selected = selected;

  final Division _division;
  final GestureTapCallback _onTapItem;
  final VoidCallback _onPressedEdit;
  final bool _selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: _onTapItem,
        leading: Text('${_division.id.value}'),
        title: Text(_division.name),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _onPressedEdit,
        ),
        selected: _selected,
      ),
    );
  }
}
