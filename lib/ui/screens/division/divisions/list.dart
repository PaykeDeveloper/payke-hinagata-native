// FIXME: SAMPLE CODE
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
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

class DivisionListScreen extends ConsumerWidget {
  const DivisionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future initState() async {
      await ref
          .read(divisionsStateProvider.notifier)
          .fetchEntitiesIfNeeded(url: null, reset: true);
    }

    Future onRefresh() async {
      await ref.read(divisionsStateProvider.notifier).fetchEntities(url: null);
    }

    Future setDivisionId(DivisionId divisionId) async {
      await ref
          .read(divisionIdStateProvider.notifier)
          .setDivisionId(divisionId);
    }

    final error = ref.watch(divisionsErrorSelector);
    final divisions = ref.watch(divisionsSelector);
    final selectedId = ref.watch(divisionIdSelector);

    return DivisionList(
      initState: initState,
      onRefresh: onRefresh,
      setDivisionId: setDivisionId,
      error: error,
      divisions: divisions,
      selectedId: selectedId,
    );
  }
}

class DivisionList extends StatefulWidget {
  const DivisionList({
    super.key,
    required Function0<Future> initState,
    required Function0<Future> onRefresh,
    required Function1<DivisionId, Future> setDivisionId,
    required StoreError? error,
    required List<Division> divisions,
    required DivisionId? selectedId,
  })  : _initState = initState,
        _onRefresh = onRefresh,
        _setDivisionId = setDivisionId,
        _error = error,
        _divisions = divisions,
        _selectedId = selectedId;

  final Function0<Future> _initState;
  final Function0<Future> _onRefresh;
  final Function1<DivisionId, Future> _setDivisionId;
  final StoreError? _error;
  final List<Division> _divisions;
  final DivisionId? _selectedId;

  @override
  State<DivisionList> createState() => _DivisionListState();
}

class _DivisionListState extends State<DivisionList> {
  bool _loading = false;

  Future _initState() async {
    setState(() {
      _loading = true;
    });
    await widget._initState();
    setState(() {
      _loading = false;
    });
  }

  void _onPressedNew() {
    Navigator.of(context)
        .push(
            MaterialPageRoute(builder: (context) => const DivisionAddScreen()))
        .then((value) => _initState());
  }

  Future _onTapSelect(DivisionId divisionId) async {
    await widget._setDivisionId(divisionId);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _onPressedEdit(DivisionId divisionId) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => DivisionEditScreen(divisionId: divisionId)))
        .then((value) => _initState());
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Divisions')),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedNew,
        child: const Icon(Icons.add),
      ),
      body: ErrorWrapper(
        error: widget._error,
        onPressedReload: _initState,
        child: Loader(
          loading: _loading,
          child: RefreshIndicator(
            onRefresh: widget._onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 60),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget._divisions.length,
              itemBuilder: (context, index) {
                final division = widget._divisions[index];
                return _ListItem(
                  division: division,
                  onTapItem: () => _onTapSelect(division.id),
                  onPressedEdit: () => _onPressedEdit(division.id),
                  selected: division.id == widget._selectedId,
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
