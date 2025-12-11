namespace Excelia.IRPF;
using Microsoft.Purchases.Document;

pageextension 86308 "EXC Purch.CRMemo.Subform" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        addafter(Description)
        {
            field("IRPF %"; Rec."IRPF %")
            {
                ApplicationArea = All;
            }
            field("Apply Retention"; Rec."Apply Retention")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Control23)
        {
            field(IRPFBase; IRPFBase)
            {
                Caption = 'Base IRPF';
                ApplicationArea = All;
                Editable = false;
            }
            field(PercIRPF; PercIRPF)
            {
                Caption = '% IRPF';
                ApplicationArea = All;
                Editable = false;
            }
            field(AmountIRPF; AmountIRPF)
            {
                Caption = 'Importe IRPF';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    var
        PurchHeader: record "Purchase Header";
        IRPFBase: Decimal;
        AmountIRPF: Decimal;
        PercIRPF: Decimal;

    trigger OnAfterGetRecord()
    var
        PurchLine: Record "Purchase Line";
        ClaveRet: Record "EXC Perception Keys";
        Imp: Decimal;
        ImpIva: Decimal;
    begin
        //TODO: PurchHeader.Get("Document Type", "Document No.");
        if ClaveRet.Get(PurchHeader."Perception Key") then begin
            PurchLine.Reset();
            PurchLine.Setrange("Document Type", Rec."Document Type");
            PurchLine.Setrange("Document No.", Rec."Document No.");
            PurchLine.Setrange("Apply Retention", true);
            PurchLine.Setrange("Retention Line", false);
            if PurchLine.Find('-') then
                repeat
                    ImpIva += PurchLine."Amount Including VAT";
                until (PurchLine.Next() = 0);
            if ClaveRet."Calculation Type" = ClaveRet."Calculation Type"::Base then
                IRPFBase := Imp
            else
                IRPFBase := ImpIva;
            PercIRPF := ClaveRet."Retention %";
            AmountIRPF := IRPFBase * PercIRPF / 100;
        end;
    end;
}
