using CastAnalysis.Abstract;
using CastAnalysis.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;

namespace CastAnalysis.Controllers
{
    public class PageController : Controller
    {
        public ActionResult Login()
        {
            return View();
        }

        public ActionResult Dashboard(int p1)
        {
            Entities entity = new Entities();

            fcUser user = entity.fcUsers.Where(u => u.PK == p1).FirstOrDefault();

            if (user != null)
            {
                ViewBag.PK = user.PK;
                ViewBag.Name = user.Name.Split(' ')[0];
                ViewBag.GoogleID = user.GoogleID;
            }

            return View();
        }

        public ActionResult Account(string p1)
        {
            Entities entity = new Entities();

            fcUser user = entity.fcUserAccounts.Where(ua => ua.fcAccount.AccountID == p1).FirstOrDefault().fcUser;

            if (user != null)
            {
                ViewBag.User = user;

                ViewBag.AccountId = p1;
            }

            return View();
        }

        public ActionResult Account2(string p1)
        {
            Entities entity = new Entities();

            fcUser user = entity.fcUserAccounts.Where(ua => ua.fcAccount.AccountID == p1).FirstOrDefault().fcUser;

            if (user != null)
            {
                ViewBag.User = user;

                ViewBag.AccountId = p1;
            }

            return View();
        }

        public ActionResult Analysis(string p1)
        {
            Entities entity = new Entities();

            fcUser user = entity.fcUserAccounts.Where(ua => ua.fcAccount.AccountID == p1).FirstOrDefault().fcUser;

            if (user != null)
            {
                ViewBag.User = user;

                ViewBag.AccountId = p1;
            }

            return View();
        }

        public ActionResult Analysis2(string p1)
        {
            Entities entity = new Entities();

            fcUser user = entity.fcUserAccounts.Where(ua => ua.fcAccount.AccountID == p1).FirstOrDefault().fcUser;

            if (user != null)
            {
                ViewBag.User = user;

                ViewBag.AccountId = p1;
            }

            return View();
        }        

        public ActionResult Webpage(int p1, int p2)
        {
            Entities entity = new Entities();

            fcUser user = entity.fcUsers.Where(u => u.PK == p1).FirstOrDefault();



            fcWebpage webpage = entity.fcWebpages.Where(w => w.PK == p2).FirstOrDefault();

            if (webpage == null)
                Redirect("/Page/Dashboard/" + p1);

            ViewBag.Webpage = webpage;

            return View();
        }

        public ActionResult Profile(int p1)
        {
            Entities entity = new Entities();

            fcUser user = entity.fcUsers.Where(u => u.PK == p1).FirstOrDefault();


            return View();
        }
    }


}