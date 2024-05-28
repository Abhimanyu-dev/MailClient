import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mail_client/animation/animation.dart';
import 'package:mail_client/components/mail_item.dart';
import 'package:mail_client/components/side_menu.dart';
import 'package:mail_client/ui/send_page.dart';
import 'package:mail_client/ui/singin_page.dart';

class MailList extends StatefulWidget{
  const MailList({super.key, required this.imapClient, required this.smtpClient, required this.user});

  final ImapClient imapClient;
  final SmtpClient smtpClient;
  final String user;




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
      drawer: const SideMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(RouteAnimation.createRoute(SendPage(smtpClient: widget.smtpClient, user: widget.user)));
        },
        child: const Icon(Icons.edit),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        
        child: Column(
          children: [
            AnimatedContainer(  
              padding: const EdgeInsets.only(top: 12),
              height: _showAppbar ? MediaQuery.of(context).size.height/100*10 : 0,
              duration: const Duration(milliseconds: 200),
              child: AppBar(    
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
              leading: IconButton(
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu)
                ),
              
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
                child: Mails(controller: _scrollViewController, imapClient: widget.imapClient,)
                ),
            )
          ],
        ),
      )
    );
  }
}

class Mails extends StatefulWidget {
  Mails({
    super.key, required this.controller, required this.imapClient
    });

  final ScrollController controller;
  final ImapClient imapClient;

  @override
  State<Mails> createState() => _MailsState();
}

class _MailsState extends State<Mails> {
  List<MimeMessage> mailList = [];

  @override
  void initState() {  
    super.initState();
    getMails();
  }

  void getMails() async {
    await widget.imapClient.selectInbox();
    final result = await widget.imapClient.fetchRecentMessages(); 
    for(final message in result.messages){
      setState(() {
        mailList.add(message);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return (
        ListView.builder(
          controller: widget.controller,
          itemCount: mailList.length,
          itemBuilder: (context, index){
            final sender = mailList[index].fromEmail as String;
            final subject = mailList[index].decodeSubject() as String;
            return MailTile(sender: Text(sender), body: Text(subject));
          },
        )
    );
  }
}