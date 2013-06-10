<metadata>
1d215669e49c5934c7ab4a6a4432ec893a48b6c55f36abc495fbb18cfedcffceaa8427176e4c765601644e205536f7980e6af8915b35325581bcfddfcabf9aee3650301d645c0f2deed13709b985adc07e11acc8dbae026e0a6fd2f26016bfdafb89f88b7019dab5d3bd84b9644631001d333404ebc9241a0834b2dcaacb0a676306784635748ade623093afd3fc147af091e68b2045a49a4c70b2c6512807771e7b645a83ca5e30a2c660095231f796a1d5345b8bf9f1cd103f1f6bf28b44349efb7947546844281f7e5836cea9acd9ef8ef99e41240c323e73fbaac38f5f6be6da7d52f19db8d97f11fc9bd5a09afb7215b9dc3608e8d4d5b45b2e4f3b4d2591fe6311a39d69282b5e8afe9ff72b44c2b0ccf08ea1492891e489fd4a22442bb8cab08ecef28feca3ccdcb152220160cba5126b2d13e3a0412eb9d4542401600c6284fd0e324d626e0d0966610caada3859375950291e20c5f91b7879167a17d4b9b9dc640a5226483b704e6b57634c8eed533cef829cf18eeb38566216a9daf2cc7d41a7c489e6bacac7be6f1d0a63e6817f17e6920073b688420109665d2d2d5489fb8ce53651a2ca88fc04244c1385a5d7e54373ffcfd6e33519ceee4f022742394d3253e9b8c7b2402f3f4b9ffacdbe85a5f7a44c23ddbb96e2b4c38deca7d53154bd9dacef006fb1c36010e0ce201c9fb023408be43a4a354c0c7e0e674f28e78f4430493a93ad90ac1d794524dbaf8feade9142241b5872003257a3c25521ef8697f8e18f457bcffda891537d0d3cb183b29c3002deee556597af4d710926583c9bfa5f2bd7b2c788583e6a29abd91d785e3ff0845b3284eb1876251b6458187dbbc3b3c317538fee9feb4c29c2fc81b1ccfd042a201046771b357a4a0b3b2f1fcdfc271b2a05492c6810e7970c48aecfc0b4660380be310d3b4b31507f0cf380dfa81e71d3a18feb201e0b377f50a1d14c2d7300f98a6314771813612743caf475497d1298ed2e5a6515592c196d152b3e7ab882653997e7186a81ee0c66c9ac7e1dfa8ebdce9ec2f8a83c4e6f0091c5b8ca523399fd75107f0d0133ebb70252ebbf85c981c34d380b62ddb10f6b1e7b760429751270f29b92fc3b672266583dfa98a9dc91f6d488db92117f284c90f972114928fb8f8ee15f2d2f5c421e7b47e5ca89e65d28eb9f5b2b582d3e4a556b1f232052d8bd5432b9dc1664a2c70c62a8cbdabf0576112f003c5c2edabf593f187dbac84227543a4221ed88704ecba626574529e4d02a16113eb4c677120d6bf792f88a0164513fa2c17c19221c90ac705f5e2c70150a6c80e59fed6f0af59b44278de851225f613a0679102749fd996d047516bbdac7b3fc93c2b06b247505d9ad620bf39cdeb0bbc85f7f0e7d0663dcac1879abd995f4077385e0fdc04a684a1e46349bee305581a391af5864ee822841a4ca5e3b8aaa503e09687419cbae35083210f2beb3da3f513d58f1d197a6496b9ebed7b4e48b59353b5454261e2377555c71a5946a5ef6c1f9ce5561ccfc94a52d1a4d6fddfd3744a6d25c252f430560162bc9eb53630022c4e46017adc406623c4880e8dee3d8fae9d86e4cd5eb9fa337183854a2cbbcd2dfbad2ec043882ada9c05a34523681e8b0d30362e397f7980270642b7a0a1367abc26f00016f295af0cec7fb567989e4137c6602b9cca1cde78267597282a8bd0b1401daa0f36c901c67e83b
</metadata>
//+------------------------------------------------------------------+
//|                                                          ATR.mq4 |
//|                      Copyright _ 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright _ 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
//---- input parameters
extern int AtrPeriod=14;
//---- buffers
double AtrBuffer[];
double TempBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 1 additional buffer used for counting.
   IndicatorBuffers(2);
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,AtrBuffer);
   SetIndexBuffer(1,TempBuffer);
//---- name for DataWindow and indicator subwindow label
   short_name="ATR("+AtrPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexDrawBegin(0,AtrPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Average True Range                                               |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=AtrPeriod) return(0);
//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=AtrPeriod;i++) AtrBuffer[Bars-i]=0.0;
//----
   i=Bars-counted_bars-1;
   while(i>=0)
     {
      double high=High[i];
      double low =Low[i];
      if(i==Bars-1) TempBuffer[i]=high-low;
      else
        {
         double prevclose=Close[i+1];
         TempBuffer[i]=MathMax(high,prevclose)-MathMin(low,prevclose);
        }
      i--;
     }
//----
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   for(i=0; i<limit; i++)
      AtrBuffer[i]=iMAOnArray(TempBuffer,Bars,AtrPeriod,0,MODE_SMA,i);
//----
   return(0);
  }
//+------------------------------------------------------------------+