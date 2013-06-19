
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using PTLRuntime.NETScript;
using System.Drawing.Text;

namespace AndrewLevel2Test
{
    /// <summary>
    /// Level2Test
    /// Test Level2
    /// </summary>
    public class AndrewLevel2Test: NETIndicator 
    {
    
    	[InputParameter("Required Lots", 0, 0, 1000)]
    	public double RequiredAmount = 90;
    	public int pp=0;
    	public  int kk=0;
    	
        public AndrewLevel2Test()
            : base()
        {
			#region // Initialization
            base.Author = "nicky";
            base.Comments = "testandrew";
            base.Company = "PFSoft";
            base.Copyrights = "(c) PFSoft";
            base.DateOfCreation = "13.09.2010";
            base.ExpirationDate = 0;
            base.Version = "1.0";
            base.Password = "66b4a6416f59370e942d353f08a9ae36";
            base.ProjectName = "Level2Test";
            #endregion 
            
            base.SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
            base.SeparateWindow = false;
        }
        
        /// <summary>
        /// This function will be called after creating
        /// </summary>
		public override void Init()
		{
		kk=0;
		pp=0;
		mql4.ObjectsDeleteAll();
			NewLevel2Quote += new NewLevel2QuoteHandler(NewLevel2QuoteComes);
			PriceSubscribe(QUOTE_LEVEL2);
			Print("init");
		}        
 

        /// <summary>
        /// This function will be called before removing
        /// </summary>
		public override void Complete()
		{  
		mql4.ObjectsDeleteAll();
			NewLevel2Quote -= new NewLevel2QuoteHandler(NewLevel2QuoteComes);
			PriceUnsubscribe(QUOTE_LEVEL2);
			Comment("");
			Print("deinit");
		}

