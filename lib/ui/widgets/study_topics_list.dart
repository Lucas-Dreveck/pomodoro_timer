// lib/ui/widgets/study_topics_list.dart
import 'package:flutter/material.dart';
import '../../data/models/study_topic.dart';
import '../../data/services/db_service.dart';

class StudyTopicsList extends StatefulWidget {
  final int? selectedTopicId;
  final Function(int?) onTopicSelected;

  const StudyTopicsList({
    Key? key,
    required this.selectedTopicId,
    required this.onTopicSelected,
  }) : super(key: key);

  @override
  State<StudyTopicsList> createState() => _StudyTopicsListState();
}

class _StudyTopicsListState extends State<StudyTopicsList> {
  final DBService _dbService = DBService();
  List<StudyTopic> _topics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    setState(() {
      _isLoading = true;
    });

    final topics = await _dbService.getTopics();

    setState(() {
      _topics = topics;
      _isLoading = false;
    });
  }

  Future<void> _addTopic() async {
    final TextEditingController nameController = TextEditingController();
    final selectedColor = ValueNotifier<Color>(Colors.blue);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Topic'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Topic Name',
                hintText: 'Ex: Mathematics, History, etc.',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Choose Color:'),
            const SizedBox(height: 8),
            ValueListenableBuilder<Color>(
              valueListenable: selectedColor,
              builder: (context, color, _) {
                return Wrap(
                  spacing: 8,
                  children: [
                    Colors.red,
                    Colors.pink,
                    Colors.purple,
                    Colors.deepPurple,
                    Colors.indigo,
                    Colors.blue,
                    Colors.lightBlue,
                    Colors.cyan,
                    Colors.teal,
                    Colors.green,
                    Colors.lightGreen,
                    Colors.lime,
                    Colors.yellow,
                    Colors.amber,
                    Colors.orange,
                    Colors.deepOrange,
                    Colors.brown,
                    Colors.grey,
                    Colors.blueGrey,
                  ].map((c) {
                    return GestureDetector(
                      onTap: () {
                        selectedColor.value = c;
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: c == color
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final newTopic = StudyTopic(
                  name: nameController.text,
                  color: selectedColor.value.toARGB32(),
                );

                await _dbService.insertTopic(newTopic);
                await _loadTopics();

                if (!context.mounted) return;

                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTopic(StudyTopic topic) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Topic'),
        content: Text('Are you sure you want to delete "${topic.name}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _dbService.deleteTopic(topic.id!);

      if (widget.selectedTopicId == topic.id) {
        widget.onTopicSelected(null);
      }

      await _loadTopics();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_topics.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No study topics yet',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addTopic,
              icon: const Icon(Icons.add),
              label: const Text('Add Topic'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: _topics.length,
          itemBuilder: (context, index) {
            final topic = _topics[index];
            final color = Color(topic.color);
            final isSelected = topic.id == widget.selectedTopicId;

            return ListTile(
              leading: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(topic.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteTopic(topic),
              ),
              selected: isSelected,
              selectedTileColor: color.withValues(alpha: 0.1),
              onTap: () {
                widget.onTopicSelected(topic.id);
              },
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _addTopic,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
