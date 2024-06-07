import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mail_client/animation/animation.dart';
import 'package:mail_client/backend/mail_validation.dart';
import 'package:mail_client/components/mail_item.dart';
import 'package:mail_client/components/side_menu.dart';
import 'package:mail_client/models/email_model.dart';
import 'package:mail_client/models/user_model.dart';
import 'package:mail_client/ui/send_page.dart';

class MailList extends StatefulWidget{
  MailList({super.key, required this.imapClient});

  Box<User> localDB = Hive.box<User>("local_db");
  late User user;
  ImapClient imapClient;


  @override
  State<StatefulWidget> createState() => _MailListState();
  
}

class _MailListState extends State<MailList>{
  
  final ScrollController _scrollViewController = ScrollController();
  bool _showAppbar = true;
  bool isScrollingDown = false;

  Future<void> init() async {
    widget.user = widget.localDB.getAt(0)!;
    await validateImap(widget.imapClient, widget.user.username, widget.user.password);
    await widget.imapClient.selectInbox();
  }

  @override
  void initState() {
    widget.user = widget.localDB.getAt(0)!;
    if(!widget.imapClient.isLoggedIn){
      init();
    }
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
          Navigator.of(context).push(RouteAnimation.createRoute(SendPage()));
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
                child: Mails(controller: _scrollViewController, imapClient: widget.imapClient, user: widget.user, localDB: widget.localDB)
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
    super.key, required this.controller, required this.imapClient, required this.user, required this.localDB
    });

  final ScrollController controller;
  final ImapClient imapClient;
  final User user;
  final Box<User> localDB;

  @override
  State<Mails> createState() => _MailsState();
}

class _MailsState extends State<Mails> {
  List<MimeMessage> mailList = [];
  int messages = 0;

  @override
  void initState() {  
    super.initState();
    widget.controller.addListener(_loadMore);
    _handleRefresh();
  }

  Future<void> _loadMore() async {
    if(widget.controller.position.pixels >= (widget.controller.position.maxScrollExtent - 10)){
      final upperSequenceId = widget.user.mails.last.uid!;
      var lowerSequenceId = upperSequenceId - 30;
      if(lowerSequenceId < 1){
        lowerSequenceId = 1;
      }
      var result = await widget.imapClient.fetchMessages(MessageSequence.fromRange(lowerSequenceId, upperSequenceId), "(FLAGS BODY[])");
      for(var message in result.messages){
        setState(() {
          var newMail = Email("${message.fromEmail}", "${message.decodeSubject()}", message.sequenceId);
          if(!widget.user.mails.contains(newMail)){
            widget.user.mails.add(newMail);
          }
        });
      }
      widget.localDB.putAt(0, widget.user);

    }
  }

  Future<void> _handleRefresh() async {
    if(widget.imapClient.isLoggedIn) {
      final box  = await widget.imapClient.selectInbox();
      final lastMessageId = box.messagesExists;
      if(lastMessageId >= widget.user.mails.first.uid!){
        final result = await widget.imapClient.fetchRecentMessages();
        for (final message in result.messages) {
          setState(() {
            var newMail = Email(
                "${message.fromEmail}", "${message.decodeSubject()}",
                message.sequenceId);
            if (!widget.user.mails.contains(newMail)) {
              widget.user.mails.add(newMail);
            }
          });
        }
        widget.localDB.putAt(0, widget.user);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: (
          ListView.builder(
            controller: widget.controller,
            itemCount: widget.user.mails.length,
            itemBuilder: (context, index){
              return MailTile(mail: widget.user.mails[widget.user.mails.length - index - 1], imapClient: widget.imapClient,);
            },
          )
      ),
    );
  }
}