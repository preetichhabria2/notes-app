import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart'; // For shimmer effect
import 'package:lottie/lottie.dart'; // For Lottie animations
import '../services/firestore_service.dart';
import 'notes_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth to get current user

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  bool _isLoading = false; // To track loading state

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        backgroundColor: Colors.teal, // Unique Teal Color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create a new note',
              style: GoogleFonts.lato().merge(
                const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                  fontFamilyFallback: ['NotoSans', 'Roboto'],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildShimmerEffect(),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: 6,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon:
                  _isLoading
                      ? SizedBox(
                        height: 42,
                        width: 42,
                        child: Lottie.asset(
                          'assets/animations/Loading_Animation.json', // Larger and corrected
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      )
                      : const Icon(Icons.save),
              label:
                  _isLoading
                      ? const SizedBox.shrink()
                      : const Text('Save Note', style: TextStyle(fontSize: 16)),
              onPressed:
                  _isLoading
                      ? null
                      : () async {
                        final title = titleController.text.trim();
                        final content = contentController.text.trim();

                        if (title.isEmpty || content.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please fill in both Title and Content.',
                                style: GoogleFonts.notoSans().merge(
                                  const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamilyFallback: ['Roboto'],
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        // Get current user ID
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          // Handle the case if the user is not logged in
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Please log in to add a note.',
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        await FirestoreService().addNote(
                          title,
                          content,
                          user.uid,
                        );

                        setState(() {
                          _isLoading = false;
                        });

                        showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text("✅ Note Added!"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Your note has been saved successfully!",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 12),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const NotesListScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View Notes',
                                        style: GoogleFonts.pacifico().merge(
                                          const TextStyle(
                                            fontSize: 18,
                                            color: Colors.teal,
                                            fontWeight: FontWeight.bold,
                                            fontFamilyFallback: ['NotoSans'],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        );
                      },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.notes, color: Colors.teal),
              label: const Text(
                'View All Notes',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.teal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const NotesListScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(height: 48, width: double.infinity, color: Colors.white),
    );
  }
}
