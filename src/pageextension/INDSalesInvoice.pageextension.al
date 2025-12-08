namespace ScriptumVita.IRPF;
pageextension 86310 "IND Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addafter("Payment Method Code")
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
    actions
    {
        // Add changes to page actions here
        addafter("P&osting")
        {
            action("Crear línea Retención")
            {
                Image = Percentage;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    reLinVenta: Record "Sales Line";
                begin
                    reLinVenta.RESET;
                    reLinVenta.SETRANGE("Document Type", "Document Type");
                    reLinVenta.SETRANGE("Document No.", "No.");
                    IF reLinVenta.FINDFIRST THEN reLinVenta.CrearLinRetencion(reLinVenta);
                end;
            }
        }
    }
}
