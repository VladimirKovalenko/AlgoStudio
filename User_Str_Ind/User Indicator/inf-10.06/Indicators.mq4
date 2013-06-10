//---------------------------------------------------
// Project: Indicators
// Language: MQL4
// Type: Strategy
// Author: Karol Marchewka
// Company: PFSoft
// Copyright: Karol Marchewka
// Created: 2012-12-17
//---------------------------------------------------

int init()
{

  return(0);
}

int deinit()
{

  return(0);
}

int start()
{
	Comment("Rsi value: ", Rsi(), "\n",
		    "Trix1 value: ", Trix1(), "\n",
		    "Trix2 value: ", Trix2());
	

  	return(0);
}

double Rsi()
{
   double rsi;
   
   rsi = iRSI(Symbol(), 0, 14, PRICE_CLOSE, 0);
   
   return (rsi);
}

double Trix1()
{
    double trix1;
    
    trix1 = iCustom(Symbol(), 0, "Trix", 0, 0);
    
    return (trix1);
}

double Trix2()
{
    double trix2;
    
    trix2 = iCustom(Symbol(), 0, "Trix", 1, 0);
    
    return (trix2);
}