//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Avaliacao.Gama.Api
{
    using System;
    using System.Collections.Generic;
    
    public partial class AvaliacaoResultadoEstudante
    {
        public int AvaliacaoResultadoEstudanteID { get; set; }
        public int AvaliacaoEstudanteID { get; set; }
        public Nullable<decimal> Nota { get; set; }
        public System.DateTime DataRegistro { get; set; }
    
        public virtual AvaliacaoEstudante AvaliacaoEstudante { get; set; }
    }
}
