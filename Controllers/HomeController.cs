using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Avaliacao.Gama.Api.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Title = "Home Page";

            using (var db = new modelEntities())
            {
                var test = from a in db.QuestaoAlternativa
                           select a;
                var test2 = test.FirstOrDefault();
            }

                return View();
        }
    }
}
