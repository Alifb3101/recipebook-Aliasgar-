import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipes_api/database/api/api.dart';
import 'package:recipes_api/screen/widget/Text_widget.dart';

class RecipeManagerPage extends StatefulWidget {
  @override
  State<RecipeManagerPage> createState() => _RecipeManagerPageState();
}

class _RecipeManagerPageState extends State<RecipeManagerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Map<String, dynamic>? updateResponse;
  bool add = false;
  bool update = false;

 showMessage(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message , style:TextStyle(color: CupertinoColors.black, fontWeight: FontWeight.w600),) , backgroundColor: Color(0xFF83A4D4),));
  }

 addRecipe() async {
    final response = await API().addrecipes(nameController.text);
    if (response != null) {
      setState(() {
        updateResponse = response;
        add = true;
        update = false;
      });
      showMessage('Recipe Added');
    } else {
      showMessage('Add Failed');
    }
  }

updateRecipe() async {
    final response = await API().updateRecipe(idController.text, nameController.text);
    if (response != null) {
      setState(() {
        updateResponse = response;
        update = true;
        add = false;
      });
      showMessage('Recipe Updated');
    } else {
      showMessage('Update Failed');
    }
  }

   deleteRecipe() async {
    final response = await API().deleteRecipeById(idController.text);
    if (response != null) {
      setState(() {
        updateResponse = null;
        add = false;
        update = false;
      });
      showMessage('Recipe Deleted');
    } else {
      showMessage('Delete Failed');
    }
  }

  void toggleadd() {
    setState(() {
      if (add || update) {
        add = !add;
        update = !update;
      }
    });
  }

  Widget buildResponseBox() {
    if (updateResponse == null) return SizedBox.shrink();
    if (add) {
      return Container(
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Response', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('ID: ${updateResponse!['id'] ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            Text('Name: ${updateResponse!['name'] ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
          ],
        ),
      );
    } else {
      return buildRecipePreviewBox();
    }
  }

  Widget buildRecipePreviewBox() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Image.network(
              '${updateResponse!['image']}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: 100),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(updateResponse!['name'] ?? 'Unknown',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 4),
                Text('Cuisine: ${updateResponse!['cuisine']}',
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text('${updateResponse!['tags'][0]}')),
                    Chip(label: Text('${updateResponse!['tags'][1]}')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back , color: Colors.white60,)),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                   TextWidget(Text: "Recipe Manager", fontsize: 30, fw: FontWeight.bold, fontcolour: CupertinoColors.systemIndigo,),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: idController,
                      decoration: InputDecoration(
                        labelText: 'Recipe ID',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Recipe Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
                    ),
                    SizedBox(height: 16),
                    // TextFormField(
                    //   controller: descriptionController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Description (optional)',
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool wide = constraints.maxWidth > 400;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  addRecipe();
                                }
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                              child: Text('Add'),
                            ),
                            SizedBox(width: wide ? 12 : 0, height: wide ? 0 : 12),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  updateRecipe();
                                }
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                              child: Text('Update'),
                            ),
                            SizedBox(width: wide ? 12 : 0, height: wide ? 0 : 12),
                            ElevatedButton(
                              onPressed: () {
                                if (idController.text.isNotEmpty) {
                                  deleteRecipe();
                                } else {
                                  showMessage('Enter Recipe ID to delete');
                                }
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 10,),
                    buildResponseBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}