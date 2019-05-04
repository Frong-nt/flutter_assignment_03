import 'package:flutter/material.dart';
import '../Model/todo.dart';
import '../DB/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskState();
  }

}
class TaskState extends State<TaskScreen>{
  static int currentIndexTab = 0;
  static List<String> documentid = new List<String>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            IconButton(
              icon: IconTheme(
                data: new IconThemeData(color: Colors.white),
                child: TaskState.currentIndexTab==0? new Icon(Icons.add): new Icon(Icons.delete),
              ),
              onPressed: appBarOnpress,
            )
          ],
        ),
        body:StreamBuilder(
          stream:Firestore.instance.collection('todo').snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              if (snapshot.data.documents.length == 0) {
                return Center(
                  child: Text("No data found.."),
                );
              }
                      //reset documentid list when setstate
              TaskState.documentid = new List<String>();
              
              List<Todo> notdone = new List<Todo>();
              List<Todo> done = new List<Todo>();
              for(int i=0;i<snapshot.data.documents.length;i++){
                  var item = snapshot.data.documents[i];
                  if(item['done']==0){
                    notdone.add(new Todo(id: item.documentID,title: item['title'], done: item['done']));
                  }else{
                    documentid.add(item.documentID);
                    done.add(new Todo(id:item.documentID, title: item['title'], done: item['done']));
                  }
              }
              if ((notdone.length == 0 && currentIndexTab==0) || (done.length==0 && currentIndexTab==1) ) {
                return Center(
                  child: Text("No data found.."),
                );
              }

              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemCount: currentIndexTab ==0? notdone.length: done.length,
                itemBuilder: (BuildContext context, int index){       
                  Todo item = currentIndexTab ==0? notdone[index]: done[index];               
                      return ListTile(
                        title: Text(item.title),
                        trailing: Checkbox(
                        onChanged: (bool value){
                          setState(() { 
                            Firestore.instance.collection('todo').document(item.id).updateData({'done': value? 1:0});

                          });
                        },
                        value: item.done ==1? true:false,
                      ),
                    );
                },
              );
            }else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: TaskState.currentIndexTab,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: new Text('Task')
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.done_all),
              title: new Text('Completed')
              )
          ],
        )
        );
  }

  void onTabTapped(int index) {
   setState(() {
     TaskState.currentIndexTab = index;
   });
 }

 void appBarOnpress(){
  if(TaskState.currentIndexTab==0){   
    Navigator.pushNamed(context, "/new_subject");
  }else if(TaskState.currentIndexTab==1){
        setState(() {
        for(int i = 0;i<TaskState.documentid.length;i++){
          Firestore.instance.collection('todo').document(TaskState.documentid[i]).delete();
        }
        //reset documentid list
        TaskState.documentid = new List<String>();

      });
        
   }
 }
}

