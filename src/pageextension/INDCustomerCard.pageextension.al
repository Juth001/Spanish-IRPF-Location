namespace ScriptumVita.IRPF;
pageextension 86315 "IND Customer Card" extends "Customer Card"
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
        addafter("Copy Sell-to Addr. to Qte From")
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
