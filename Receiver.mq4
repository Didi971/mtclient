//+------------------------------------------------------------------+
//|                                                     Receiver.mq4 |
//|                                                      MOSES Diego |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "MOSES Diego"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//----------------Include---------------------------------------------
#include <plusinit.mqh>
#include <plusbig.mqh>
#include <Telegram.mqh>
#include <GestionnaireMsg.mqh>

//----------------Class-----------------------------------------------

GestionnaireMsg bot;

//----------------Variable--------------------------------------------

bool marche = true;
long channel    = -1001846930803;
long Diego = 1353114129;
long Jeremy = 813670458;
long id = 0;
input string TgrToken = "5821672053:AAEQvZqmKUTC7bBAkjE_gbWh16MMWvPj_4s"; //Token
input string Terminologie = ""; //Terminologie
string message;
string messageP;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetMillisecondTimer(1);
   Initialisation();
   InitialisationCompte();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   bot.GetUpdates();
   WaitOrder();


  }
//+------------------------------------------------------------------+
void Initialisation()
  {
   bot.Token(TgrToken);
   int Result = bot.GetMe();
   if(Result != 0)
     {
      BigComment("Erreur :");
      // envoi de message d'erreur sur telegram
     }
   else
     {
      bot.SendMessage(Diego, "Bot initialisé");
     }
   BigComment("Bot name: "+bot.Name());
  }
