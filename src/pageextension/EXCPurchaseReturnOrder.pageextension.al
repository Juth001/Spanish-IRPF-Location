namespace Excelia.IRPF;
using Microsoft.Purchases.Document;

pageextension 86306 "EXC Purchase Return Order" extends "Purchase Return Order"
{
    layout
    {
        addafter(Status)
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
}
