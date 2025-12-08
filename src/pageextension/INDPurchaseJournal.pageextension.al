namespace ScriptumVita.IRPF;
pageextension 86305 "IND Purchase Journal" extends "Purchase Journal"
{
    layout
    {
        addafter("On Hold")
        {
            field("Tipo Percepción"; "Tipo Percepción")
            {
                ApplicationArea = All;
            }
            field("Clave percepción"; "Clave percepción")
            {
                ApplicationArea = All;
            }
            field("Base retención"; "Base retención")
            {
                ApplicationArea = All;
            }
            field("Importe retención"; "Importe retención")
            {
                ApplicationArea = All;
            }
            field("Mov. retención"; "Mov. retención")
            {
                ApplicationArea = All;
            }
            field("Año devengo"; "Año devengo")
            {
                ApplicationArea = All;
            }
            field("Nº doc. retención"; "Nº doc. retención")
            {
                ApplicationArea = All;
            }
            field("Liq. retención"; "Liq. retención")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(RemoveIncomingDoc)
        {
            action("Crear lín. retención")
            {
                ApplicationArea = All;
                //CaptionML = ENU = 'Create witholding tax line', ESP = 'Crear línea retención';
                Caption = 'Create witholding tax line';

                trigger OnAction()
                begin
                    CrearLinRetencionCompras();
                end;
            }
        }
    }
}
