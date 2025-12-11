namespace Excelia.IRPF;
using Microsoft.Sales.Document;
using Microsoft.Finance.Currency;
tableextension 86319 "Sales Line" extends "Sales Line"
{
    fields
    {
        field(86300; "Perception Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Perception Type';
        }
        field(86301; "Perception Key"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Customer));
            Caption = 'Perception Key';
        }
        field(86302; "Deduction Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Deduction Line';
        }
        field(86303; "Deduction Entry"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction Entry';
        }
        field(86304; "Retention Account"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Account';
            Editable = false;
        }
    }
    procedure CrearLinRetencion(LVenta: record "Sales Line")
    var
        ClaveRet: Record "EXC Perception Keys";
        AuxLinVenta: Record "Sales Line";
        NoLin: Integer;
        Imp: Decimal;
        ImpIva: Decimal;
        SeleccionRet: Integer;
        LinRetencion: Integer;
    begin
        SalesHeader2.Get("Document Type", "Document No.");
        GetSalesHeader();

        if ClaveRet.Get(SalesHeader2."Key Perception") then begin
            clear(SeleccionRet);
            clear(LinRetencion);

            AuxLinVenta.Reset();
            AuxLinVenta.Setrange("Document Type", SalesHeader2."Document Type");
            AuxLinVenta.Setrange("Document No.", SalesHeader2."No.");
            AuxLinVenta.Setrange("Deduction Line", true);
            if AuxLinVenta.FindLast() then begin
                SeleccionRet := STRMENU(TextRet0001, 2);
                LinRetencion := AuxLinVenta."Line No.";
            end;
            clear(LVenta);
            LVenta.INIT();
            LVenta."Document Type" := SalesHeader2."Document Type";
            LVenta.Validate("Document No.", SalesHeader2."No.");
            NoLin := TraerNoLinea() + 10000;
            LVenta.Validate("Line No.", NoLin);
            LVenta.Validate("Sell-to Customer No.", SalesHeader2."Sell-to Customer No.");
            LVenta.Type := LVenta.Type::"G/L Account";
            //TODO: ClaveRet.Testfield("Retention Acc.");
            LVenta.Validate("No.", ClaveRet."Retention Acc.");
            if SeleccionRet = 1 then begin
                AuxLinVenta.Reset();
                AuxLinVenta.Setrange("Document Type", SalesHeader2."Document Type");
                AuxLinVenta.Setrange("Document No.", SalesHeader2."No.");
                AuxLinVenta.Setrange("Deduction Line", false);
                if AuxLinVenta.Find('-') then
                    repeat
                        Imp += AuxLinVenta."Line Amount";
                        ImpIva += AuxLinVenta."Amount Including VAT";
                    until (AuxLinVenta.Next() = 0);
            end
            else begin

                AuxLinVenta.Reset();
                AuxLinVenta.Setrange("Document Type", SalesHeader2."Document Type");
                AuxLinVenta.Setrange("Document No.", SalesHeader2."No.");
                AuxLinVenta.SETFILTER("Line No.", '>%1', LinRetencion);
                if AuxLinVenta.Findset() then
                    repeat
                        Imp += AuxLinVenta."Line Amount";
                        ImpIva += AuxLinVenta."Amount Including VAT";
                    until AuxLinVenta.Next() = 0;
            end;
            if ClaveRet."Calculation Type" = ClaveRet."Calculation Type"::Base then
                LVenta.Validate(Quantity, Imp)
            else
                LVenta.Validate(Quantity, ImpIva);
            LVenta.Validate("Unit Price", -ClaveRet."Retention %" / 100);
            LVenta.Validate(LVenta."Bill-to Customer No.", SalesHeader2."Bill-to Customer No.");
            LVenta.Validate("Perception Type", SalesHeader2."Type Perception");
            LVenta.Validate("Perception Key", SalesHeader2."Key Perception");
            LVenta.Validate("Deduction Line", true);
            LVenta."Currency Code" := SalesHeader2."Currency Code";
            LVenta.Validate("Job No.", '');
            LVenta.Insert();
        end;
    end;

    procedure TraerNoLinea(): integer
    var
        AuxLinVenta: record "Sales Line";
    begin
        SalesHeader2.Get("Document Type", "Document No.");
        AuxLinVenta.Reset();
        AuxLinVenta.Setrange("Document Type", SalesHeader2."Document Type");
        AuxLinVenta.Setrange("Document No.", SalesHeader2."No.");
        if AuxLinVenta.FindLast() then
            exit(AuxLinVenta."Line No.")
        else
            exit(0);
    end;

    procedure CrearLinRetencion2(LVenta: record "Sales Line"; ImpRetenInterface: Decimal)
    var
        ClaveRet: Record "EXC Perception Keys";
        AuxLinVenta: Record "Sales Line";
        NoLin: Integer;
        SeleccionRet: Integer;
        LinRetencion: Integer;
    begin
        GetSalesHeader2();

        if ClaveRet.Get(SalesHeader2."Key Perception") then begin
            clear(SeleccionRet);
            clear(LinRetencion);

            AuxLinVenta.Reset();
            AuxLinVenta.Setrange("Document Type", SalesHeader2."Document Type");
            AuxLinVenta.Setrange("Document No.", SalesHeader2."No.");
            AuxLinVenta.Setrange("Deduction Line", true);
            if AuxLinVenta.FindLast() then begin
                SeleccionRet := STRMENU(TextRet0001, 2);
                LinRetencion := AuxLinVenta."Line No.";
            end;
            clear(LVenta);
            LVenta.INIT();
            LVenta."Document Type" := SalesHeader2."Document Type";
            LVenta.Validate("Document No.", SalesHeader2."No.");
            NoLin := TraerNoLinea() + 10000;
            LVenta.Validate("Line No.", NoLin);
            LVenta.Validate("Sell-to Customer No.", SalesHeader2."Sell-to Customer No.");
            LVenta.Type := LVenta.Type::"G/L Account";
            //TODO: ClaveRet.Testfield("Retention Acc.");
            LVenta.Validate("No.", ClaveRet."Retention Acc.");
            LVenta.Validate(Quantity, ImpRetenInterface / (-ClaveRet."Retention %" / 100));
            LVenta.Validate("Unit Price", -ClaveRet."Retention %" / 100);
            LVenta.Validate(LVenta."Bill-to Customer No.", SalesHeader2."Bill-to Customer No.");
            LVenta.Validate("Perception Type", SalesHeader2."Type Perception");
            LVenta.Validate("Perception Key", SalesHeader2."Key Perception");
            LVenta.Validate("Deduction Line", true);
            LVenta."Currency Code" := SalesHeader2."Currency Code";
            LVenta.Validate("Job No.", '');
            LVenta.Insert();
        end;
    end;

    var
        SalesHeader2: record "Sales Header";
        Currency2: record Currency;
        TextRet0001: Label 'Aplicar a todas las líneas,Aplicar desde la última línea de retención';

    procedure GetSalesHeader2()
    begin
        Testfield("Document No.");
        if ("Document Type" <> SalesHeader2."Document Type") OR ("Document No." <> SalesHeader2."No.") then begin
            SalesHeader2.Get("Document Type", "Document No.");
            if SalesHeader2."Currency Code" = '' then
                Currency2.InitRoundingPrecision()
            else begin
                SalesHeader2.Testfield("Currency Factor");
                Currency2.Get(SalesHeader2."Currency Code");
                Currency2.Testfield("Amount Rounding Precision");
            end;
        end;
    end;
}
