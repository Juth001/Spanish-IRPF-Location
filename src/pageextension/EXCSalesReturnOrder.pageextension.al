namespace Excelia.IRPF;
using Microsoft.Sales.Document;

pageextension 86312 "EXC Sales Return Order" extends "Sales Return Order"
{
    layout
    {
        addafter(Status)
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
}
