<metadata>
92ae0b340f77513c8fe35d7d3741781d6b19681bbfd61976254b3d00e1c3182968460b3bb391a989c7a2c9a744276b046206a5ccf09e13748ab798ba6c1924505137674afcc41537ffc02f11ae921d704926b3d7e693d3bf523776566513f3965321b2c1e68f8ce38be5714c8cae3706220c427214362917e2dea2cc0465335e6401bb857d3f65005b3afe8c1b68093587a84f210362a4c971145967f7cbdaaec1b877073752caf4632a5a340d6980e9f99adfbe5e2a224dabd9467abe912c580b724535dbbe8fb12b177e123d5cfa943e592f5a5a3ba3c48de8dde3bcf1f5a4e9a5b387625ef8d715790e6f5d33accb6e1b345502651e7b5f61261a3b5a582dfa8e620a3857acde99a75b1ae396d1a5c2aad2bde99bf3cfd7f8c5a47500c1b5a3cbea85d5a76f51201cdab9b1de6f02710193f2fb95b8c192ac9cdf5d32523f8efe6c0d5b35a7deb08c3c1398fbe48b82efc7b74d2cd5bbabd25c62eed215763b54c3aec2afbfda1c727c086211ead4162a7b54bfdcdbb4e984b9d49df8a7c9fe8a2f5ceed0d6ea0c6f4f205929c1b8fa88721b07600b63f88c5023112fdd9e701f6f1f156c8ffd59303057a3cb82f6dbfb005f93b30537053577473207371b9ebe2c6155300276f091b7e673065c33f08490f522517656f5a6c3ac2e48730752255f3ee69400654767b9faf6994133ff8ff7d9d2ee200f086b9ff0f383384166142c45c3a4422a85f1c4b7330d04387c1859380c785c394a0513750c4f3c4e7217cdac66129ff6deb1cea08cb2f1c3fec7d2fcd7e685b7d9f7c4f6f7c7a3934a722c106e4105616908691d7015236c56301f5c3e4c4b2ee3821460442d751ae789a19fcbf7dbbea6defb8bca8e1372e59185e05c62c4f4e1d07b550f3f10215e70d4e4f6c6c4f40233d1ed69469df8ee96d4a481c534552753e6837f415b67beceadcc5e2d24578afd6708c1b381e5be80f2cee1ce5626dbba6c1fe89badda721d592bd9bda39da599573890e5ef9b295988fd5327043a81c50339421e7d0ded9f95fa4c266104442792e651223b676030addf1b7430646c1e7e1f5a3e13767a08dbe96438772791c5eea28ecce0958ce5fc9099fd650092e0247842202f46c1af9cc0c286dabf9af8e297d4b3693540093b55086cd0b9a0c3e081087c553acdbfdcaf6d31e6da2e019af532478ffb5d2dfa8f691dab95d4e85321e386d1b7dbbe5f2dd6b3335dfb981b7e0e7d4e700a3670027b1e096f53366113b5d00a647013a7c2013f5d3037462945704484b85778fb89f4910e681c796f1d2e4b88e6adced1b4c7f9a995e3cc6d1fc4a127415732b2c0c1a490feb4d7b2d7b7c4271982bed1b8ec82412588e1355611700c7887e888faace37e0e9feb7d1499f67719c6b51636d3a0e48168185a3be49693f2552198fdc0fda785f4a03745aadfc5a0e6c4467895a9d3bff39a4826600557772d43e180c1acb5d0063bb0921854741da6c8ef8a684890a1143663436300ed824d21e18e7604dfe27a58c7eae3d792a32e1a7642704945735a6a15375e7efc8f44305128513df297b08de6c487b7af8d88a8a8dfd2bb71158ffb563e576aa28046770426a39d370b0d224e22761f3658cda837098ab6d7f820498ee0d5b1f8916f0cd6b70470620d7705276883f3285cbcd51a7557390477102efec289a6b6dbb9d6a3c78efb2f43fc994c728685fd2b1fa30bc6b4fe9f86287a1b51
</metadata>
//+------------------------------------------------------------------+
//|                                                        Bears.mq4 |
//|                      Copyright _ 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright _ 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Silver
//---- input parameters
extern int BearsPeriod=13;
//---- buffers
double BearsBuffer[];
double TempBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 1 additional buffer used for counting.
   IndicatorBuffers(2);
   IndicatorDigits(Digits);
//---- indicator line
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,BearsBuffer);
   SetIndexBuffer(1,TempBuffer);
//---- name for DataWindow and indicator subwindow label
   short_name="Bears("+BearsPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Bears Power                                                      |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=BearsPeriod) return(0);
//----
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
   for(i=0; i<limit; i++)
      TempBuffer[i]=iMA(NULL,0,BearsPeriod,0,MODE_EMA,PRICE_CLOSE,i);
//----
   i=Bars-counted_bars-1;
   while(i>=0)
     {
      BearsBuffer[i]=Low[i]-TempBuffer[i];
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+