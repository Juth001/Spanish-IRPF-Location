namespace Excelia.IRPF;
using Microsoft.Purchases.Vendor;

pageextension 86313 "EXC Vendor Card" extends "Vendor Card"
{
    layout
    //tTODO: Crear grupo IRPF en diseño
    {
        addafter("Balance Due (LCY)")
        {
            field("Professional Retention Amount"; Rec."Amount Professional Retention")
            {
                ApplicationArea = All;
            }
            field("Rent Retention Amount"; Rec."Amount retention.Rent")
            {
                ApplicationArea = All;
            }
            field("Guarantee Retention Amount"; Rec."Ret Amount. Guarantee")
            {
                ApplicationArea = All;
            }
            field("Others Retention Amount"; Rec."Amount retention others")
            {
                ApplicationArea = All;
            }
        }
        addafter("Pay-to Vendor No.")
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
