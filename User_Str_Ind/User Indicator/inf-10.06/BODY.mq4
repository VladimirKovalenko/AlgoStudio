#property copyright ""
#property link      ""

#property  indicator_chart_window

extern int   MinimumBodySize        = 29;
extern int   MinimumShadowSize      = 10;
extern int   CandlestickBody        = 29;

extern bool  ShowRange              = false;            
extern bool  ShowBodySize           = true;   
extern bool  ShowShadowSize         = true;         
extern bool  PopupAlertMessage      = false;         
extern int   AlertMessageDuration   = 5;  
extern int   TextHeight             = 10;  
extern color BullTextColor          = DeepSkyBlue;             
extern color BearTextColor          = White;       
extern color ShadowTextColor        = Gold;
extern int   BullTextShift          = 150;               
extern int   BearTextShift          = 100;              
extern int   ShadowTextSpacing      = 50;  
extern int   LookBackBars           = 300;

datetime RangeT;

int init()  {RangeT=Time[1]; return(0); }
int deinit()   
   {
   for(int i=LookBackBars; i>=0; i--)
      {
	   ObjectDelete(""+i);
      ObjectDelete("L"+i);
      ObjectDelete("H"+i);
      ObjectDelete("ST"+i);
      ObjectDelete("SB"+i);
      }
   Comment ("");	
   return(0); }

int start()
   {
   bool BarUP, Flag; 
   
   double GetRange, GetOC, Range;  
   
   double ShadowSizeMax, ShadowSizeBot, ShadowSizeTop;
   int LastBody;
   
   for(int x=1; x<LookBackBars; x++)
   {
      GetRange =(High[x]-Low[x]); if(Digits<4) GetRange=GetRange*100; else GetRange=GetRange*10000;
      GetOC    =(Close[x]-Open[x]); if(Digits<4) GetOC=GetOC*100; else GetOC=GetOC*10000; 
   
      if (Close[x]>=Open[x]) 
      {
         ShadowSizeBot =(Open[x]-Low[x]); if(Digits<4) ShadowSizeBot=ShadowSizeBot*100; else ShadowSizeBot=ShadowSizeBot*10000;
         ShadowSizeTop =(High[x]-Close[x]); if(Digits<4) ShadowSizeTop=ShadowSizeTop*100; else ShadowSizeTop=ShadowSizeTop*10000;
      }
      else 
      {
         ShadowSizeBot =(Close[x]-Low[x]); if(Digits<4) ShadowSizeBot=ShadowSizeBot*100; else ShadowSizeBot=ShadowSizeBot*10000;
         ShadowSizeTop =(High[x]-Open[x]); if(Digits<4) ShadowSizeTop=ShadowSizeTop*100; else ShadowSizeTop=ShadowSizeTop*10000;
      }
      
      if (ShadowSizeBot>ShadowSizeTop) ShadowSizeMax = ShadowSizeBot; else ShadowSizeMax = ShadowSizeTop;     
          
      if (Open[x]<Close[x]) BarUP=1; else BarUP=0;
          
      if ((MathAbs(GetOC) >= MinimumBodySize) || (MathAbs(ShadowSizeTop)>=MinimumShadowSize || MathAbs(ShadowSizeBot)>=MinimumShadowSize) )
         {
         if (!ShowBodySize && ShowRange)        
            {
            if (BarUP==0)
               {
               ObjectDelete(""+x);
               ObjectCreate(""+x, OBJ_TEXT, 0, Time[x],Low[x]-BearTextShift*Point );
               ObjectSetText(""+x, DoubleToStr(GetRange,0), TextHeight, "Arial", BearTextColor);
               }
            if (BarUP==1)
               {
               ObjectDelete(""+x);
               ObjectCreate(""+x, OBJ_TEXT, 0, Time[x],High[x]+BullTextShift*Point );
               ObjectSetText(""+x, DoubleToStr(GetRange,0), TextHeight, "Arial", BullTextColor);
               }
            }  
         
         if (ShowBodySize && !ShowRange)        
            {
            if (BarUP==0)
               {
               ObjectDelete(""+x);
               ObjectCreate(""+x, OBJ_TEXT, 0, Time[x],Low[x]-BearTextShift*Point );
               ObjectSetText(""+x, DoubleToStr(MathAbs(GetOC),0), TextHeight, "Arial", BearTextColor);
               }
            if (BarUP==1)
               {
               ObjectDelete(""+x);
               ObjectCreate(""+x, OBJ_TEXT, 0, Time[x],High[x]+BullTextShift*Point );
               ObjectSetText(""+x, DoubleToStr(GetOC,0), TextHeight, "Arial", BullTextColor);
               }
            }  
         if (ShowBodySize && ShowRange)        
            {
            if (BarUP==0)
               {
               ObjectDelete(""+x);
               ObjectCreate(""+x, OBJ_TEXT, 0, Time[x],Low[x]-BearTextShift*Point );
               ObjectSetText(""+x, DoubleToStr(MathAbs(GetOC),0)+"/"+DoubleToStr(GetRange,0), TextHeight, "Arial", BearTextColor);
               }
            if (BarUP==1)
               {
               ObjectDelete(""+x);
               ObjectCreate(""+x, OBJ_TEXT, 0, Time[x],High[x]+BullTextShift*Point );
               ObjectSetText(""+x, DoubleToStr(GetOC,0)+"/"+DoubleToStr(GetRange,0), TextHeight, "Arial", BullTextColor);
               }
            }  
         }
      
      if (MathAbs(ShadowSizeTop)>=MinimumShadowSize || MathAbs(ShadowSizeBot)>=MinimumShadowSize)
      {
         if (ShowShadowSize)        
         {

            if (BarUP==1)
            {
               ObjectDelete("ST"+x);
               ObjectCreate("ST"+x, OBJ_TEXT, 0, Time[x],High[x]+(BullTextShift+ShadowTextSpacing)*Point );
               ObjectSetText("ST"+x, DoubleToStr(ShadowSizeTop,0), TextHeight, "Arial", ShadowTextColor);
               
               ObjectDelete("SB"+x);
               ObjectCreate("SB"+x, OBJ_TEXT, 0, Time[x],High[x]+(BullTextShift-ShadowTextSpacing)*Point );
               ObjectSetText("SB"+x, DoubleToStr(ShadowSizeBot,0), TextHeight, "Arial", ShadowTextColor);
               
            }

            if (BarUP==0)
            {
               ObjectDelete("ST"+x);
               ObjectCreate("ST"+x, OBJ_TEXT, 0, Time[x],Low[x]-(BearTextShift-ShadowTextSpacing)*Point );
               ObjectSetText("ST"+x, DoubleToStr(ShadowSizeTop,0), TextHeight, "Arial", ShadowTextColor);
               
               ObjectDelete("SB"+x);
               ObjectCreate("SB"+x, OBJ_TEXT, 0, Time[x],Low[x]-(BearTextShift+ShadowTextSpacing)*Point );
               ObjectSetText("SB"+x, DoubleToStr(ShadowSizeBot,0), TextHeight, "Arial", ShadowTextColor);
               
            }
            
         }           
       }     
    }
      
     if (PopupAlertMessage && MathAbs(LastBody)>=CandlestickBody) 
     {     
         if (TimeSeconds(TimeCurrent())<=AlertMessageDuration && TimeMinute(TimeCurrent())==0 ) 
         {
            Alert("", Symbol(),"  Candlestick Body Formed, Body is ",LastBody, " Pips", " At ", TimeHour(TimeCurrent()), ":", TimeMinute(TimeCurrent()) );
         } 
     }   

     return(0);
   }
 
 

