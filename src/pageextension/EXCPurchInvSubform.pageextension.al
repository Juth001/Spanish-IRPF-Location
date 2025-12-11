namespace Excelia.IRPF;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Posting;
pageextension 86309 "EXC Purch.Inv.Subform" extends "Purch. Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field("IRPF %"; Rec."IRPF %")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Control15)
        {
            field(BaseIRPF; BaseIRPF)
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
        addafter("Total Amount Incl. VAT")
        {
            field(DectotalPagar; DectotalPagar)
            {
                visible = true;
                Caption = 'TOTAL A PAGAR';
                ApplicationArea = All;
                Editable = false;
                StyleExpr = TextStyle;
            }
        }
    }
    var
        PurchHeader: record "Purchase Header";
        BaseIRPF: Decimal;
        AmountIRPF: Decimal;
        PercIRPF: Decimal;
        DectotalPagar: Decimal;
        TextStyle: Text;

    trigger OnAfterGetRecord()
    var
        PurchLine: Record "Purchase Line";
        ClaveRet: Record "EXC Perception Keys";
        Imp: Decimal;
        ImpIva: Decimal;
        DecImporteConDescuento: decimal;
    begin
        //TODO: PurchHeader.Get("Document Type", Rec."Document No.");

        if ClaveRet.Get(PurchHeader."Perception Key") then begin
            PurchLine.Reset();
            PurchLine.Setrange("Document Type", Rec."Document Type");
            PurchLine.Setrange("Document No.", Rec."Document No.");
            PurchLine.Setrange("Apply Retention", true);
            PurchLine.Setrange("Retention Line", false);
            if PurchLine.Find('-') then
                repeat
                    if PurchHeader."Payment Discount %" <> 0 then begin
                        DecImporteConDescuento := (PurchLine."Line Amount" - (PurchLine."Line Amount" * PurchHeader."Payment Discount %" / 100));
                        Imp += DecImporteConDescuento;
                    end
                    else
                        Imp += PurchLine."VAT Base Amount";

                    ImpIva += PurchLine."Amount Including VAT";
                until (PurchLine.Next() = 0);
            if ClaveRet."Calculation Type" = ClaveRet."Calculation Type"::Base then
                BaseIRPF := round(Imp, 0.01)
            else
                BaseIRPF := ImpIva;
            PercIRPF := ClaveRet."Retention %";
            AmountIRPF := BaseIRPF * PercIRPF / 100;
            CalculateTotals();

            PurchLine.Reset();
            PurchLine.Setrange("Document Type", Rec."Document Type");
            PurchLine.Setrange("Document No.", Rec."Document No.");
            PurchLine.Setrange("Apply Retention", true);
            PurchLine.Setrange("Retention Line", true);

            if PurchLine.FindFirst() then
                DectotalPagar := TotalAmount
            else
                DectotalPagar := TotalAmount - AmountIRPF;
        end;

        TextStyle := 'Strong';
    end;

    local procedure CalculateTotals()
    var
        PurchLine: Record "Purchase Line";
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        clear(PurchLine);
        clear(TotalPurchLine);
        clear(TotalPurchLineLCY);
        clear(PurchPost);
        PurchPost.GetPurchLines(PurchHeader, TempPurchLine, 0);
        clear(PurchPost);
        PurchPost.SumPurchLinesTemp(PurchHeader, TempPurchLine, 0, TotalPurchLine, TotalPurchLineLCY, VATAmount, VATAmountText);
        if PurchHeader."Prices Including VAT" then begin
            TotalAmount := TotalPurchLine.Amount;
            TotalAmount1 := TotalAmount + VATAmount;
            TotalPurchLine."Line Amount" := TotalAmount1 + TotalPurchLine."Inv. Discount Amount" + TotalPurchLine."Pmt. Discount Amount";
        end
        else begin
            TotalAmount1 := TotalPurchLine.Amount;
            TotalAmount := TotalPurchLine."Amount Including VAT";
        end;
    end;

    var
        TotalPurchLine: Record "Purchase Line";
        TotalPurchLineLCY: Record "Purchase Line";
        PurchPost: Codeunit "Purch.-Post";
        TotalAmount: Decimal;
        TotalAmount1: Decimal;
        VATAmountText: Text[30];
        VATAmount: Decimal;
}
