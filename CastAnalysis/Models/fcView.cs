//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CastAnalysis.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class fcView
    {
        public int PK { get; set; }
        public int PageFK { get; set; }
        public string IP { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public string Country { get; set; }
        public string Region { get; set; }
        public string City { get; set; }
        public string Browser { get; set; }
        public bool Desktop { get; set; }
        public bool Mobile { get; set; }
        public System.DateTime Date { get; set; }
    
        public virtual fcWebpage fcWebpage { get; set; }
    }
}
