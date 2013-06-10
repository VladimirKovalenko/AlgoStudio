<metadata>
85b9053a166e2b46d9b5cfefb5c31d782e5c4d3e91f8cfa04628ac910f2dccfd9bb5427287a552727b1ed1bfec8f6c03b1d5670e84ea7611ccf1391b0b7e691d395f97baf9c1ebc981be003e023e0f62ee813357b1c4137f4d28d5f55e281d78b8cacbb85f36b1dee987dfe27f5dc9f887a95a6a4d6f98a63905dcb2e4852c41dbbee4da1240226d8ccf5f63113e187655342e438aeffbc5c5f96410a3daafdf81e44f710f46573980e4f79ef7941d7c285ca8c76d1f6f53e2cde296245dbeceb5d0bd8383bf204cd4b5d7b9cfa813661879d9becfaa7a44bcf1c697b2fead99b38fa08fadc1f392026c2b4c2e5b41202245a7c22f11340825449ce9d3a7f49c8be45321cdf334753a4ff98d4129452abac8e2de91be442586f32450e28aacc3b5c7bb85ffc35d3ebbd4a4c91262e5844927e69f3806b1f2c7a8cda05222ef8e7816740d625ee0cfc1a2e788274a71010766f896b0c9b28cb18d5536442b9ef35538284d513fc9bd55265769fbc7341bddbe006f234ec3aee2875836f5815b2885bb132f6d0e8ae581f1c0b95321563f5d3aa9c1a3d74d3ec0fe97d499f680f00a736311d0b93c5b08601763486805ac64447042211103330c3ab69a59797d2f7b14c3a1aacf2f5d532764444a02147d472b6c00bf834c63f291e6896b1b91e80a78355c5c3b1d750f7b5526f8c66b57a2c60061d5a1cbaee7a88bed4704ec9e2d48c6a75d29345d6b04f698f7c91c2e390f123c1f2f5660f1df36042a1a8bba1426142896b9b8dc3e5f7004d6b3a3ecbfd93b78e795a1c4c3a22652bdd4523d94fadde3271b8ce9275fcdbda7e3bfdee692690c58660e3ec7f64b654777f0c16947d5e5b7874f7f02331a26103f21448af24b3bc682ea8b76026104b48a87bb176791f0166589fa9fe8402f295b0c687d43e5d9654a2252fd9c077486f504736f00a1d3197d82bcf5c93154720ab2d3caa49ad694f54d235c3b66588bdbff8def80fda9a4d6670664001e7baad85b17eb8a711f5b3c2c59badb8cebc3a6427e6a456b0ef38b4f2ee88680cc91f07c1282e5ae906a5663115c395137492c98ea99fcd5bbb2d197f2ee9dd0ee4f73f6849cf903655732d8aa7217deb094f7d2b70e302c77f8dd7d2d9ecce2ad4007e1b3f6b78ec33a1f326f782497c7bcdd31529af130513c5b7a1f691aefb38de02455f69a33071a345121f99a2b46c6fa1a35e597fb9e86e0a5c02b599bfe701e2c4fd1b4201e063af7d8bdcf6603395f5732f587badfd9b7a6c53154abd8a39d407cff96e987f591acc51b7884e56c181e71bac8a7e8a7d7f1858ce5731c96f881f213337f0c0f6a8bfb19787507e485e296c3a63f02ba98eebafc8e413485e09cbe3f015864462ab9d0026c3d58f5d5a3cd6405a5c86a0fd8e5082a95d9224b046a80e5e4c4a3926a484d6dc3a06c03e28e6e0188fa231e5476614c6b5dd4e1a6933b082f19a183a18182f15327fc85b6da5035a69bd7f59fafd5f7bf9f1c6ba5ccd1b5592dbbd3f5c883a1a99872507f5f1360e39aa3ce13715639325ebc8184a6d7e54a7bebdc33117555bec81178cebd573ed5b77e12b5d094a97153c2961361fb8e34519dbf201eb58936199df1066fa9c741241e206a5677587a13cea0b1d5731a2c4fa9c80f7baec1285a39769bebc0b47c15e58a87e9f685417f88b47e0d61041f6d8be283e6ed9e5c625b1dadcce4881e6d2c490c3088a751220065582a7f16593cc6b5645ab589681afb9e40348edaabd219691673b38d430786e93d480d6f7f133752d5e91f30cab85237c3b7653182fb81f131542e1079452944f091d6ae1d5fb2d33b49bbc81b59e3828be8a6cd93ad3c0cf6cad8f7c4a95f3ef981c0826001b2c0e7948dcf1b7a9bf8375c3a04c1fd4c29e38d46272b494f23f194cf8ebad6a6c35c2e4733ec9f407e5016f1900468681be78297ab436cdbbee886ddbc1270bcd06a0fc584c2aea4c14133116505767a44f6ca55309df3a1c0e684e68a1277783b4c2191e57d0f344ddce2c781cbaa6f0315663a5f4a769fb0f297503ec0a1adcfdab612775714620faade6614f68ff6c880bc3f5addb384e5f99bcaa6f396bff65d334531ef9dc1a0ceac43229fedb38d9fd9caab375ba0d388edf8c483ace98ce38d4524680a600c13762168355b780c27552746f290e687beccfdc35b6790bfaac7117e187c1065f39f65001c22ae18debdb7f2ad81dc899e4f500d1a42
</metadata>
//+------------------------------------------------------------------+
//|                                                          ROC.mq4 |
//|                                    Copyright © 2006, Robert Hill |
//+------------------------------------------------------------------+

#property  copyright "Copyright © 2006, Robert Hill"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 1
#property  indicator_color1  Red
//---- indicator parameters
extern int RPeriod = 10;
extern bool UsePercent = false;
//---- indicator buffers
double RateOfChange[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0, DRAW_LINE);
   SetIndexDrawBegin(0, RPeriod);
   IndicatorDigits(Digits + 1);
//---- indicator buffers mapping
   if(!SetIndexBuffer(0, RateOfChange))
       Print("cannot set indicator buffers!");
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("ROC(" + RPeriod + ")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   double ROC, CurrentClose, PrevClose;
   int counted_bars = IndicatorCounted();
//---- check for possible errors
   if(counted_bars < 0) 
       return(-1);
//---- last counted bar will be recounted
   if(counted_bars > 0) 
       counted_bars--;
   limit = Bars - counted_bars - RPeriod;
//---- ROC calculation
   for(int i = 0; i < limit; i++)
     {
       CurrentClose = iClose(NULL, 0, i);
       PrevClose = iClose(NULL, 0, i + RPeriod);
       ROC = CurrentClose - PrevClose;
       //----
       if(UsePercent)
         {
           if(PrevClose != 0)
               RateOfChange[i] = 100 * ROC / PrevClose;
         }
       else
           RateOfChange[i] = ROC;
     }   
//---- done
   return(0);
  }
//+------------------------------------------------------------------+