namespace ScriptumVita.IRPF;
pageextension 86307 "IND Purchase Statistics" extends "Purchase Statistics"
{
    layout
    {
        addafter("TotalPurchLine.""Unit Volume""")
        {
            field(BaseIRPF; BaseIRPF)
            {
                Caption = 'Base IRPF';
                ApplicationArea = All;
                editable = false;
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
        addafter(TotalAmount2)
        {
            field(DectotalPagar; DectotalPagar)
            {
                Caption = 'TOTAL A PAGAR';
                ApplicationArea = All;
                Editable = false;
                StyleExpr = TextStyle;
            }
        }
    }
    var
        BaseIRPF: Decimal;
        AmountIRPF: Decimal;
        PercIRPF: Decimal;
        DectotalPagar: Decimal;
        TextStyle: Text;

    trigger OnAfterGetRecord()
    var
        PurchLine: Record "Purchase Line";
        ClaveRet: Record "IND Perception Keys (IRPF)";
        Imp: Decimal;
        ImpIva: Decimal;
        PurchHeader: record "Purchase Header";
        DecImporteConDescuento: decimal;
    begin
        //291220>> cambios para calculo cuando la factura es manual y la linea de la retencion se calcula al registrar
        /*
        PurchLine.SetRange("Document No.", Rec."No.");
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Lín. retención", true);
        if PurchLine.FindFirst() then begin
            BaseIRPF := PurchLine.Quantity;
            PercIRPF := (-100) * PurchLine."Direct Unit Cost";
            AmountIRPF := (-1) * PurchLine.Amount;
        end;
        */
        PurchHeader.GET("Document Type", rec."No.");
        IF ClaveRet.GET(PurchHeader."Clave Percepción") then begin
            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type", Rec."Document Type");
            PurchLine.SETRANGE("Document No.", Rec."No.");
            PurchLine.setrange("Aplica Retencion", true);
            PurchLine.SETRANGE("Lín. retención", FALSE);
            IF PurchLine.FIND('-') THEN
                REPEAT //Correccion importes 030221>>
                    //Correccion importes 01/02/21>>
                    //Imp += PurchLine."Line Amount";
                    if PurchHeader."Payment Discount %" <> 0 then begin
                        DecImporteConDescuento := (PurchLine."Line Amount" - (PurchLine."Line Amount" * PurchHeader."Payment Discount %" / 100));
                        Imp += DecImporteConDescuento;
                    end
                    else
                        Imp += PurchLine."VAT Base Amount";
                    //Correccion importes 01/02/21<<
                    /*
                    if PurchLine."Pmt. Discount Amount" <> 0 then
                        Imp += PurchLine."Line Amount" - PurchLine."Pmt. Discount Amount"
                    else
                        Imp += PurchLine."Line Amount";
                        */
                    //Correccion importes 030221<<
                    ImpIva += PurchLine."Amount Including VAT";
                UNTIL (PurchLine.NEXT = 0);
            IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
                BaseIRPF := round(Imp, 0.01)
            ELSE
                BaseIRPF := ImpIva;
            PercIRPF := ClaveRet."% Retención";
            AmountIRPF := BaseIRPF * PercIRPF / 100;
            CalculateTotals;
            //290121>> si está la línea de la retención en la factura en TotalAmount ya está descontado AmountIRPF
            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type", Rec."Document Type");
            PurchLine.SETRANGE("Document No.", Rec."No.");
            PurchLine.setrange("Aplica Retencion", true);
            PurchLine.SETRANGE("Lín. retención", true);
            IF PurchLine.FindFirst() THEN
                DectotalPagar := TotalAmount
            else
                //290121<<
                DectotalPagar := TotalAmount - AmountIRPF;
        end;
        TextStyle := 'Strong';
    end;

    local procedure CalculateTotals()
    var
        PurchLine: Record "Purchase Line";
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        Clear(PurchLine);
        Clear(TotalPurchLine);
        Clear(TotalPurchLineLCY);
        Clear(PurchPost);
        PurchPost.GetPurchLines(Rec, TempPurchLine, 0);
        Clear(PurchPost);
        PurchPost.SumPurchLinesTemp(Rec, TempPurchLine, 0, TotalPurchLine, TotalPurchLineLCY, VATAmount, VATAmountText);
        if "Prices Including VAT" then begin
            TotalAmount := TotalPurchLine.Amount;
            TotalAmount1 := TotalAmount + VATAmount;
            TotalPurchLine."Line Amount" := TotalAmount1 + TotalPurchLine."Inv. Discount Amount" + TotalPurchLine."Pmt. Discount Amount";
        end
        else begin
            TotalAmount1 := TotalPurchLine.Amount;
            TotalAmount := TotalPurchLine."Amount Including VAT";
        end;
        /*
                    if Vend.Get("Pay-to Vendor No.") then
                        Vend.CalcFields("Balance (LCY)")
                    else
                        Clear(Vend);

                    PurchLine.CalcVATAmountLines(0, Rec, TempPurchLine, TempVATAmountLine);
                    TempVATAmountLine.ModifyAll(Modified, false);
                    SetVATSpecification;
            */
    end;

    local procedure SetVATSpecification()
    begin
        CurrPage.SubForm.PAGE.SetTempVATAmountLine(TempVATAmountLine);
        CurrPage.SubForm.PAGE.InitGlobals("Currency Code", AllowVATDifference, AllowVATDifference, "Prices Including VAT", AllowInvDisc, "VAT Base Discount %");
    end;

    var
        PurchPost: Codeunit "Purch.-Post";
        Vend: Record Vendor;
        TotalAmount: Decimal;
        TotalAmount1: Decimal;
        VATAmountText: Text[30];
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        AllowInvDisc: Boolean;
        AllowVATDifference: Boolean;
}
