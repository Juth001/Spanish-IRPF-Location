namespace Excelia.IRPF;
using Microsoft.Sales.Document;
tableextension 86316 "Sales Header" extends "Sales Header"
{
    fields
    {
        field(86300; "Type Perception"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Type Perception';
        }
        field(86301; "Key Perception"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Customer));
            Caption = 'Key Perception';
        }
    }
    procedure CreaLinRetencionPedido(SalesHeader: record "Sales Header")
    var
        ClaveRet: Record "EXC Perception Keys";
        AuxLinVenta: Record "Sales Line";
        SalesLine: Record "Sales Line";
        NoLin: Integer;
        Imp: Decimal;
        ImpIva: Decimal;
        QuantToInvo: Decimal;
    begin

        if ClaveRet.Get(SalesHeader."Key Perception") then begin
            clear(SalesLine);
            SalesLine."Document Type" := SalesHeader."Document Type";
            SalesLine.Validate("Document No.", SalesHeader."No.");
            NoLin := SalesLine.TraerNoLinea() + 10000;
            SalesLine.Validate("Line No.", NoLin);
            SalesLine.Insert();
            SalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            SalesLine.Type := SalesLine.Type::"G/L Account";
            //TODO: ClaveRet.Testfield("Retention Acc.");
            SalesLine.Validate("No.", ClaveRet."Retention Acc.");
            SalesLine.Validate("Perception Type", SalesHeader."Type Perception");
            SalesLine.Validate("Perception Key", SalesHeader."Key Perception");
            SalesLine.Validate("Deduction Line", true);
            AuxLinVenta.Reset();
            AuxLinVenta.Setrange("Document Type", SalesHeader."Document Type");
            AuxLinVenta.Setrange("Document No.", SalesHeader."No.");
            AuxLinVenta.Setrange("Deduction Line", false);
            if AuxLinVenta.Find('-') then
                repeat
                    clear(QuantToInvo);

                    if ABS(AuxLinVenta."Quantity Shipped" - AuxLinVenta."Quantity Invoiced") < ABS(AuxLinVenta."Qty. to Invoice") then
                        QuantToInvo := AuxLinVenta."Quantity Shipped" - AuxLinVenta."Quantity Invoiced";

                    if QuantToInvo = 0 then QuantToInvo := AuxLinVenta."Qty. to Invoice";
                    Imp += round(QuantToInvo * AuxLinVenta."Unit Price", 0.01);
                    ImpIva += round((Imp + Imp * (AuxLinVenta."VAT %" + AuxLinVenta."EC %") / 100), 0.01);
                until (AuxLinVenta.Next() = 0);
            if ClaveRet."Calculation Type" = ClaveRet."Calculation Type"::Base then
                SalesLine.Validate(Quantity, Imp)
            else
                SalesLine.Validate(Quantity, ImpIva);
            SalesLine.Validate("Unit Price", -(ClaveRet."Retention %" / 100));
            SalesLine.Validate("Bill-to Customer No.", SalesHeader."Bill-to Customer No.");
            SalesLine."Currency Code" := SalesHeader."Currency Code";
            SalesLine.Validate("Job No.", '');
            SalesLine."Outstanding Quantity" := 0;
            SalesLine."Qty. to Ship" := 0;
            SalesLine."Qty. Shipped Not Invoiced" := SalesLine.Quantity;
            SalesLine."Quantity Shipped" := SalesLine.Quantity;
            SalesLine."Quantity Invoiced" := 0;
            SalesLine."Outstanding Qty. (Base)" := 0;
            SalesLine."Qty. to Invoice (Base)" := SalesLine."Quantity (Base)";
            SalesLine."Qty. to Ship (Base)" := 0;
            SalesLine."Qty. Shipped Not Invd. (Base)" := SalesLine."Quantity (Base)";
            SalesLine."Qty. Shipped (Base)" := SalesLine."Quantity (Base)";
            SalesLine."Qty. Invoiced (Base)" := 0;
            SalesLine."Outstanding Amount" := 0;
            SalesLine."Outstanding Amount (LCY)" := 0;
            SalesLine.Modify();

        end;
    end;
}
