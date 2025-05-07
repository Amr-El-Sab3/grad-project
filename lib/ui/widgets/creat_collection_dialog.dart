import 'package:emotion_detection/bloc/collection_bloc/collection_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emotion_detection/bloc/collection_bloc/collection_bloc.dart';

class CreateCollectionDialog extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  CreateCollectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Collection'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Collection Name',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final String collectionName = _nameController.text.trim();
            if (collectionName.isNotEmpty) {
              // Dispatch the CreateCollection event
              context.read<CollectionBloc>().add(CreateCollection(collectionName));
              Navigator.of(context).pop(); // Close the dialog
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid name')),
              );
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}