pageextension 86304 "IND Purchase Invoice" extends "Purchase Invoice"
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
        addafter(MoveNegativeLines)
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
                    reLinCompra: Record "Purchase Line";
                begin
                    reLinCompra.RESET;
                    reLinCompra.SETRANGE("Document Type", "Document Type");
                    reLinCompra.SETRANGE("Document No.", "No.");
                    IF reLinCompra.FINDFIRST THEN reLinCompra.CrearAutoLinRetencion(reLinCompra);
                end;
            }
        }
    }
}
