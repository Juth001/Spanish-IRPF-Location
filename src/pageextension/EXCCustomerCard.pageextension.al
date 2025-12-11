namespace Excelia.IRPF;
using Microsoft.Sales.Customer;

pageextension 86315 "EXC Customer Card" extends "Customer Card"
{
    layout
    //TODO: Crear grupo IRPF en diseño
    {
        addafter("Balance Due (LCY)")
        {
            field("Amount professional retention"; Rec."Amount professional retention")
            {
                ApplicationArea = All;
            }
            field("Amount retention.Rent"; Rec."Amount retention.Rent")
            {
                ApplicationArea = All;
            }
            field("Amount retention Guarantee"; Rec."Ret Amount. Guarantee")
            {
                ApplicationArea = All;
            }
            field("Amount retention others"; Rec."Amount retention others")
            {
                ApplicationArea = All;
            }
        }
        addafter("Copy Sell-to Addr. to Qte From")
        {
            field("Perception Type"; Rec."Perception Type")
            {
                ApplicationArea = All;
            }
            field("Key Perception"; Rec."Key Perception")
            {
                ApplicationArea = All;
            }
        }
    }
}
