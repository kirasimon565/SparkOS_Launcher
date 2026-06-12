import 'package:flutter/material.dart';
import '../../models/folder_model.dart';
import '../../models/app_model.dart';
import '../../widgets/spark_icon.dart';

class FolderEditor extends StatefulWidget {
  final FolderModel folder;
  final List<AppModel> availableApps;

  const FolderEditor({
    super.key,
    required this.folder,
    required this.availableApps,
  });

  @override
  State<FolderEditor> createState() => _FolderEditorState();
}

class _FolderEditorState extends State<FolderEditor> {
  late TextEditingController _nameController;
  late List<AppModel> _selectedApps;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.folder.name);
    _selectedApps = List.from(widget.folder.contents);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Folder'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.amber),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 24),
              decoration: const InputDecoration(
                hintText: 'Folder Name',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber, width: 2)),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                ),
                itemCount: widget.availableApps.length,
                itemBuilder: (context, index) {
                  final app = widget.availableApps[index];
                  final isSelected = _selectedApps.contains(app);

                  return Stack(
                    children: [
                      SparkIcon(
                        iconBytes: app.iconBytes,
                        label: app.title,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedApps.remove(app);
                            } else {
                              _selectedApps.add(app);
                            }
                          });
                        },
                      ),
                      if (isSelected)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
                            ),
                            child: const Icon(Icons.check, size: 16, color: Colors.black),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
