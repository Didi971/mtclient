//+------------------------------------------------------------------+
//|                                                        lahan.mqh |
//|                                                      Diego MOSES |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Diego MOSES"
#property link      "https://www.mql5.com"
#property strict
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
#include <PlusBotRecon.mqh>
#include <Telegram.mqh>
#include <TradeAction.mqh>

//|-----------------------------------------------------------------------------------------|
//|                               M A I N   P R O C E D U R E                               |
//|-----------------------------------------------------------------------------------------|
class CPlusBotRecon: public CCustomBot
  {
public:
   void              ProcessMessages(void)
     {
      //Trade trade;
      string msg=NL;
      const string strOrderTrade="/ordertrade";
      const string strHistoryTicket="/historyticket";
      int pos=0, ticket=0;
      for(int i=0; i<m_chats.Total(); i++)
        {
         CCustomChat *chat=m_chats.GetNodeAtIndex(i);

         if(!chat.m_new_one.done)
           {
            chat.m_new_one.done=true;

            string text=chat.m_new_one.message_text;

            if(text=="/ordertotal")
              {
               SendMessage(chat.m_id, BotOrdersTotal());
              }

            if(StringFind(text, strOrderTrade)>=0)
              {
               pos = StringToInteger(StringSubstr(text, StringLen(strOrderTrade)+1));
               SendMessage(chat.m_id, BotOrdersTrade(pos));
              }

            if(text=="/historytotal")
              {
               SendMessage(chat.m_id, BotOrdersHistoryTotal());
              }

            if(StringFind(text, strHistoryTicket)>=0)
              {
               ticket = StringToInteger(StringSubstr(text, StringLen(strHistoryTicket)+1));
               SendMessage(chat.m_id, BotHistoryTicket(ticket));
              }

            if(text=="/account")
              {
               SendMessage(chat.m_id, BotAccount());

              }
            if(text=="/buy" || text=="/Buy")
              {

              }
            if(text=="/sell" || text=="/Sell")
              {
               SendMessage(chat.m_id, BotAccount());
              }
            if(text=="/tp1" || text=="/TP1")
              {
               SendMessage(chat.m_id, BotAccount());
              }
            if(text=="/tp2" || text=="/TP2")
              {
               SendMessage(chat.m_id, BotAccount());
              }
            if(text=="/tp3" || text=="/TP3")
              {
               SendMessage(chat.m_id, BotAccount());
              }
            if(text=="/LOT" || text=="/lot")
              {
               SendMessage(chat.m_id, BotAccount());
              }
              if(text=="/showvariable" || text=="/SHOWVARIABLE")
              {
               SendMessage(chat.m_id, BotAccount());
              }

            msg = StringConcatenate(msg,"My commands list:",NL);
            msg = StringConcatenate(msg,"/buy",NL);
            msg = StringConcatenate(msg,"/sell",NL);
            msg = StringConcatenate(msg,"/STOPLOSS",NL);
            msg = StringConcatenate(msg,"/LOT",NL);
            msg = StringConcatenate(msg,"/TP1",NL);
            msg = StringConcatenate(msg,"/TP2",NL);
            msg = StringConcatenate(msg,"/TP3",NL);
            msg = StringConcatenate(msg,"/showvariable",NL);
            msg = StringConcatenate(msg,"/help-get help");
            if(text=="/help")
              {
               SendMessage(chat.m_id, msg);
              }
           }
        }
     }
  };
//+------------------------------------------------------------------+
