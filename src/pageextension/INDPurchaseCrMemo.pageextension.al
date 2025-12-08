namespace ScriptumVita.IRPF;
pageextension 86303 "IND Purchase Cr. Memo" extends "Purchase Credit Memo"
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
        addafter("Move Negative Lines")
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
