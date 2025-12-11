namespace Excelia.IRPF;
using Microsoft.Purchases.Document;

pageextension 86303 "EXC Purchase Cr. Memo" extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Payment Method Code")
        {
            field("Perception Type"; Rec."Perception Type")
            {
                ApplicationArea = All;
            }
            field("Perception Key"; Rec."Perception Key")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
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
                    PurchaseLine: Record "Purchase Line";
                begin
                    PurchaseLine.Reset();
                    PurchaseLine.Setrange("Document Type", Rec."Document Type");
                    PurchaseLine.Setrange("Document No.", Rec."No.");
                    if PurchaseLine.FindFIRST() then PurchaseLine.CreateAutoRetentionLine(PurchaseLine);
                end;
            }
        }
    }
}
