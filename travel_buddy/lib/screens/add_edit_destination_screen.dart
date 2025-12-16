import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/destination.dart';
import '../providers/bucket_list_provider.dart';
import '../widgets/custom_button.dart';

/// Screen for adding or editing a destination
class AddEditDestinationScreen extends StatefulWidget {
  final Destination? destination;

  const AddEditDestinationScreen({super.key, this.destination});

  @override
  State<AddEditDestinationScreen> createState() =>
      _AddEditDestinationScreenState();
}

class _AddEditDestinationScreenState extends State<AddEditDestinationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placeNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isVisited = false;
  bool _isLoading = false;

  bool get _isEditing => widget.destination != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _placeNameController.text = widget.destination!.placeName;
      _countryController.text = widget.destination!.country;
      _notesController.text = widget.destination!.notes;
      _isVisited = widget.destination!.isVisited;
    }
  }

  @override
  void dispose() {
    _placeNameController.dispose();
    _countryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Destination' : 'Add Destination'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.place,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Place Name field
            TextFormField(
              controller: _placeNameController,
              decoration: const InputDecoration(
                labelText: 'Place Name',
                hintText: 'e.g., Eiffel Tower',
                prefixIcon: Icon(Icons.location_city),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a place name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Country field
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Country',
                hintText: 'e.g., France',
                prefixIcon: Icon(Icons.flag),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a country';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Notes field
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Add your thoughts or plans...',
                prefixIcon: Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),

            const SizedBox(height: 16),

            // Visited checkbox
            Card(
              child: CheckboxListTile(
                title: const Text('Already Visited'),
                subtitle: const Text('Mark this if you\'ve already been here'),
                value: _isVisited,
                onChanged: (value) {
                  setState(() {
                    _isVisited = value ?? false;
                  });
                },
                secondary: Icon(
                  _isVisited ? Icons.check_circle : Icons.pending,
                  color: _isVisited ? Colors.green : Colors.orange,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Save button
            CustomButton(
              text: _isEditing ? 'Update Destination' : 'Add Destination',
              onPressed: _saveDestination,
              isLoading: _isLoading,
              icon: _isEditing ? Icons.update : Icons.add,
            ),

            const SizedBox(height: 12),

            // Cancel button
            CustomButton(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context),
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDestination() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = context.read<BucketListProvider>();

      if (_isEditing) {
        // Update existing destination
        final updated = widget.destination!.copyWith(
          placeName: _placeNameController.text.trim(),
          country: _countryController.text.trim(),
          notes: _notesController.text.trim(),
          isVisited: _isVisited,
        );
        await provider.updateDestination(updated);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Destination updated!')),
          );
          Navigator.pop(context);
        }
      } else {
        // Add new destination
        await provider.addDestination(
          placeName: _placeNameController.text.trim(),
          country: _countryController.text.trim(),
          notes: _notesController.text.trim(),
          isVisited: _isVisited,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Destination added to your bucket list!')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
