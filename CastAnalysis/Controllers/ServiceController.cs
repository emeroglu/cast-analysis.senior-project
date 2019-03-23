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
    public class ServiceController : Controller
    {
        [HttpPost]
        public int LogTheUserIn(JsonUser p1)
        {
            Entities entity = new Entities();

            fcUser user = entity.fcUsers.Where(u => u.GoogleID == p1.googleId).FirstOrDefault();

            if (user == null)
            {
                user = new fcUser()
                {
                    GoogleID = p1.googleId,
                    Name = p1.name,
                    Email = p1.email
                };

                entity.fcUsers.Add(user);
                entity.SaveChanges();
            }

            return user.PK;
        }

        [HttpPost]
        public void SaveAccounts(string p1, List<JsonAccount> p2)
        {
            Entities entity = new Entities();

            fcAccount account;

            foreach (JsonAccount jsonAccount in p2)
            {
                account = entity.fcAccounts.Where(a => a.AccountID == jsonAccount.id).FirstOrDefault();

                if (account == null)
                {
                    account = new fcAccount()
                    {
                        AccountID = jsonAccount.id,
                        Name = jsonAccount.name
                    };

                    entity.fcAccounts.Add(account);
                    entity.SaveChanges();

                    fcUserAccount userAccount = new fcUserAccount()
                    {
                        fcUser = entity.fcUsers.Where(u => u.GoogleID == p1).FirstOrDefault(),
                        fcAccount = account
                    };

                    entity.fcUserAccounts.Add(userAccount);
                    entity.SaveChanges();
                }

            }

        }        
    }

}