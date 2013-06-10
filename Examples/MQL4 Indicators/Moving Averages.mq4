<metadata>
c7fbdfe0aed687ea3f5399b93543b6d3fd8f403384ed620d5739350860420b3affd18bbbd1f3cfef5b3e3c522447c1ae22465b32791780e7033e44664a3f493d1c7a416c536b83a1734c7f41c5f9076a731cf6926d1888e47a1f4b6bec9ae98c255734477c15543bd3bdfec394b698a9b698172786a41f219ea2355bf594442997f291afdf92a3ccea9cc9a083edf790e0c0c889a4d2ceab483a0061e88fbcd9e497b589a08f98f6315069041b7e88b689b5b4c071085424fe9be6d88fc6aec099fd84ed92f10f6eacd8a3cc9cee89b57659f084007944348aef340a526e5a36f796a7c9ee896d18abcafb9cbdd8d0ee7c318bda5a16eedaab97e7c89ff387e6afc17512d8ad2a4b086f45203f01f5c9fb9aadd8e89ca3cbe689384afbc5ebaa2752a4d0e48cbed13d4f91addbf4016060157602553d93fcc4b62d13221eec8fe08fff920171bcdd325c5b22f8c63576a7c8d3be0d7d91f090fe750c5864c9e67615056ae588b6c65a3b4c22ee972a14201c2e4d5936016c8fe266037d13f387c9ba330d073bd9f6b4d788e7234e422f6f0a78167c08e3900e30380403606708ec9c2f5695e7224bee893e5620541e6dc4fa1e5dafc07e0e92eb2b59fb92a3c4c3ab81f51636aef1f0d05f6d3e0e1d2d281c75599bbb68257c19730783e2491899ec422dbbcfe98c681be7c7affc0c63d1b7b9cd8cfb187954265a3f6242f3b0ec83314393e3143af1cd426d5437402f3747c0b95d2f5930fd9a472f275381f2477994a84521dcbdfd896005e7a884e2b4f7a3d15f3a63020571fa936807b5db2816390b98a1fad413229aa8644a4c7ec5f5af9f7d455c60b798a8cca9c8fc881c79470866003f7c6c1ee1844726097df39a6f002f41c4fa0f335134c4bcc2b2f6b233526d19eb8eb38d4d7de1d0fed06e5e93a2e9c7d8e88fbf77477b4a172b2609d5b0f0881969d793e889c8bcf491dae41f234a3a402115663d4e3c4baec190e2f69293ad79459db24a3a9bfa89fa4536592e721d097bdfbb033d80bc3d52c0b5621681f1f782deaa6d535a1e1228c894f686dba906692842caaf0a697b0f2457590555055f2df69951050577accdd0b4e98c41335664376b114180d4eaa6246692e7026b3c50385ca2c76416d38f1173ed84c1af702ccb8ff491d5b7f386a3c4520e6d24d8b65337e68fdbb8ceafea9e4c23becc6d1e7c2085b994bb3d52c4b1760273032f5a304427198eb2fc8e8bee1375ddb866143055254b5e3d4623a0d395aba39f2f5d781d781e0a6fa7d54b2ed4bad3b05d38c4fa9bf61e6fd5b9f3c7605c557aff8deb8e3b5d2742d8aa3f5afa94a5c6a5c0ebd598a4755a215381e4cfa92c4901737c19305e5635f792e291122c172be18809671e7afb9295f667068afe244b85f780cfdfafe7931f7606699df37003a7872457c8ad8efee88912603c5d2652355090add9fbd99f08694b2795e69ffa43610f3184b82f43b6df6c02abce9abab8d639580c61e782083537159ed260094b253f5a8cac0b3ac1e30c2cc2a14827660a482733417449280a735ed6e0e5d0dde887b4043267458fafdcaf5622fc85e48897f215281331cefef8da3d1d4c3bb3da96f20e7a670f477a89ab26171634b08ead911738d4b8d6bfea84d5b049774a76a08ff099ee8086e2e58c3b58157443374926c3b1a0ef740404704e27402f67097506506e2a16cce3bcd13956583ce99c90fcd0b5201e1efc1c80efe3bbab4c755b84c0e0dcaf
</metadata>
//+------------------------------------------------------------------+
//|                                        Custom Moving Average.mq4 |
//|                      Copyright _ 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright _ 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- indicator parameters
extern int MA_Period=13;
extern int MA_Shift=0;
extern int MA_Method=0;
//---- indicator buffers
double ExtMapBuffer[];
//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   int    draw_begin;
   string short_name;
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexShift(0,MA_Shift);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
   if(MA_Period<2) MA_Period=13;
   draw_begin=MA_Period-1;
