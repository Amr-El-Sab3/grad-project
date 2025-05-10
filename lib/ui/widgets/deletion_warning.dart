import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emotion_detection/bloc/collection_bloc/collection_bloc.dart';
import 'package:emotion_detection/bloc/collection_bloc/collection_event.dart';

class DeletionWarningDialog extends StatelessWidget {
  final String collectionId;
  final String collectionName;

  const DeletionWarningDialog({
    super.key,
    required this.collectionId,
    required this.collectionName,
  });

  static Future<void> show(BuildContext context, String collectionId, String collectionName) async {
    print('Showing delete dialog for collection: $collectionName (ID: $collectionId)');
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeletionWarningDialog(
          collectionId: collectionId,
          collectionName: collectionName,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Collection'),
      content: Text('Are you sure you want to delete the collection "$collectionName"?', style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            print('Delete cancelled');
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
          onPressed: () {
            print('Delete confirmed for collection: $collectionName (ID: $collectionId)');
            context.read<CollectionBloc>().add(DeleteCollection(collectionId));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
