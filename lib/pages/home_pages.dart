
import 'package:readmore/readmore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_project/boxes/boxes_dart.dart';
import 'package:hive_project/model/notes_model.dart';
import '../style/style.dart';

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
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        title: Text('Note 2.0',style: TextStyle(
          fontStyle: FontStyle.italic
        ),),
      ),
      body: SizedBox(
        child: ValueListenableBuilder<Box<NoteModel>>(
            valueListenable:Boxes.getData().listenable(),
            builder: (context,box,_){
              var data= box.values.toList().cast<NoteModel>();
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: box.length,
                  itemBuilder: (context,index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Slidable(
                       dragStartBehavior: DragStartBehavior.start,
                        startActionPane: ActionPane(

                          dragDismissible: false,
                            motion:  const ScrollMotion(),
                            children: [
                              SlidableAction(
                                 spacing: 5,
                                backgroundColor:Colors.lightGreen,
                                foregroundColor: Colors.white,
                                icon: Icons.update,
                                label: 'Update',
                                onPressed: (BuildContext context) {
                                  _editDialoge(data[index],
                                      data[index].title.toString(),
                                      data[index].des.toString());
                                },
                              ),
                             SizedBox(width: 5,),
                              SlidableAction(
                                spacing: 5,
                                backgroundColor:Colors.lightGreen,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                onPressed: (BuildContext context) {
                                  delete(data[index]);
                                },
                              ),
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 50,
                                width: 15,),
                                CircleAvatar(
                                  backgroundColor: Colors.lightGreen,
                                  child: Text("${(index+1).toString()}",style: TextStyle(color: Colors.white),),
                                ),
                                SizedBox(width: 5,),
                                Expanded(
                                  child: Text(
                                    data[index].title.toString(),
                                    style: AppTextStyle(),
                                    ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: ReadMoreText(
                                  data[index].des.toString(),
                                trimLines: 4,
                                style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.w600),
                                trimLength: 240,
                                trimMode: TrimMode.Line,
                                colorClickableText: Colors.deepPurple,

                                trimCollapsedText: '...Expand',
                                trimExpandedText: 'Collapse ',

                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                  });
            }),
      ),




      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
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
        barrierDismissible: false,
        builder:(BuildContext context){
      return AlertDialog(

        title: Text('Add Your data',style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.lightGreen,
            fontWeight: FontWeight.bold
        ),),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (value){
                    if(value == null || value.isEmpty ){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.lightGreen,
                          content: Text('Please Complete the Title'),
                        ),
                      );
                      return 'Enter title';
                    }
                    return null;
                  },
                  controller: titleController,
                  decoration: TextFieldInputDecoration('Title')
                ),
                SizedBox(height: 10,),
                TextFormField(
                  maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.lightGreen,
                          content: Text('Please Complete the Description'),
                        ),
                      );
                      return 'Enter Description';
                    }return null;
                  },
                  controller: descController,
                    decoration: TextFieldInputDecoration('Description')
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
              Navigator.pop(context);
          },
              child: Container(


                  child: Text('Clear',style: TextStyle(
                    color: Colors.lightGreen,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),))),

          TextButton(onPressed: (){


            final form = _formKey.currentState;
            if(form != null && form.validate()){
              final data= NoteModel(title: titleController.text,
                  des: descController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.lightGreen,
                  content: Text('Succesfully Add Your Todo ...'),
                ),
              );

              final box= Boxes.getData();
              box.add(data);

              titleController.clear();
              descController.clear();
              Navigator.pop(context);
            }

          }, child: Text('ADD',style: TextStyle(
          color: Colors.lightGreen,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic
          ),)),

        ],
      );
        });
  }
  Future<void> _editDialoge(NoteModel noteModel,String title,String desc)async{
    titleController.text=title;
    descController.text=desc;
    return showDialog(context: context,
        barrierDismissible: false,
        builder:(BuildContext context){
          return AlertDialog(

            title: Text('Update Your data',style: TextStyle(
                fontStyle: FontStyle.italic,
              color: Colors.lightGreen,
              fontWeight: FontWeight.bold
            ),),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.lightGreen,
                              content: Text('Update Your Title '),
                            ),
                          );
                          return 'Enter title';
                        }return null;
                      },
                      controller: titleController,
                      decoration: InputDecoration(
                          hintText: "Title",
                          border: OutlineInputBorder(

                          )
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.lightGreen,
                              content: Text('Update Your Description '),
                            ),
                          );
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
                  child: Text('Cancel',style: TextStyle(
                      color: Colors.lightGreen,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),)),

              TextButton(onPressed: ()async{
                final form = _formKey.currentState;
                if(form!=null && form.validate()){
                  noteModel.title= titleController.text.toString();
                  noteModel.des= descController.text.toString();
                  await noteModel.save();
                  Navigator.pop(context);
                  descController.clear();
                  titleController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.lightGreen,
                      content: Text('Succesfully Update ...'),
                    ),
                  );
                }


              }, child: Text('Save',style: TextStyle(
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
              ),)),

            ],
          );
        });
  }
  @override
  void dispose() {
    titleController.clear();
    descController.clear();
    // TODO: implement dispose
    super.dispose();
  }
}
