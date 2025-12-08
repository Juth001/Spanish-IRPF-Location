namespace ScriptumVita.IRPF;
pageextension 86313 "IND Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter("Balance Due (LCY)")
        {
            field("Importe Ret. Profesional"; "Importe Ret. Profesional")
            {
                ApplicationArea = All;
            }
            field("Importe Ret. Alquileres"; "Importe Ret. Alquileres")
            {
                ApplicationArea = All;
            }
            field("Importe Ret. Garantía"; "Importe Ret. Garantía")
            {
                ApplicationArea = All;
            }
            field("Importe Ret. Otros"; "Importe Ret. Otros")
            {
                ApplicationArea = All;
            }
        }
        addafter("Pay-to Vendor No.")
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
