using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web.Mvc;

namespace Avaliacao.Gama.Api.Controllers
{
    public class AvaliacaoController : Controller
    {
        private modelEntities db = new modelEntities();

        // GET: Avaliacaos
        public ActionResult Index()
        {
            var avaliacao = db.Avaliacao.Include(a => a.Docente).Include(a => a.Questionario);
            return View(avaliacao.ToList());
        }

        // GET: Avaliacaos/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Avaliacao avaliacao = db.Avaliacao.Find(id);
            if (avaliacao == null)
            {
                return HttpNotFound();
            }
            return View(avaliacao);
        }

        // GET: Avaliacaos/Create
        public ActionResult Create()
        {

            ViewBag.DocenteID = new SelectList(db.Docente, "DocenteID", "DocenteID");
            ViewBag.QuestionarioID = new SelectList(db.Questionario, "QuestionarioID", "QuestionarioNome");
            return View();
        }

        // POST: Avaliacaos/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "AvaliacaoID,AvaliacaoNome,DocenteID,QuestionarioID,DataRegistro")] Avaliacao avaliacao)
        {
            if (ModelState.IsValid)
            {
                db.Avaliacao.Add(avaliacao);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.DocenteID = new SelectList(db.Docente, "DocenteID", "DocenteID", avaliacao.DocenteID);
            ViewBag.QuestionarioID = new SelectList(db.Questionario, "QuestionarioID", "QuestionarioNome", avaliacao.QuestionarioID);
            return View(avaliacao);
        }

        // GET: Avaliacaos/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Avaliacao avaliacao = db.Avaliacao.Find(id);
            if (avaliacao == null)
            {
                return HttpNotFound();
            }
            ViewBag.DocenteID = new SelectList(db.Docente, "DocenteID", "DocenteID", avaliacao.DocenteID);
            ViewBag.QuestionarioID = new SelectList(db.Questionario, "QuestionarioID", "QuestionarioNome", avaliacao.QuestionarioID);
            return View(avaliacao);
        }

        // POST: Avaliacaos/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "AvaliacaoID,AvaliacaoNome,DocenteID,QuestionarioID,DataRegistro")] Avaliacao avaliacao)
        {
            if (ModelState.IsValid)
            {
                db.Entry(avaliacao).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.DocenteID = new SelectList(db.Docente, "DocenteID", "DocenteID", avaliacao.DocenteID);
            ViewBag.QuestionarioID = new SelectList(db.Questionario, "QuestionarioID", "QuestionarioNome", avaliacao.QuestionarioID);
            return View(avaliacao);
        }

        // GET: Avaliacaos/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Avaliacao avaliacao = db.Avaliacao.Find(id);
            if (avaliacao == null)
            {
                return HttpNotFound();
            }
            return View(avaliacao);
        }

        // POST: Avaliacaos/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Avaliacao avaliacao = db.Avaliacao.Find(id);
            db.Avaliacao.Remove(avaliacao);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
