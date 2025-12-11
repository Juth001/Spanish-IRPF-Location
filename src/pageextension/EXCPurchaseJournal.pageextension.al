namespace Excelia.IRPF;
using Microsoft.Finance.GeneralLedger.Journal;

pageextension 86305 "EXC Purchase Journal" extends "Purchase Journal"
{
    layout
    {
        addafter("On Hold")
        {
            field("Perception Type"; Rec."Perception Type")
            {
                ApplicationArea = All;
            }
            field("Perception Key"; Rec."Perception Key")
            {
                ApplicationArea = All;
            }
            field("Retention Base"; Rec."Retention Base")
            {
                ApplicationArea = All;
            }
            field("Retention Amount"; Rec."Retention Amount")
            {
                ApplicationArea = All;
            }
            field("Retention Entry"; Rec."Retention Entry")
            {
                ApplicationArea = All;
            }
            field("Year Accrual"; Rec."Year Accrual")
            {
                ApplicationArea = All;
            }
            field("Retention Document No."; Rec."Retention Document No.")
            {
                ApplicationArea = All;
            }
            field("Liq. retención"; Rec."Liq. Retention")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(RemoveIncomingDoc)
        {
            action("Create Retention Line")
            {
                ApplicationArea = All;
                Image = CreateDocument;
                Caption = 'Create witholding tax line';
                Description = 'Create a withholding tax line based on the current journal line.';
                ToolTip = 'Create a withholding tax line based on the current journal line.';

                trigger OnAction()
                begin
                    exit
                    //TODO: CrearLinRetencionCompras();
                end;
            }
        }
    }
}