//+------------------------------------------------------------------+
void WaitOrder()
  {

   int type = 0,
       nm = 0,
       digits = 0;
   string sy;
   double tp = 0,
          op = 0,
          sl = 0,
          lot = 0,
          price = 0,
          capitalDeRef = 0;


   if(message != sendText|| messageP != messagePersonnel)
     {
      //------------------------- Cloture ----------------------------------

      message = sendText;
      messageP = messagePersonnel;
      //
      if(idClient == Diego || idClient == Jeremy || idClient == id)
        {
         if(StringFind(messagePersonnel, "/start",0) >= 0 && id == 0)
           {
            id = idClient;
            Print("id = " + IntegerToString(id));
            messageP = messagePersonnel;
            bot.SendMessage(id,"Bonjour, vous etes désormais propritaire du bot");
            bot.SendMessage(id,"La société de  'Youridji'  ne peut être tenue pour responsable en cas de pertes ou de profits non déclarés fiscalement ");
            bot.SendMessage(id,"Vous avez plusieurs intéraction possible");
            string msg = "/Trade : vous fait une liste des positions prises" + "\n"
                         + "/Profitencour : vous renvoie les profit encour de toutes les positions" + "\n"
                         + "/ProfitTotalHistorique : Vous renvoie le profit généré depuis vous souscription" + "\n"
                         + "/ProfitTotalMensuel";
            bot.SendMessage(id,msg);
           }


        }
      if(marche)
        {
         if(StringFind(message, "Close",0) >= 0)
           {
            Print("Cloture trade------------------------------");
            if(StringFind(message, "Partielle",0) >= 0)
              {
               Print("Cloture Partielle------------------------------");
               if(StringFind(message, "Numero magic",0) >= 0)
                 {
                  int pos1 = StringFind(message, "Numero magic",0);
                  int pos2 = StringFind(message, "= ", pos1);
                  int pos3 = StringFind(message,"\n",pos2);
                  nm = (int)StringToInteger(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
                  Print("Numero Magic = " + IntegerToString(nm));

                 }
               if(StringFind(message, "Capital",0) >= 0)
                 {
                  int pos1 = StringFind(message, "Capital",0);
                  int pos2 = StringFind(message, "= ", pos1);
                  int pos3 = StringFind(message,"\n",pos2);
                  capitalDeRef = StringToDouble(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
                  Print("Capital = " + DoubleToString(capitalDeRef));
                 }
               if(StringFind(message, "Lot",0) >= 0)
                 {
                  int pos1 = StringFind(message, "Lot",0);
                  int pos2 = StringFind(message, "= ", pos1);
                  int pos3 = StringFind(message,"\n",pos2);
                  lot = (double)StringToDouble(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
                  lot = lot / capitalDeRef * (AccountBalance() + AccountCredit());
                  lot = NormalizeDouble(lot,2);
                  Print("Lot = " + DoubleToString(lot,2));
                 }
               CloturePartielle(nm,lot);
              }
            if(StringFind(message, "Total",0) >= 0)
              {

               Print("Cloture Total ------------------------------");
               if(StringFind(message, "Numero magic",0) >= 0)
                 {
                  int pos1 = StringFind(message, "Numero magic",0);
                  int pos2 = StringFind(message, "= ", pos1);
                  int pos3 = StringFind(message,"\n",pos2);
                  nm = (int)StringToInteger(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
                  Print("Numero Magic = " + IntegerToString(nm));

                 }
               if(StringFind(message, "Capital",0) >= 0)
                 {
                  int pos1 = StringFind(message, "Capital",0);
                  int pos2 = StringFind(message, "= ", pos1);
                  int pos3 = StringFind(message,"\n",pos2);
                  capitalDeRef = StringToDouble(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
                  Print("Capital = " + DoubleToString(capitalDeRef));
                 }
               if(StringFind(message, "Lot",0) >= 0)
                 {
                  int pos1 = StringFind(message, "Lot",0);
                  int pos2 = StringFind(message, "= ", pos1);
                  int pos3 = StringFind(message,"\n",pos2);
                  lot = (double)StringToDouble(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
                  lot = lot / capitalDeRef * (AccountBalance() + AccountCredit());

                  Print("Lot = " + DoubleToString(lot,2));

                 }
               ClotureTrade(nm,price);
              }
           }
         //------------------------- Ouverture --------------------------------
         if(StringFind(message, "Trade",0) >= 0)
           {
            if(StringFind(message, "Vente",0) >= 0)
              {
               type = 1;
               Print("Vente");
              }
            if(StringFind(message, "Achat",0) >= 0)
              {
               type = 0;
               Print("Achat");
              }

            if(StringFind(message, "Symbol",0) >= 0)
              {
               int pos1 = StringFind(message, "Symbol",0);
               int pos2 = StringFind(message, "= ", pos1);
               int pos3 = StringFind(message,"\n",pos2);
               sy = StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2));
               sy = SetSymbol(sy);
               Print("Symbol = " + sy);

              }
            if(StringFind(message, "Price",0) >= 0)
              {
               int pos1 = StringFind(message, "Price",0);
               int pos2 = StringFind(message, "= ", pos1);
               int pos3 = StringFind(message,"\n",pos2);
               op = StringToDouble(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
               Print("OpenPrice = " + DoubleToString(op));
              }
            if(StringFind(message, "Capital",0) >= 0)
              {
               int pos1 = StringFind(message, "Capital",0);
               int pos2 = StringFind(message, "= ", pos1);
               int pos3 = StringFind(message,"\n",pos2);
               capitalDeRef = StringToDouble(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
               Print("Capital = " + DoubleToString(capitalDeRef));
              }
            if(StringFind(message, "Lot",0) >= 0)
              {
               int pos1 = StringFind(message, "Lot",0);
               int pos2 = StringFind(message, "= ", pos1);
               int pos3 = StringFind(message,"\n",pos2);
               lot = NormalizeDouble(StringToDouble(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2))),2);
               lot = lot / capitalDeRef * (AccountBalance() + AccountCredit());
               lot = GetLot(sy, lot);
               Print("Lot = " + DoubleToString(lot,2));
              }
            if(StringFind(message, "StopLoss",0) >= 0)
              {
               int pos1 = StringFind(message, "StopLoss",0);
               int pos2 = StringFind(message, "= ", pos1);
               int pos3 = StringFind(message,"\n",pos2);
               sl = NormalizeDouble(StringToDouble(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2))),digits);
               Print("Stoploss = " + DoubleToString(sl));
              }
            if(StringFind(message, "TakeProfit",0) >= 0)
              {
               int pos1 = StringFind(message, "TakeProfit",0);
               int pos2 = StringFind(message, "= ", pos1);
               int pos3 = StringFind(message,"\n",pos2);
               tp = NormalizeDouble(StringToDouble(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2))),digits);
               Print("TakeProfit = " + DoubleToString(tp));
              }
            if(StringFind(message, "Ticket",0) >= 0)
              {
               int pos1 = StringFind(message, "Ticket",0);
               int pos2 = StringFind(message, "= ", pos1);
               int pos3 = StringFind(message,"\n",pos2);
               nm = (int)StringToInteger(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
               Print("Numero magic = " + IntegerToString(nm));
              }
            //Print(bot.signal);
            if(sy != NULL)
              {
               int ticket = OrderSend(sy, type, lot, price, 3, sl, tp, NULL, nm, 0, clrBlue);
               if(ticket >= 0)
                 {
                  Print("Order Send successfully");
                  if(OrderSelect(ticket,SELECT_BY_TICKET))
                    {
                     GlobalVariableSet(IntegerToString(ticket), price);
                     GlobalVariableSet("Tp " + IntegerToString(ticket), tp);
                     GlobalVariableSet("Sl " + IntegerToString(ticket),sl);
                     GlobalVariableSet("Open " + IntegerToString(ticket), OrderOpenPrice());
                    }
                 }
              }
           }
        }
      //--------------------------- Modification de trade ------------------
      if(StringFind(message, "Modify",0) >= 0)
        {
         if(StringFind(message, "Numero magic",0) >= 0)
           {
            int pos1 = StringFind(message, "Numero magic",0);
            int pos2 = StringFind(message, "= ", pos1);
            int pos3 = StringFind(message,"\n",pos2);
            nm = (int)StringToInteger(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
            Print("Numero magic = " + IntegerToString(nm));
           }
         if(StringFind(message, "TakeProfit",0) >= 0)
           {
            int pos1 = StringFind(message, "TakeProfit",0);
            int pos2 = StringFind(message, "= ", pos1);
            int pos3 = StringFind(message,"\n",pos2);
            tp = (double)StringToDouble(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
            Print("TakeProfit = " + DoubleToString(tp));
           }
         if(StringFind(message, "OpenPrice",0) >= 0)
           {
            int pos1 = StringFind(message, "OpenPrice",0);
            int pos2 = StringFind(message, "= ", pos1);
            int pos3 = StringFind(message,"\n",pos2);
            op = (double)StringToDouble(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
            Print("OpenPrice = " + DoubleToString(op));
           }
         if(StringFind(message, "Stoploss",0) >= 0)
           {
            int pos1 = StringFind(message, "Stoploss",0);
            int pos2 = StringFind(message, "= ", pos1);
            int pos3 = StringFind(message,"\n",pos2);
            sl = (double)StringToDouble(StringSubstr(message,pos2 + 2, (pos3) - (pos2 + 2)));
            Print("Stoploss = " + DoubleToString(sl));
           }
         if(nm != 0 ||
            op != 0 ||
            tp != 0 ||
            sl != 0)
           {
            for(int i = 0; i < OrdersTotal(); i++)
              {
               if(OrderSelect(i, SELECT_BY_POS))
                 {
                  if(OrderMagicNumber() == nm)
                    {
                     bool res = OrderModify(OrderTicket(), op, sl, tp, 0,clrBrown);
                     if(res)
                       {
                        Print("OrderModify Successfully");
                        GlobalVariableSet(IntegerToString(OrderTicket()), price);
                        GlobalVariableSet("Tp " + IntegerToString(OrderTicket()), tp);
                        GlobalVariableSet("Sl " + IntegerToString(OrderTicket()),sl);
                        GlobalVariableSet("Open " + IntegerToString(OrderTicket()), OrderOpenPrice());
                       }
                    }
                 }
              }
           }
        }
     }
  }
//}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void ClotureTrade(int nm, double price)
  {
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderMagicNumber() == nm)
           {
            int ticket = OrderTicket();
            double lot = OrderLots();

            int nom = ChercheTicket(ticket);
            if(OrderClose(ticket, lot, price, 3, clrRed))
              {
               Print("OrderClose successfully " + IntegerToString(nom));
               if(!GlobalVariableDel(IntegerToString(nom)))
                 {
                  Print(" Variable global non détruite" + IntegerToString(GetLastError()));
                 }
               if(!GlobalVariableDel("Tp " + IntegerToString(nom)))
                 {
                  Print(" Variable global non détruite" + IntegerToString(GetLastError()));
                 }
               if(!GlobalVariableDel("Sl " + IntegerToString(nom)))
                 {
                  Print(" Variable global non détruite" + IntegerToString(GetLastError()));
                 }
               if(!GlobalVariableDel("Open " + IntegerToString(nom)))
                 {
                  Print(" Variable global non détruite" + IntegerToString(GetLastError()));
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
void CloturePartielle(int nm, double lot)
  {
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderMagicNumber() == nm)
           {
            if(OrderClose(OrderTicket(), lot, OrderOpenPrice(), 3, clrRed))
              {
               Print("OrderClose successfully");

              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
int ChercheTicket(int ticket)
  {
   int ty = ticket;
   for(int i = OrdersHistoryTotal(); i > 0; i--)
     {

      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {

         if(StringFind(OrderComment(), IntegerToString(ty),0) >= 0)
           {
            ty = OrderTicket();
           }
        }
     }
   return ty;
  }
//+------------------------------------------------------------------+
string Pass()
  {
   string pass = "Pass = ";
   uchar a = 0;
   for(int i = 0; i < 10; i++)
     {

      a = (uchar)findRandom(95,0);
      a = a +33;

      Print(a);
      pass = pass + CharToStr(a);

     }
   bot.SendMessage(Diego,pass);
   if(GlobalVariableSet(pass, 100)) {}
   return pass;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double findRandom(double range, int roundTo)
  {

   double ran = MathRand();
   double sign = MathRand();

   int div = 32767;

   if(sign <= (div/2))
     {
      sign = 0;
     }
   else
     {
      sign = 1;
     }

   double finalValue;

//if(sign == 1)
//  {
   finalValue = NormalizeDouble((ran/div)*range,roundTo);
//}
//else
//  {
//   finalValue = -(NormalizeDouble((ran/div)*range,roundTo));
//  }

//Comment(finalValue);

   return(finalValue);

  }
//+------------------------------------------------------------------+
void InitialisationCompte()
  {
   bool search = false;
   if(GlobalVariablesTotal() == 0 || GlobalVariableGet(GlobalVariableName(GlobalVariablesTotal())) == 100)
     {
      Print("allo");
      Print(Pass());
     }
   for(int i = 0; i < GlobalVariablesTotal(); i++)
     {
      if(GlobalVariableGet(GlobalVariableName(i)) == 100)
        {
         Print(GlobalVariableName(i));
         search = true;
        }


     }
   if(!search)
     {
      Print(Pass());
     }
  }
//+------------------------------------------------------------------+
string SetSymbol(string sy)
  {
   int limit = SymbolsTotal(false);
   string sym;

   for(int i = 0; i < limit; i++)
     {
      sym = SymbolName(i, false);
      if(StringFind(sym,sy,0) == 0)
        {
         if(MarketInfo(sym,MODE_TRADEALLOWED))
           {
            return sym;
           }
        }
     }
   if(sy == "AUS200")
     {
      sy = "DJ30";
     }
   if(sy == "F40")
     {
      sy = "FRA40";
     }
   if(sy == "JP225")
     {
      sy = "NIKKEI225";
     }
   if(sy == "DE40")
     {
      sy = "DAX40";
     }
   if(sy == "STOXX50")
     {
      sy = "EU50";
     }
   if(sy == "USTEC")
     {
      sy = "US100";
     }
   if(sy == "UK100")
     {
      sy = "FTSE100";
     }
   if(sy == "US30")
     {
      sy = "DJ30";
     }
   if(sy == "US500")
     {
      sy = "SP500";
     }
   for(int i = 0; i < limit; i++)
     {
      sym = SymbolName(i, false);
      if(StringFind(sym,sy,0) == 0)
        {
         if(MarketInfo(sym,MODE_TRADEALLOWED))
           {
            return sym;
           }
        }
     }
   return sym;

  }
//+------------------------------------------------------------------+
double GetLot(string sy, double lot)
{
   if(lot < SymbolInfoDouble(sy, SYMBOL_VOLUME_MIN) )
   {
      lot = SymbolInfoDouble(sy, SYMBOL_VOLUME_MIN);
   }
   return lot;
}