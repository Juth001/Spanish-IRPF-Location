namespace Excelia.IRPF;
using Microsoft.Finance.GeneralLedger.Account;

pageextension 86302 "EXC G/L Account Card" extends "G/L Account Card"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field("Retention Account Type"; Rec."Retention Account Type")
            {
                ApplicationArea = All;
            }
        }
    }
}
