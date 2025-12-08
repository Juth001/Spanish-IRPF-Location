namespace ScriptumVita.IRPF;
pageextension 86301 "IND General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addafter(Application)
        {
            group(Retenciones)
            {
                // Add changes to page layout here
                field("Libro retenciones"; "Libro retenciones")
                {
                    ApplicationArea = All;
                }
                field("Sección retenciones"; "Sección retenciones")
                {
                    ApplicationArea = All;
                }
                field("Sección auxiliar retenciones"; "Sección auxiliar retenciones")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
