namespace ScriptumVita.IRPF;
pageextension 86302 "IND G_L Account Card" extends "G/L Account Card"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field("Tipo Cuenta retención"; "Tipo Cuenta retención")
            {
                ApplicationArea = All;
            }
        }
    }
}
