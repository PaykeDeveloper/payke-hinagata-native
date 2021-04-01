import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/sample/books/models/book.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_input.dart';
import 'package:native_app/ui/widgets/atoms/submit_button.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:native_app/ui/widgets/atoms/validate_text_field.dart';

typedef BookFormCallBack = Future<StoreResult?> Function(BookInput input);

class BookForm extends StatefulWidget {
  const BookForm({
    required this.book,
    required this.status,
    required this.onSubmit,
  });

  final Book? book;
  final StateStatus status;
  final BookFormCallBack onSubmit;

  @override
  _BookFormState createState() => _BookFormState();
}

class _BookFormState extends ValidateFormState<BookForm> {
  @override
  Future<StoreResult?> onSubmit() async {
    final input = BookInput.fromJson(formKey.currentState!.value);
    return widget.onSubmit(input);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          FormBuilder(
            key: formKey,
            child: Column(
              children: [
                ValidateTextField(
                  parent: this,
                  name: 'title',
                  labelText: 'Title',
                  initialValue: book?.title,
                  validators: [
                    FormBuilderValidators.required(context),
                  ],
                ),
                const SizedBox(height: 10),
                ValidateTextField(
                  parent: this,
                  name: 'author',
                  labelText: 'Author',
                  initialValue: book?.author,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SubmitButton(
                  onPressed: validateAndSubmit,
                  status: widget.status,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