		private void NewLevel2QuoteComes(string symbol)
		{    
			double LotSize=mql4.MarketInfo(mql4.Symbol(),mql4.MODE_LOTSIZE)	;
			int ask_count = GetLevel2Count(ASK);
			int bid_count = GetLevel2Count(BID);
			double max= mql4.MathMax(ask_count, bid_count);
			
			for (int i = 0; i<max; i++)
			{  
				double ask = GetLevel2Size(ASK, i);
				double bid =  GetLevel2Size(BID, i);
				string ask1=  mql4.DoubleToStr(ask,0);
				string  bid1=  mql4.DoubleToStr(bid,0);
				string name1 = mql4.DoubleToStr(i,0);
				double ASKprice= GetLevel2Price(ASK, i);
				double BIDPrice= GetLevel2Price(BID, i);
				double mid =(ASKprice+BIDPrice)/2;
				int t=mql4.TimeCurrent();
				double shift=(mql4.Point)/2;
				int t_back=t+500;
				int t_for=t+500;
				int t_last=t+mql4.Period()*60;
				double size1;
				double price1;
				
				if(kk==0)
				{
					//ask for crATE
					mql4.ObjectCreate(i+"ask", OBJ_TEXT,0,t_for,ASKprice+shift);
					//bid for 
					mql4.ObjectCreate(i+"bid", OBJ_TEXT,0,t_for,BIDPrice+shift);   
					
					size1=  com.pfsoft.proftrading.BaseApplication.App.MultiDataCache.QCache.GetLastTrade(mql4.Symbol()).Size;
					price1=  com.pfsoft.proftrading.BaseApplication.App.MultiDataCache.QCache.GetLastTrade(mql4.Symbol()).Price;
					
					mql4.ObjectCreate("last_for", OBJ_TEXT,0,t_last,price1+shift);								  
					mql4.ObjectSetText("last_for",size1+"",10,"Tahoma",Color.FromArgb(0,0,0).ToArgb());
					//LASTPRICE trade back
					mql4.ObjectCreate("last_back", OBJ_RECTANGLE,0,t_last,price1-shift,t_last+800,price1+shift);
					mql4.ObjectSet("last_back",OBJPROP_COLOR,Color.FromArgb(255,150,0).ToArgb());
					mql4.ObjectSet("last_back",OBJPROP_BACK,1);  
					
					if (i==0)
					{
						//Back   color
						mql4.ObjectCreate("back", OBJ_RECTANGLE,0,t_back,(ASKprice+ask_count*mql4.Point+shift),(t+800),(BIDPrice-bid_count*mql4.Point-shift));
						mql4.ObjectSet("back",OBJPROP_COLOR,Color.FromArgb(25,50,50,50).ToArgb());
						mql4.ObjectSet("back",OBJPROP_BACK,1); 
						
						//  Best bid back   
						mql4.ObjectCreate("bid_back", OBJ_RECTANGLE,0,t_back,BIDPrice-shift,(t+800),BIDPrice+shift);
						mql4.ObjectSet("bid_back",OBJPROP_COLOR,Color.FromArgb(15,124,185).ToArgb());
						mql4.ObjectSet("bid_back",OBJPROP_BACK,1); 
						
						//Best ask  back
						mql4.ObjectCreate("ask_back", OBJ_RECTANGLE,0,t_back,(ASKprice+shift),(t+800),ASKprice-shift);
						mql4.ObjectSet("ask_back",OBJPROP_COLOR,Color.FromArgb(180,51,30).ToArgb());
						mql4.ObjectSet("ask_back",OBJPROP_BACK,1);
						
						//spread  back
						mql4.ObjectCreate("spread", OBJ_RECTANGLE,0,t_back,ASKprice-shift,t+800,BIDPrice+shift);
						mql4.ObjectSet("spread",OBJPROP_COLOR,Color.FromArgb(150,150,150).ToArgb()); 
						mql4.ObjectSet("spread",OBJPROP_BACK,1);
						
						//ask for        
						mql4.ObjectSetText(i+"ask",ask1,10,"Tahoma",Color.FromArgb(224,224,224).ToArgb());
						//mql4.ObjectSet(i+"ask",OBJPROP_BACK,1);  
						
						//bid for      
						mql4.ObjectSetText(i+"bid",bid1,10,"Tahoma",Color.FromArgb(224,224,224).ToArgb());
						// mql4.ObjectSet(i+"bid",OBJPROP_BACK,1);
					}
					if (i>0)
					{
						//ask   no best
						mql4.ObjectSetText(i+"ask",ask1,8,"Tahoma",Color.FromArgb(225,50,50).ToArgb());
						//bid no best
						mql4.ObjectSetText(i+"bid",bid1,8,"Tahoma",Color.FromArgb(20,183,255).ToArgb());
					}
				
				}
				if(kk>0)
				{
				
					size1=  com.pfsoft.proftrading.BaseApplication.App.MultiDataCache.QCache.GetLastTrade(mql4.Symbol()).Size;
					price1=  com.pfsoft.proftrading.BaseApplication.App.MultiDataCache.QCache.GetLastTrade(mql4.Symbol()).Price;
					
					if (i==0) 
					{
						mql4.ObjectMove("back",0,t_back,(ASKprice+ask_count*mql4.Point+shift));
						mql4.ObjectMove("back",1,t+800,(BIDPrice-bid_count*mql4.Point-shift));
						
						mql4.ObjectMove("ask_back",0,t_back,(ASKprice+shift));
						mql4.ObjectMove("ask_back",1,t+800,(ASKprice-shift));
						
						mql4.ObjectMove("bid_back",0,t_back,BIDPrice+shift);
						mql4.ObjectMove("bid_back",1,t+800,BIDPrice-shift);
						
						mql4.ObjectMove("spread",0,t_back,ASKprice-shift);
						mql4.ObjectMove("spread",1,t+800,BIDPrice+shift);
						
						mql4.ObjectMove("last_back",1,t_last+800,price1+shift);
						mql4.ObjectMove("last_for",0,t_last,price1+shift); 
						mql4.ObjectSetText("last_for",size1+"",9,"Tahoma",Color.FromArgb(0,0,0).ToArgb());
						
						mql4.ObjectMove(i+"bid",0,t_for,BIDPrice+shift);
						mql4.ObjectMove(i+"ask",0,t_for,ASKprice+shift);
						mql4.ObjectSetText(i+"bid",bid1,9,"Tahoma",Color.FromArgb(225,225,225).ToArgb());
						mql4.ObjectSetText(i+"ask",ask1,9,"Tahoma",Color.FromArgb(225,225,225).ToArgb());
					}
					
					if (i>0)
					{
						mql4.ObjectMove(i+"bid",0,t_for,BIDPrice+shift);
						mql4.ObjectMove(i+"ask",0,t_for,ASKprice+shift);
						
						mql4.ObjectSetText(i+"ask",ask1,7,"Tahoma",Color.FromArgb(225,20,20).ToArgb());
						mql4.ObjectSetText(i+"bid",bid1,7,"Tahoma",Color.FromArgb(20,183,255).ToArgb());
						
						mql4.ObjectMove("last_back",0,t_last,price1-shift);
						mql4.ObjectMove("last_back",1,t_last+800,price1+shift);
						mql4.ObjectMove("last_for",0,t_last,price1+shift); 
						mql4.ObjectSetText("last_for",size1+"",9,"Tahoma",Color.FromArgb(0,0,0).ToArgb());  
					}
				
				}
			}
			kk=kk+1;
		}
	}
}
		
		
		