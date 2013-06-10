
#property copyright "ForexRiskA"
#property link      "http://www.forexriska.com"

#property indicator_chart_window

extern bool Break_Alert_After_Close = TRUE;
extern bool Break_Alert_Before_Close = TRUE;
extern bool Touch_Alert = TRUE;
extern int Touch_Distance = 5;
extern bool All_Trendline_Alert = TRUE;
extern string High_TL_Name = "High";
extern string Low_TL_Name = "Low";
extern bool Email_Alert = FALSE;
extern bool Popup_Alert = FALSE;
extern bool Sound_Alert = FALSE;
extern string Sound_File = "Tick.wav";
extern bool Pictogram_Alert = TRUE;
extern int Pictogram_Symbol = 108;
extern int Pictogram_Corner = 1;
datetime gt_144;
int gi_148 = 1;
string gsa_152[100][3];
bool gi_156;
int gi_160 = 10000000;

int deinit() {
   ObjectDelete("sign");
   return (0);
}

int start() {
   double ld_32;
   double ld_40;
   double ld_48;
   double ld_56;
   double ld_64;
   string ls_0 = AccountNumber();
   string ls_8 = AccountNumber();
   int li_16 = 1;
   // int li_16 = (D'14.02.2012 08:00' - TimeCurrent()) / 86400;
   if (li_16 < 0 || StringFind(ls_8, ls_0, 0) < 0) return (0);
   if (gi_156 == FALSE) {
      f0_0();
      gi_156 = TRUE;
   }
   if (ObjectGet("calctl", OBJPROP_PRICE1) == -1.0 || IndicatorCounted() == 0) return;
   bool li_20 = gt_144 < Time[0];
   if (li_20) {
      gt_144 = Time[0];
      f0_0();
   }
   if (gt_144 == 0) {
      gt_144 = Time[0];
      return (0);
   }
   if (Digits == 5 || Digits == 3 || Digits == 1) gi_148 = 10;
   int li_24 = Touch_Distance * gi_148;
   for (int li_28 = ObjectsTotal() - 1; li_28 >= 0; li_28--) {
      if (ObjectType(ObjectName(li_28)) == 2) {
         if (!All_Trendline_Alert && ObjectName(li_28) != High_TL_Name || ObjectName(li_28) != Low_TL_Name) continue;
         if (ObjectGet(ObjectName(li_28), OBJPROP_COLOR) <= 16777216.0) {
            ld_32 = NormalizeDouble(ObjectGetValueByShift(ObjectName(li_28), 0), Digits);
            ld_40 = NormalizeDouble(ObjectGetValueByShift(ObjectName(li_28), 1), Digits);
            ld_48 = NormalizeDouble(ObjectGetValueByShift(ObjectName(li_28), 2), Digits);
            ld_56 = ObjectGet(ObjectName(li_28), OBJPROP_PRICE1);
            ld_64 = ObjectGet(ObjectName(li_28), OBJPROP_PRICE2);
            if (ld_32 == 0.0 || ld_40 == 0.0) continue;
            if (ld_64 < ld_56) {
               if (Break_Alert_After_Close && li_20 && ld_40 > Open[1] || ld_48 > Close[2] && ld_40 < Close[1]) {
                  f0_2(ObjectName(li_28), 1, 1, 1, gi_160);
                  f0_1(ObjectName(li_28), 2);
                  continue;
               }
               if (Break_Alert_Before_Close && ld_32 > Open[0] || ld_40 > Close[1] && ld_40 < Close[0]) {
                  if (f0_3(ObjectName(li_28), 2)) {
                     f0_2(ObjectName(li_28), 1, 1, 0, gi_160);
                     f0_1(ObjectName(li_28), 2);
                     continue;
                  }
               }
               if (Touch_Alert && iClose(NULL, 0, 0) + li_24 * Point > ld_32 && High[1] + li_24 * Point < ld_40 && iClose(NULL, 0, 0) < ld_32 && High[1] < ld_40) {
                  if (f0_3(ObjectName(li_28), 1)) {
                     f0_2(ObjectName(li_28), 1, 0, 0, gi_160);
                     f0_1(ObjectName(li_28), 1);
                     continue;
                  }
               }
            }
            if (ld_64 > ld_56) {
               if (Break_Alert_After_Close && li_20 && ld_40 < Open[1] || ld_48 < Close[2] && ld_40 > Close[1]) {
                  f0_2(ObjectName(li_28), -1, 1, 1, gi_160);
                  f0_1(ObjectName(li_28), 2);
                  continue;
               }
               if (Break_Alert_Before_Close && ld_32 < Open[0] || ld_40 < Close[1] && ld_40 > Close[0]) {
                  if (f0_3(ObjectName(li_28), 2)) {
                     f0_2(ObjectName(li_28), -1, 1, 0, gi_160);
                     f0_1(ObjectName(li_28), 2);
                     continue;
                  }
               }
               if (Touch_Alert && iClose(NULL, 0, 0) - li_24 * Point < ld_32 && Low[1] - li_24 * Point > ld_40 && iClose(NULL, 0, 0) > ld_32 && Low[1] > ld_40) {
                  if (f0_3(ObjectName(li_28), 1)) {
                     f0_2(ObjectName(li_28), -1, 0, 0, gi_160);
                     f0_1(ObjectName(li_28), 1);
                     continue;
                  }
               }
            }
            gi_160++;
         }
      }
   }
   return (0);
}

