extern int x =300;                             // Заданный SL (pt)
extern int l =100;  
int count;
int bar;
int inint(){
    bar=Bars;
    return(0);
    }
int start()
{
    double SL = Bid - x*Point;   
    double TP=Ask + l*Point;
    int B=bar+2;
    if(bar+2==Bars )count++;
    //OP_BUY
    if(count==1 && B==Bars){
        Print(Bars," 1 OP_BUY");
        bar=Bars;
		int ticket0;
    	 ticket0=OrderSend(Symbol(),OP_BUY,1,Ask,30,SL,TP,"My order #",0,0);
    		 if(ticket0<0){
      			 int i0=GetLastError();
        		 Print("OrderSend failed with error #", GetLastErrorDescription(i0));
        		 }
        return(0);
    }
    //OP_SELL
    if(count==2 && B==Bars){
        Print(Bars," 2 OP_SELL");
        bar=Bars;
	    int ticket1;
    	 ticket1=OrderSend(Symbol(),OP_SELL,1,Bid,30,SL,TP,"My order #",16384,0);
		     if(ticket1<0){
      			  int i1=GetLastError();
        		  Print("OrderSend failed with error #", GetLastErrorDescription(i1));
        		  }
        return(0);
    }
    //OP_BUYLIMIT
    if(count==3 && B==Bars){
        Print(Bars," 3 OP_BUYLIMIT");
        bar=Bars;
    	int ticket2;
     	ticket2=OrderSend(Symbol(),OP_BUYLIMIT,1,Ask,30,SL,TP,"My order #",16384,0);
     	if(ticket2<0){
       		int i2=GetLastError();
        	Print("OrderSend failed with error #", GetLastErrorDescription(i2));
        	}
        return(0);
    }
    //OP_SELLLIMIT
    if(count==4 && B==Bars){
        Print(Bars," 4 OP_SELLLIMIT");
        bar=Bars;
    	int ticket3;
     	ticket3=OrderSend(Symbol(),OP_SELLLIMIT,1,Bid,30,SL,TP,"My order #",16384,0);
     	if(ticket3<0){
        	int i3=GetLastError();
        	Print("OrderSend failed with error #", GetLastErrorDescription(i3));
        	}
        return(0);
    }
    //OP_BUYSTOP
    if(count==5 && B==Bars){
        Print(Bars," 5 OP_BUYSTOP");
        bar=Bars;
    	int ticket4;
     	ticket4=OrderSend(Symbol(),OP_BUYSTOP,1,Ask,30,SL,TP,"My order #",16384,0);
     	if(ticket4<0){
        	int i4=GetLastError();
        	Print("OrderSend failed with error #", GetLastErrorDescription(i4));
        	}
        return(0);
    }
    //OP_SELLSTOP
    if(count==6 && B==Bars){
        Print(Bars," 6 OP_SELLSTOP");
		count=0;
        bar=Bars;
    	int ticket5;
     	ticket5=OrderSend(Symbol(),OP_SELLSTOP,1,Bid,30,SL,TP,"My order #",16384,0);
     	if(ticket5<0){
        	int i5=GetLastError();
        	Print("OrderSend failed with error #", GetLastErrorDescription(i5));
        	}
        return(0);
        }
  return(0);
}

