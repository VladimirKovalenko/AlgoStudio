#define MAGICMA  20050610
extern double DecreaseFactor     = 3;
extern double MovingPeriod       = 12;
extern double MovingShift        = 6;
 double barNew,barOLD,bid,ask,ma;
 int file,res;
 double start,stop,nnn;
 int init()
 {    start=  GetTickCount();
       Print (start);
      file= FileOpen("D:\myASdate.csv",FILE_CSV/*|FILE_READ*/|FILE_WRITE,';');
     return(0);
    }
int CalculateCurrentOrders(string symbol)
  { 
   int buys=0,sells=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
   if(buys>0) return(buys);
   else       return(-sells);
  }
int deinit()
{   
  stop=  GetTickCount();
  double time_sec =(stop-start)/1000;
  double  d=NormalizeDouble((nnn/1000000)/time_sec,2);
  string m ="M";
  if (d<1){d =NormalizeDouble( (nnn/1000)/time_sec,2);  m ="k";}
  double k =time_sec*100000/nnn;
  Print ("Quote/sec: ",d,m,"   #Quotes: ",nnn,"   ms/1K Quotes: ",k,"   testing Time: ",time_sec);
return(0);
    }
void CheckForOpen()
  {
   if(Open[1]>ma && Close[1]<ma)  
     {
      res=OrderSend(Symbol(),OP_SELL,0.1,bid,3,0,0,"",MAGICMA,0,Red);
      FileWrite(file,"\n",TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS ),"Open__sell: ","Open_price: ",bid,"MA: ",ma,"Time: ","Open[1]: ",Open[1] ,"Close[1]: ",Close[1],"\n");
      return;
     }
   if(Open[1]<ma && Close[1]>ma)  
     {
      res=OrderSend(Symbol(),OP_BUY,0.1,ask,3,0,0,"",MAGICMA,0,Blue);
      FileWrite(file,"\n",TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS ),"Open___buy: ","Open_price: ",ask,"MA: ",ma,"Time: ","Open[1]: ",Open[1],"Close[1]: ",Close[1],"\n");
      return;
     }
  }
void CheckForClose()
  {
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      if(OrderType()==OP_BUY)
        {
         if(Open[1]>ma && Close[1]<ma) {
         OrderClose(OrderTicket(),OrderLots(), bid,3,White);
         FileWrite(file,"\n",TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS ),"CLOSE__Buy: ","Open_price: ",bid,"MA: ",ma,"Time: ","Open[1]: ",Open[1],"Close[1]: ",Close[1],"\n");
         }
         break;
         
        }
      if(OrderType()==OP_SELL)
        {
         if(Open[1]<ma && Close[1]>ma) {
           OrderClose(OrderTicket(),OrderLots(), ask,3,White);
           FileWrite(file,"\n",TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS ),"CLOSE_sell: ","Open_price: ",ask,"MA: ",ma,"Time: ","Open[1]: ",Open[1] ,"Close[1]: ",Close[1],"\n");
          }
         break;
        }
     }
  }
void start()
  {   
    nnn++;
//    if(Bars<100) return(0);
  bid= NormalizeDouble(Bid, 5);
 ask =NormalizeDouble(Ask, 5);
 ma=NormalizeDouble (iMA(NULL,0,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,0),5);
 double ma3=NormalizeDouble (iMA(NULL,0,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,0),10);
 double ma4 = NormalizeDouble (ma3-ma,8);
 FileWrite(file,TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS ),"Bid: ",bid,"Ask ",ask,"MA: ",ma,"Time: ","Open[1]: ",Open[1] ,"Close[1]: ",Close[1]);
  barNew= Bars;
   if(CalculateCurrentOrders(Symbol())==0) CheckForOpen();
   else                                    CheckForClose();
 barOLD= Bars;
 return(0);
  }
