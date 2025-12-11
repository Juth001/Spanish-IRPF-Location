namespace Excelia.IRPF;
using Microsoft.Finance.GeneralLedger.Setup;

pageextension 86301 "EXC General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addafter(Application)
        {
            group(Retentions)
            {
                field("Retention Journal Template"; Rec."Retention Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Retention Batch"; Rec."Retention Batch")
                {
                    ApplicationArea = All;
                }
                field("Retention Aux. Batch"; Rec."Retention Aux. Batch")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
