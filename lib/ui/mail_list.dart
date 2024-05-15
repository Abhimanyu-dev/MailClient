import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mail_client/components/mail_item.dart';

class MailList extends StatefulWidget{
  const MailList({super.key});

  @override
  State<StatefulWidget> createState() => _MailListState();
  
}

class _MailListState extends State<MailList>{
  
  var mails = <Text>{};
  
  @override
  void initState(){
    super.initState();
    mails.add(const Text("Hello"));
    mails.add(const Text("Hello"));
    mails.add(const Text("Hello"));
    mails.add(const Text("Hello"));
    mails.add(const Text("Hello"));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              leading: const Icon(Icons.menu),
              
            );
          }, suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                    
            return List<ListTile>.generate(5, (int index) {
              final String item = 'item $index';
              return ListTile(
                title: Text(item),
                onTap: () {
                  setState(() {
                    controller.closeView(item);
                  });
                },
              );
            });
          }),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index){
          return const Mail(sender: Text("Sender"), body: Text("Body"));
        }
        )
    );
  }
}