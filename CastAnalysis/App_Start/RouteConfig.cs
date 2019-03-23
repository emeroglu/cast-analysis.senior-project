using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace CastAnalysis
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "Route",
                url: "{controller}/{action}",
                defaults: new { controller = "Page", action = "Login"}
            );

            routes.MapRoute(
                name: "Route2",
                url: "{controller}/{action}/{p1}",
                defaults: new { controller = "Page", action = "Login" }
            );

            routes.MapRoute(
                name: "Route3",
                url: "{controller}/{action}/{p1}/{p2}",
                defaults: new { controller = "Page", action = "Login" }
            );

            routes.MapRoute(
                name: "Route4",
                url: "{controller}/{action}/{p1}/{p2}/{p3}",
                defaults: new { controller = "Page", action = "Login" }
            );
        }
    }
}
