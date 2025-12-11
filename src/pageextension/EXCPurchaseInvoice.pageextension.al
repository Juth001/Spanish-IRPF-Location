namespace Excelia.IRPF;
using Microsoft.Purchases.Document;

pageextension 86304 "EXC Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        addafter("Payment Method Code")
        {
            field("Tipo Percepción"; Rec."Perception Type")
            {
                ApplicationArea = All;
            }
            field("Clave Percepción"; Rec."Perception Key")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(MoveNegativeLines)
        {
            action("Create Retention Line")
            {
                Image = Percentage;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PurchaseLine: Record "Purchase Line";
                begin
                    PurchaseLine.Reset();
                    PurchaseLine.Setrange("Document Type", Rec."Document Type");
                    PurchaseLine.Setrange("Document No.", Rec."No.");
                    if PurchaseLine.FindFirst() then PurchaseLine.CreateAutoRetentionLine(PurchaseLine);
                end;
            }
        }
    }
}
