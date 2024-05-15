import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mail_client/components/mail_item.dart';

class MailList extends StatefulWidget{
  const MailList({super.key});

  @override
  State<StatefulWidget> createState() => _MailListState();
  
}

class _MailListState extends State<MailList>{
  
  final ScrollController _scrollViewController = ScrollController();
  bool _showAppbar = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          
          setState(() {
            isScrollingDown = true;
            _showAppbar = false;
          });
        }
      }

      if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
        
          setState(() {
            isScrollingDown = false;
            _showAppbar = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            AnimatedContainer(  
              padding: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.jpg'),
                  fit: BoxFit.cover,
                )
              ),
              height: _showAppbar ? MediaQuery.of(context).size.height/100*10 : 0,
              duration: const Duration(milliseconds: 100),
              child: AppBar( 
                
                backgroundColor: Colors.black,   
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
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bg.jpg"),
                    fit: BoxFit.cover
                  )
                ),
                child: Mails(controller: _scrollViewController)
                ),
            )
          ],
        ),
      )
    );
  }
}

class Mails extends StatelessWidget {
  const Mails({
    super.key, required this.controller
  });

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return (
        ListView.builder(
          controller: controller,
          itemBuilder: (BuildContext context, int index){
            return const Mail(sender: Text("Sender"), body: Text("Body"));
          }
          )
    );
  }
}