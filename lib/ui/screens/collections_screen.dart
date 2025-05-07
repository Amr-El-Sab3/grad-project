import 'package:emotion_detection/bloc/collection_bloc/collection_bloc.dart';
import 'package:emotion_detection/bloc/collection_bloc/collection_event.dart';
import 'package:emotion_detection/network/web_services/collection_service.dart';
import 'package:emotion_detection/ui/widgets/collection_list.dart';
import 'package:emotion_detection/ui/widgets/creat_collection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: BlocProvider(
        create: (context) => CollectionBloc(apiService: CollectionsService())
          ..add(FetchCollections()),
        child: const CollectionListWidget(),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CreateCollectionDialog(),
          );
        },
        tooltip: 'Create New Collection',
        child: const Icon(Icons.add),
      ),
    );
  }
}
