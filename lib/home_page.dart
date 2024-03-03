import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gemini_app/gemini_api.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final promptController = TextEditingController();
  String prompt = '';
  String? res = '';

  void outputPrompt() {
    prompt = promptController.text;
    setState(() {
      callGemini();
    });
  }

  Future<void> callGemini() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: geminiAPIKey);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    res = response.text;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gemini API',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ).copyWith(topLeft: const Radius.circular(0)),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 12)
                              .copyWith(top: 20),
                      height: height * 0.75,
                      width: width * 0.9,
                      child: prompt == ''
                          ? const Text(
                              'Hi, This is Gemini! How can I help you?',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              res!,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
              ),
              Gap(width * 0.075),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50, // Set the desired height
                    width: width * 0.81, // Set the desired width
                    child: TextFormField(
                      controller: promptController,
                      decoration: const InputDecoration(
                        labelText: 'Type your prompt here.....',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: outputPrompt,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
