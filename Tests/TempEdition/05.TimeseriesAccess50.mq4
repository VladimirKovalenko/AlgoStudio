int start()
{
	for(int n=0; n<50; n++)
     {
	     double s1=iClose("111", 0, 0),
	     		s2=iHigh("111", 0, 0),
//	     		s3=iHighest("111", 0, 0), //Поиск по всему масиву тупит систему
	     		shift=iBarShift(Symbol(),0,D'2013.01.03 12:00'),
			    s4=iLow("111", 0, 0),
//	     		s5=iLowest("111", 0, 0),	//Поиск по всему масиву тупит систему
	     		s6=iOpen("111", 0, 0),
	     		s7=iTime("111", 0, 0),
	     		s8=iVolume("111", 0, 0),
	     		s9=iBars("111", 0);
     	}
  return(0);
}

