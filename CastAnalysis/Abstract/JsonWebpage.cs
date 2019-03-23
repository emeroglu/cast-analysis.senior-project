using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CastAnalysis.Abstract
{
    public class JsonWebpage
    {
        public int index { get; set; }
        public string name { get; set; }
        public int today { get; set; }        
        public int mobile { get; set; }
        public int desktop { get; set; }

        public List<JsonDailyView> dailyViews { get; set; }
        public List<JsonMonthlyView> monthlyViews { get; set; }
    }

    public class JsonDailyView
    {
        public string date { get; set; }
        public int count { get; set; }

        public int mobile { get; set; }
        public int desktop { get; set; }
    }

    public class JsonMonthlyView
    {
        public string month { get; set; }
        public int count { get; set; }

        public int mobile { get; set; }
        public int desktop { get; set; }
    }
}