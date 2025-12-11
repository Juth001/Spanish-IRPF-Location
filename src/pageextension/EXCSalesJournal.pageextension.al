namespace Excelia.IRPF;
using Microsoft.Finance.GeneralLedger.Journal;

pageextension 86311 "EXC Sales Journal" extends "Sales Journal"
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
            field("Liq. Retention"; Rec."Liq. Retention")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Insert Conv. LCY Rndg. Lines")
        {
            action("Crear línea retención")
            {
                ApplicationArea = All;
                Caption = 'Create witholding tax line';

                trigger OnAction()
                begin
                    exit;
                    //TODO:CreaLinRetencionVentas;
                end;
            }
        }
    }
}
