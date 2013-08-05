
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using PTLRuntime.NETScript;
using System.Drawing.Text;

namespace rrr
{
    /// <summary>
    /// Level2Test
    /// Test Level2
    /// </summary>
    [FullRefreshAttribute]
    public class rrr : NETIndicator 
    {       
    	public double[][] array;
    	public double  size1,size,price1,Price22,avgsize;
    	public int hhh,t1,p,p1;
        public int Time222,Time333;
        public rrr()
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
            base.ProjectName = "trades";
            #endregion 
            
            base.SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
            base.SeparateWindow = false;
            }
            
		public override void Init()
		 
		{  mql4.ObjectsDeleteAll();
		           
		           p1= (mql4.Time[1]-mql4.Time[2]);//*60;
		           if(p>=60)p=p1*60;
		             else  p=p1;
		              
		   
			//NewLevel2Quote += new NewLevel2QuoteHandler(NewLevel2QuoteComes);
			//PriceSubscribe(QUOTE_LEVEL2);
//			 if(   mql4.ObjectCreate("trade", OBJ_RECTANGLE,0,Time222,((Price22-mql4.Point*5)/2),Time333,((Price22+mql4.Point*5)/2))){
//		             Comment("ObjectCreate_OK");}
                array = new double[3][];
                for (int l = 0; l < 3; l++)
                {
                    array[l] = new double[200];
                    }
                for (int l = 0; l < 200; l++)
                {
		              if( !mql4.ObjectCreate("trade"+l, OBJ_RECTANGLE,0,Time222,((Price22-mql4.Point*2)/2),Time333,((Price22+mql4.Point*2)/2)))
		              Print("ok");
		          mql4.ObjectSet("trade"+l,OBJPROP_BACK,1); 
		              
		              mql4.ObjectCreate("text_object"+l, OBJ_TEXT, 0, Time222, Price22);
		              
		               
		             
		     
		                  }

		
		}        
 public override void OnQuote()
{      
  
        
        size1=  com.pfsoft.proftrading.BaseApplication.App.MultiDataCache.QCache.GetLastTrade(Symbol).Size;
        price1=  com.pfsoft.proftrading.BaseApplication.App.MultiDataCache.QCache.GetLastTrade(Symbol).Price;
      double  ask= mql4.Ask;
      double bid= mql4.Bid;
     
		for (int l = 0; l < 3; l++)
          for (int j = 200 - 1; j > 0; j--)
           array[l][j] = array[l][j - 1];	
			 
			 
			 array[0][0] = size1;
			 array[1][0] = price1;
		
			
			    for (int l = 0; l < 200; l++)
			    {
			        
			     size= array[0][l] ;
			     Price22= array[1][l]; 
			   
			      Time222=mql4.Time[l*3]-p*2; 
			      Time333=mql4.Time[l*3];
		

		              
		              double p1= (Price22-mql4.Point/4);
		              double p2= (Price22+mql4.Point/4);
		               double p3= (Price22+1.5*mql4.Point);
		                      if(l==0&&price1>=ask) {
		                      
			                      mql4.ObjectSet("trade"+l,OBJPROP_COLOR,mql4.GreenYellow);
			                        array[2][0] = mql4.GreenYellow;
			                      }
		                       if(l==0&&price1<=bid) {
		                      	   mql4.ObjectSet("trade"+l,OBJPROP_COLOR,mql4.Red);
		                      	   array[2][0] = mql4.Red;
		                      	   }
	                      	   if(l>0){
	                      	      mql4.ObjectSet("trade"+l,OBJPROP_COLOR,array[2][l]);
		                      	    }
		                     
					      	       mql4.ObjectMove("trade"+l,0,Time222,p1);
					      	       mql4.ObjectMove("trade"+l,1,Time333,p2);
					      	        
				      	         
				      	      if (size>5){ 
						      	    mql4.ObjectSetText("text_object"+l,size+"",7,"Tahoma",Color.FromArgb(255,255,255).ToArgb());
						      	    mql4.ObjectMove("text_object"+l,0,Time222,p3);
						      	   }
				      	      if( size<5) mql4.ObjectMove("text_object"+l,0,100*Time222,p3);
				      	           
				      	        				  
}
}
public override void Complete()
		{  
	mql4.ObjectsDeleteAll();
		}
}
}

