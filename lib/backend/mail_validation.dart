import 'dart:async';
import "dart:io";
import 'package:enough_mail/enough_mail.dart';

Future<bool> validateImap(ImapClient client, String username, String password,{ String imapServerHost = "qasid.iitk.ac.in", int imapServerPort =  993, bool isImapServerSecure = true}) async {
  
  try{
    print("Connecting");
    await client.connectToServer(imapServerHost, imapServerPort, isSecure: isImapServerSecure);
    await client.login(username, password);
    return true;
  } on ImapException catch (e){
    print('Imap failed with $e');
    return false;
  } on TimeoutException catch(e){
    print("Timeout Exception");
    return false;
  }
}

Future<bool> validateSmtp(SmtpClient client, String username, String password,{ String smtpServerHost = "mmtp.iitk.ac.in", int smtpServerPort =  465, bool isSmtpServerSecure = true}) async {
  
  try{
    print("Connecting");
    await client.connectToServer(smtpServerHost, smtpServerPort, isSecure: isSmtpServerSecure);
    await client.ehlo();
    await client.authenticate(username, password, AuthMechanism.plain);
    return true;
  } on SmtpException catch (e){
    print('Smtp failed with $e');
    return false;
  }
}
