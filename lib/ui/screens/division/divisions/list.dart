// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/divisions/models/divisions_url.dart';
import 'package:native_app/store/state/domain/division/divisions/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/selectors.dart';
import 'package:native_app/store/state/ui/division_id/notifier.dart';
import 'package:native_app/store/state/ui/division_id/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

import './add.dart';
import './edit.dart';

class DivisionListScreen extends StatefulWidget {
  const DivisionListScreen();

  @override
  _DivisionListScreenState createState() => _DivisionListScreenState();
}

class _DivisionListScreenState extends State<DivisionListScreen> {
  bool _loading = false;

  Future _initState() async {
    setState(() {
      _loading = true;
    });
    await context
        .read<DivisionsNotifier>()
        .fetchEntitiesIfNeeded(url: const DivisionsUrl(), reset: true);
    setState(() {
      _loading = false;
    });
  }

  Future _onRefresh() async {
    await context
        .read<DivisionsNotifier>()
        .fetchEntities(url: const DivisionsUrl());
  }

  void _onPressedNew() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => DivisionAddScreen()))
        .then((value) => _initState());
  }

  Future _onTapSelect(DivisionId divisionId) async {
    await context.read<DivisionIdNotifier>().setDivisionId(divisionId);
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
    final divisions = context.select(divisionsSelector);
    final error = context.select(divisionsErrorSelector);
    final selectedId = context.select(divisionIdSelector);

    return Scaffold(
      appBar: AppBar(title: const Text('Divisions')),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedNew,
        child: const Icon(Icons.add),
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: _initState,
        child: Loader(
          loading: _loading,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: divisions.length,
              itemBuilder: (context, index) {
                final division = divisions[index];
                return _ListItem(
                  division: division,
                  onTapItem: () => _onTapSelect(division.id),
                  onPressedEdit: () => _onPressedEdit(division.id),
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
  })   : _division = division,
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
