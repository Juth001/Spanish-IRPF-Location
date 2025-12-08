namespace ScriptumVita.IRPF;
pageextension 86306 "IND Purchase Return Order" extends "Purchase Return Order"
{
    layout
    {
        addafter(Status)
        {
            field("Tipo Percepción"; Rec."Tipo Percepción")
            {
                ApplicationArea = All;
            }
            field("Clave Percepción"; Rec."Clave Percepción")
            {
                ApplicationArea = All;
            }
        }
        //++OT2-059505
        modify("VAT Reporting Date")
        {
            visible = false;
        }
    }
}