//---- indicator short name
   switch(MA_Method)
     {
      case 1 : short_name="EMA(";  draw_begin=0; break;
      case 2 : short_name="SMMA("; break;
      case 3 : short_name="LWMA("; break;
      default :
         MA_Method=0;
         short_name="SMA(";
     }
   IndicatorShortName(short_name+MA_Period+")");
   SetIndexDrawBegin(0,draw_begin);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   if(Bars<=MA_Period) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
//----
   switch(MA_Method)
     {
      case 0 : sma();  break;
      case 1 : ema();  break;
      case 2 : smma(); break;
      case 3 : lwma();
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
//| Simple Moving Average                                            |
//+------------------------------------------------------------------+
void sma()
  {
   double sum=0;
   int    i,pos=Bars-ExtCountedBars-1;
//---- initial accumulation
   if(pos<MA_Period) pos=MA_Period;
   for(i=1;i<MA_Period;i++,pos--)
      sum+=Close[pos];
//---- main calculation loop
   while(pos>=0)
     {
      sum+=Close[pos];
      ExtMapBuffer[pos]=sum/MA_Period;
	   sum-=Close[pos+MA_Period-1];
 	   pos--;
     }
//---- zero initial bars
   if(ExtCountedBars<1)
      for(i=1;i<MA_Period;i++) ExtMapBuffer[Bars-i]=0;
  }
//+------------------------------------------------------------------+
//| Exponential Moving Average                                       |
//+------------------------------------------------------------------+
void ema()
  {
   double pr=2.0/(MA_Period+1);
   int    pos=Bars-2;
   if(ExtCountedBars>2) pos=Bars-ExtCountedBars-1;
//---- main calculation loop
   while(pos>=0)
     {
      if(pos==Bars-2) ExtMapBuffer[pos+1]=Close[pos+1];
      ExtMapBuffer[pos]=Close[pos]*pr+ExtMapBuffer[pos+1]*(1-pr);
 	   pos--;
     }
  }
//+------------------------------------------------------------------+
//| Smoothed Moving Average                                          |
//+------------------------------------------------------------------+
void smma()
  {
   double sum=0;
   int    i,k,pos=Bars-ExtCountedBars+1;
//---- main calculation loop
   pos=Bars-MA_Period;
   if(pos>Bars-ExtCountedBars) pos=Bars-ExtCountedBars;
   while(pos>=0)
     {
      if(pos==Bars-MA_Period)
        {
         //---- initial accumulation
         for(i=0,k=pos;i<MA_Period;i++,k++)
           {
            sum+=Close[k];
            //---- zero initial bars
            ExtMapBuffer[k]=0;
           }
        }
      else sum=ExtMapBuffer[pos+1]*(MA_Period-1)+Close[pos];
      ExtMapBuffer[pos]=sum/MA_Period;
 	   pos--;
     }
  }
//+------------------------------------------------------------------+
//| Linear Weighted Moving Average                                   |
//+------------------------------------------------------------------+
void lwma()
  {
   double sum=0.0,lsum=0.0;
   double price;
   int    i,weight=0,pos=Bars-ExtCountedBars-1;
//---- initial accumulation
   if(pos<MA_Period) pos=MA_Period;
   for(i=1;i<=MA_Period;i++,pos--)
     {
      price=Close[pos];
      sum+=price*i;
      lsum+=price;
      weight+=i;
     }
//---- main calculation loop
   pos++;
   i=pos+MA_Period;
   while(pos>=0)
     {
      ExtMapBuffer[pos]=sum/weight;
      if(pos==0) break;
      pos--;
      i--;
      price=Close[pos];
      sum=sum-lsum+price*MA_Period;
      lsum-=Close[i];
      lsum+=price;
     }
//---- zero initial bars
   if(ExtCountedBars<1)
      for(i=1;i<MA_Period;i++) ExtMapBuffer[Bars-i]=0;
  }
//+------------------------------------------------------------------+

