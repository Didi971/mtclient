//+------------------------------------------------------------------+
//|                                              GestionnaireMsg.mqh |
//|                                    Diego MOSES && Jeremy Thomias |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Diego MOSES"
#property link      "https://www.mql5.com"
#property strict

#include <PlusBotRecon.mqh>
#include <Telegram.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
class GestionnaireMsg: public CCustomBot
  {
public:
string text;
string post;
long signal, channelid, channelId, identifiant;
   void              ProcessMessages(void)
     {
      string msg=NL;
      const string strOrderTrade="/ordertrade";
      const string strHistoryTicket="/historyticket";
      int pos=0, ticket=0;
      for(int i=0; i<m_chats.Total(); i++)
        {
         CCustomChat *chat=m_chats.GetNodeAtIndex(i);
         //Print(chat.m_new_one.done);
         //Print(chat.m_new_one.done);
         if(!chat.m_new_one.done)
         {
            chat.m_new_one.done = true;
            signal = chat.f_id;
            channelid = chat.c_id;
            channelId = chat.channel;
            text = chat.m_new_one.message_text;
            post = chat.m_new_one.message_post;
            //channel
            Print(signal);
            Print(channelid);
            Print(channelId);
            Print(chat.m_new_one.message_text);
            //post
            Print(chat.m_new_one.message_text);
            Print(chat.m_new_one.message_text);
            Print(chat.m_new_one.message_text);
            Print(chat.m_new_one.message_post);
            
            identifiant = chat.u_id;
            //Print(1);
         }
         
        }
     }
  };
//+------------------------------------------------------------------+
