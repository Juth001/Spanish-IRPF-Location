namespace Excelia.IRPF;
using Microsoft.Sales.Document;

pageextension 86310 "EXC Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addafter("Payment Method Code")
        {
            field("Perception Type"; Rec."Type Perception")
            {
                ApplicationArea = All;
            }
            field("Perception Key"; Rec."Key Perception")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
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
                    reLinVenta.Reset();
                    reLinVenta.Setrange("Document Type", Rec."Document Type");
                    reLinVenta.Setrange("Document No.", Rec."No.");
                    if reLinVenta.FindFIRST() then reLinVenta.CrearLinRetencion(reLinVenta);
                end;
            }
        }
    }
}
