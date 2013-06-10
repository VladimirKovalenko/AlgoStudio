<metadata>
764a3c0359216c0189e56e4e0f7966031f6d4d3e4029600fc5ab83be7f5d40711836facac1e3a78700651f71cfac345b95f182eb3e506d0aaa97e9cb43368efa2e4891bc271fa4865a65f1cfcff3513ce28dfa9e6f1ad7bbe2879cbc8cfafb9e6012e390325b9df2b8d697aa6745e9d87b55f4c42c0ec7f9c1fd016f0b6acda06d08132d84c58deefc9fa0d5660b1065b9d5c6a78df9afc638579ef0efd31b3481efd1b09bf662074e707e425024e59c067623460f31d69fafc19df9543d7e1d52330c78dcb32b59caf6230c8afe453cf48491f4221c132fdcb01c7dee80036485f0b8d96e09294c46782f62613088c43c08152958773458c5a4056bc4a3aedb0869bbdcf693e3dd003c1879483d97e3d9b1d5baf082447a642581f49feb90f8abc4becc91adc9e68eef85f0d7a3a7cf28479cee6e50f0ccf093caa5fb96691930512e40bdc4edd3aae9cda24a270777fa9b4b25e09981bdf0dfd6b5f19e7e134c3c1f7efd93afd682bc87bb89ea17785538afc2f095234d5c281c6f6e50300c0c230a69462989e4422f7d18600e5622d6a50836774ba9ca395695e597eee391264f5b3ce78f6115611281bf185bfb942454354ce99b4e276b0cb1d93a4e0b2b8cd3ad8dab994676bc8c8db8cfe30424226f15704531e485217055204d222551b7d27704dcfcb9eab1de5d3b8df915626c0de193f590c2e2387b89e66416bacac9e7231fdaf5a4c7244b08787d04e49631580d6acca4d4a0fe8debd51824573348293d4936534807badc2063394bfd98f3924236006997f846283f019aa8be87745a5465af9d7e50182a6959350561593c004966f5911574e1953c599bd450362c6f2e5cddb85031e692670e82edea84ecd2605c50356d157f0f4f0b0c6d2357a4c1221c754516271937e2d23809e1cf7444c8f836064776ecd0f9d66702413911617632e988bfcb22474876cff33b4b16776a190f7cbbcc4b249def2e4acdf3cbf7153ac1b119786714dfac8afdf49b205283e7d2eca59968070277c6b28bfb2c598ffb8cb29fdbbb81fda17f0f394b482792f8caaf7d1e2256483bf7ab0454dfad7d12297de7954425ec884025c6b40133b0ec28780b5fc488185a314469000965e48016735a28603c0c6e1b723856772b21653451781a8efbb8df19455f16523cf39783ea97f499f8691dbad5bdcfa6d5a0fc9ba7bb944728daafb6c2bcccc1b4dbaf89b7e8d4b5c7e68371175a3fec9e4227046adcbf5237790a89b76f53d5a7076244228aef1d6f2b4e68062b48cfaa9ca23c514e3fa9c5e9dd112d557ad0a2e6830264294c55270a6f234ddbb8e58094aa6955fed1c3b17316f197aecb3644315485eba6c5e98ca2d1625c5a66c0a9016f4e2a4c255231b6d70c78afc08af8a1ee6d1dc6b2cda4046b422c443734141a690a6fb3c396f74634f495e7936f0ab885dbf9257182f0126788edf2d01826c1fdcea2dfb62a444d28a686c9a75332f994b2d7ffc2d5f7afe34f26b6d84d2893b381b000224161fb98026d1874b6d9e795271a89abf0dd3607fbcfa6903201784cbf8c97a5fec85674d1f198eb96e2bec7fd910663665bf0d2ab9b07257e5e56212049583cc1b5a2ca536eaf8dbe8f0f2de5db92ae220db5d9a0c9442aa1c47947fcc084ab3e57117f6b0fdbb2a2c1a5c44b3ff6997507450a6919730790f99bf4224ccfbc83bdae92f5da5835b3dc99fd6316f79bf2977d434b6bf5e6bafc88d87fe4af6ff35f2b2b
</metadata>
//+------------------------------------------------------------------+
//|                                                 Accumulation.mq4 |
//|                      Copyright _ 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright _ 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 LightSeaGreen
//---- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName("A/D");
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Accumulation/Distribution                                        |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   i=Bars-counted_bars-1;
   while(i>=0)
     {
      double high =High[i];
      double low  =Low[i];
      double open =Open[i];
      double close=Close[i];
      ExtMapBuffer1[i]=(close-low)-(high-close);
      if(ExtMapBuffer1[i]!=0)
        {
         double diff=high-low;
         if(0==diff)
            ExtMapBuffer1[i]=0;
         else
           {
            ExtMapBuffer1[i]/=diff;
            ExtMapBuffer1[i]*=Volume[i];
           }
        }
      if(i<Bars-1) ExtMapBuffer1[i]+=ExtMapBuffer1[i+1];
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+