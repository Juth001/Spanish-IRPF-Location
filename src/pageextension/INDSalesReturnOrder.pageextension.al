namespace ScriptumVita.IRPF;
pageextension 86312 "IND Sales Return Order" extends "Sales Return Order"
{
    layout
    {
        addafter(Status)
        {
            field("Tipo Percepción"; "Tipo Percepción")
            {
                ApplicationArea = All;
            }
            field("Clave Percepción"; "Clave Percepción")
            {
                ApplicationArea = All;
            }
        }
    }
}