int f0_3(string as_0, int ai_8) {
   bool li_12 = TRUE;
   for (int li_16 = 0; li_16 <= 100; li_16++) {
      if (gsa_152[li_16][0] == as_0 && gsa_152[li_16][ai_8] == "N") {
         li_12 = FALSE;
         break;
      }
      if (gsa_152[li_16][0] == " ") {
         li_12 = TRUE;
         gsa_152[li_16][0] = as_0;
         gsa_152[li_16][1] = "Y";
         gsa_152[li_16][2] = "Y";
         break;
      }
   }
   return (li_12);
}

void f0_1(string as_0, int ai_8) {
   for (int li_12 = 0; li_12 <= 100; li_12++)
      if (gsa_152[li_12][0] == as_0) gsa_152[li_12][ai_8] = "N";
}

void f0_0() {
   for (int li_0 = 0; li_0 <= 100; li_0++) {
      gsa_152[li_0][0] = " ";
      gsa_152[li_0][1] = " ";
      gsa_152[li_0][2] = " ";
   }
}

void f0_2(string as_0, int ai_8, int ai_12, int ai_16, int ai_20) {
   string ls_24 = "  long";
   color li_32 = Blue;
   if (ai_8 == -1) {
      ls_24 = "  short";
      li_32 = Red;
   }
   string ls_36 = " at close";
   if (ai_16 == 0) ls_36 = " before close";
   string ls_44 = " break";
   if (ai_12 == 0) {
      ls_44 = " approach";
      ls_36 = "";
   }
   double ld_52 = NormalizeDouble(ObjectGetValueByShift(as_0, 0), Digits);
   if (Pictogram_Alert) {
      ObjectCreate("sign", OBJ_LABEL, 0, 0, 0);
      ObjectSet("sign", OBJPROP_CORNER, Pictogram_Corner);
      ObjectSet("sign", OBJPROP_XDISTANCE, 1);
      ObjectSet("sign", OBJPROP_YDISTANCE, 1);
      ObjectSet("sign", OBJPROP_BACK, TRUE);
   }
   string ls_60 = StringConcatenate(Symbol(), "  ", as_0, ls_24, ls_44, ls_36);
   if (Sound_Alert) PlaySound(Sound_File);
   if (Popup_Alert) Alert(ls_60);
   if (Email_Alert) SendMail("Trendline Alert", ls_60);
   if (Pictogram_Alert) ObjectSetText("sign", CharToStr(Pictogram_Symbol), 32, "Wingdings", li_32);
   Print(Seconds(), " ", ls_60);
   string ls_68 = Symbol() + " " + ai_20;
}