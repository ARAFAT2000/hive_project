

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_project/boxes/boxes_dart.dart';
import 'package:hive_project/model/notes_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

final _formKey= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        title: Text('Hive Database'),
      ),
      body: ValueListenableBuilder<Box<NoteModel>>(
          valueListenable:Boxes.getData().listenable(),
          builder: (context,box,_){
            var data= box.values.toList().cast<NoteModel>();
            return ListView.builder(
              shrinkWrap: true,
              itemCount: box.length,
                itemBuilder: (context,index){
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data[index].title.toString()),
                            Spacer(),
                            InkWell(
                               onTap: (){
                                _editDialoge(data[index],
                                   data[index].title.toString(),
                                    data[index].des.toString());
                               },
                                child: Icon(Icons.edit)),
                            SizedBox(width: 5,),
                            InkWell(
                                onTap: (){
                                  delete(data[index]);
                                },
                                child: Icon(Icons.delete,color: Colors.red,)),
                          ],
                        ),
                          Text(data[index].des.toString())
                      ],
                    ),
                  ),
                );
                });
          }),




      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          _showDialoge();
        },
        child: Icon(Icons.add),),
    );
  }
      void delete (NoteModel noteModel)async{
        await  noteModel.delete();
      }
  Future<void> _showDialoge()async{
    return showDialog(context: context,
        builder:(BuildContext context){
      return AlertDialog(

        title: Text('Add Your data'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Enter title';
                    }return null;
                  },
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "title",
                    border: OutlineInputBorder(

                    )
                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Enter title';
                    }return null;
                  },
                  controller: descController,
                  decoration: InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder(

                      )
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
   Navigator.pop(context);
          },
              child: Text('Clear')),

          TextButton(onPressed: (){
            final form = _formKey.currentState;
            if(form != null && form.validate()){
              final data= NoteModel(title: titleController.text,
                  des: descController.text);

              final box= Boxes.getData();
              box.add(data);

              titleController.clear();
              descController.clear();
              Navigator.pop(context);
            }

          }, child: Text('Add')),

        ],
      );
        });
  }
  Future<void> _editDialoge(NoteModel noteModel,String title,String desc)async{
    titleController.text=title;
    descController.text=desc;
    return showDialog(context: context,
        builder:(BuildContext context){
          return AlertDialog(

            title: Text('Update Your data'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Enter title';
                        }return null;
                      },
                      controller: titleController,
                      decoration: InputDecoration(
                          hintText: "title",
                          border: OutlineInputBorder(

                          )
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Enter Description';
                        }return null;
                      },
                      controller: descController,
                      decoration: InputDecoration(
                          hintText: "Description",
                          border: OutlineInputBorder(

                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              },
                  child: Text('Cancel')),

              TextButton(onPressed: ()async{
                final form = _formKey.currentState;
                if(form!=null && form.validate()){
                  noteModel.title= titleController.text.toString();
                  noteModel.des= descController.text.toString();
                  await noteModel.save();

                  descController.clear();
                  titleController.clear();
                }



              }, child: Text('Save')),

            ],
          );
        });
  }
}
