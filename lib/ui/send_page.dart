import 'dart:convert';
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:mail_client/ui/mail.dart';

class SendPage extends StatefulWidget {

  const SendPage({super.key, required this.smtpClient, required this.user});

  final SmtpClient smtpClient;
  final String user;

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {

  final TextEditingController email = TextEditingController();
  final TextEditingController subject = TextEditingController();
  final TextEditingController body = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:  FloatingActionButton(
              onPressed: () async {
                final builder = MessageBuilder.prepareMultipartAlternativeMessage(
                  plainText: body.text,
                  htmlText: "<p>${body.text}</p>",
                  transferEncoding: TransferEncoding.eightBit
                )..from = [MailAddress(widget.user, "${widget.user}@iitk.ac.in")]
                ..to = [MailAddress(email.text, email.text)]
                ..subject = subject.text;
                final mimeMessage = builder.buildMimeMessage();
                final sendResponse = await widget.smtpClient.sendMessage(mimeMessage);
              },
              child: const Icon(Icons.send),
            ),
      appBar: AppBar(
        title: const Text('Draft'),
        // actions: isSendEmail
        //     ? []
        //     : [
        //         IconButton(
        //             onPressed: () {
        //               int currentEmailIndex = emails.indexWhere(
        //                   (element) => element.id == widget.email!.id);
        //               if (currentEmailIndex != 0) {
        //                 Navigator.pushReplacement(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => EmailSendScreen(
        //                               email: emails[currentEmailIndex - 1],
        //                             )));
        //               }
        //             },
        //             icon: const Icon(Icons.chevron_left)),
        //         IconButton(
        //             onPressed: () {
        //               int currentEmailIndex = emails.indexWhere(
        //                   (element) => element.id == widget.email!.id);
        //               if (currentEmailIndex != emails.length - 1) {
        //                 Navigator.pushReplacement(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => EmailSendScreen(
        //                               email: emails[currentEmailIndex + 1],
        //                             )));
        //               }
        //             },
        //             icon: const Icon(Icons.chevron_right))
        //       ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {},
              title: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: email,
                            decoration: const InputDecoration(
                              hintText: "To: email address",
                              border: InputBorder.none,
                            ),
                          ),
                        ),  
                      ],
                    ),
            ),
            
              TextField(
                controller: subject,
                decoration: const InputDecoration(
                  hintText: "Subject",
                  border: InputBorder.none,
                ),
              ),
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: TextField(
                    controller: body,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Description",
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
              ),
            ]
          
        ),
      ),
    );
  }
}