<metadata>
6458ac937e063855e08c95b5186ebcd9f88a6a19deb7e48b5739665b57750938a58b96a6416302223b5e513f98fb2946b2d6157cb9d7b6d194a96a48522700748fe9ffd239017153b38c16288bb7127f0b6460044a3fd8b4eb8ea2827a0ca9cc94e6176499f01f70315f3b06c8ea2918b8968ebe5f7d2e10e0dcf29c51302c4195f07c42efa016651459632296aa4d6280ee83e2d1bc3f5ac0fe7a46c2b62d5400706e0bd7e90c453957d1b57c1581e286e79ce8d4bbbecc96aa88a7d6a2bec7a3d398fdfcc2774b8ce0c4a51c72a3c4ccb9ec8de6811e7b7749c28f4918034f3c081428b19ebcd0d3b284ea8ee94e3b4c2ddbbc197c4e705965bddcc2b73246573f9cf3f7853f01c2831e6b0672a1c9f7985624b68ae7c85233ed98ed993f57a0cf1e6cfac4bd816b08bfd0781598e87213e987641d1d236b286e01335eabdbb4d5553b453c6854250a7516a4cbf19cc4b4b2d35638f48d615f1c206407fb944e234825c5a096f86c184536003e516df1def89b82ed97fa204d2a4fcfa1e397b7c490aecef294f7335c3444344dcab8f69f4f28a3cb4733eb98b886ca899df20f7ffe878cfe6a0307600d65b7c3bf9fa4fbedcd47755d6d1828fbcf624e45657f32fa9fb3c7d1b07d2c7b0e5738a9ddb3d695e67959bdee06696c0aa7d3205773128bf91f7ae4c40c4ff29d45372f5fc7e96f53d5faee8da1ceaedee990bcceb1d80166690183f7cdbee6d8f9c515712e4f55214e2b37786a0c90d3473594f199f8691d335a422d3b55b7892416aa9346685968f7c5f6d8201299a93f0fcef66a56a689721662037d09bfdad7985f3977347b0910754f2e0672d4bd3c537816231d3509f194c9b1f484266218793b4f2a4f526cbf8f67563d13dbeb6f5e8aa4211104341121b08181bd1d328de8651df484652199f83f4b7613d9e71d21daaa7514ddaec9ba7e097a152f5d1672cdf32c10eac5c2b2fa9b384b314251262847d8aab4d0221c023ef49ba4d12c589aea6a1f0276122c26625369712d4c3c1567244b8ee42441006345312754d28ee3b3b2c0422d247084f61f7e294db4d13341c8faecb0f0a0164286caa0e27b0e2b423a56abcf8ce9ec9e6c307210e0898ce2d5890f4b2a4f04667500a5c24a161c552f410367157c0e6d01601460046ba3d1d7a4b6ea5b6798b7e48b8df8e89c1868a0d58afe320c5c60186a8aefe583d5b0d1a3e88d036d503398fd196a7f410438e89a2e4b660007621765fa9f8ee096f50663261895f83445cba7e5d16a56a08fdfad83e6e98f6401c7b5d1b484ea325186e3f5cbf5c9fed180f25d38b4d25f3adba94a2f731d23409df84a393c020935741d78169ffb3b5296f55f3e7c08bfd0453793dcf4846317b0d9503fef8197e44060dead187de898b4d57c0e63025f2b214483beb89a2377c6b46015f3965674dde3665a8ee2f79ed9b7fd987b5bcba5a3c29af7ff9a2b1690b2f7bb365f0769c9ac1737eedf684a9aba0b68305f620e7c13a2d0300d14368fa2bb8f2d1c15217145291005334f7f795bc2e25f2cb2c62b52bbd7b0d5e1dc5173dbeb5577a787285f5831aeca087c5d35714c9ab8487adbf9ead4b68ac9e6e68a4c256c025633e5db4579e0cfcba2e688bbdf640daac96a0b6c1898f793e1dd92f282ee9a4e273758eb85a6d54f71f8c4b09f87ea97f83256c2b7e985e3866957b2ab1cf103b9f955e0240f695c908802
</metadata>
//+------------------------------------------------------------------+
//|                                                         OsMA.mq4 |
//|                      Copyright _ 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright _ 2004, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 1
#property  indicator_color1  Silver
#property  indicator_width1  2
//---- indicator parameters
extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalSMA=9;
//---- indicator buffers
double     OsmaBuffer[];
double     MacdBuffer[];
double     SignalBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(3);
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexDrawBegin(0,SignalSMA);
   IndicatorDigits(Digits+2);
//---- 3 indicator buffers mapping
   SetIndexBuffer(0,OsmaBuffer);
   SetIndexBuffer(1,MacdBuffer);
   SetIndexBuffer(2,SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("OsMA("+FastEMA+","+SlowEMA+","+SignalSMA+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Average of Oscillator                                     |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st additional buffer
   for(int i=0; i<limit; i++)
      MacdBuffer[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
//---- signal line counted in the 2-nd additional buffer
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(MacdBuffer,Bars,SignalSMA,0,MODE_SMA,i);
//---- main loop
   for(i=0; i<limit; i++)
      OsmaBuffer[i]=MacdBuffer[i]-SignalBuffer[i];
//---- done
   return(0);
  }
//+------------------------------------------------------------------+

