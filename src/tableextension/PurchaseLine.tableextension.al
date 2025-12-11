namespace Excelia.IRPF;
using Microsoft.Purchases.Document;
tableextension 86306 "Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(86300; "Retention Entry"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Entry';
            Description = 'Número de movimiento de retención asociado a esta línea de compra.';
            ToolTip = 'Muestra el número de movimiento de retención asociado a esta línea de compra.';
        }
        field(86301; "Perception Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Perception Type';
            Description = 'Tipo de percepción asociado a esta línea de compra.';
            ToolTip = 'Muestra el tipo de percepción asociado a esta línea de compra.';
        }
        field(86302; "Perception key"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Vendor));
            Caption = 'Perception key';
            Description = 'Clave de percepción asociada a esta línea de compra.';
            ToolTip = 'Muestra la clave de percepción asociada a esta línea de compra.';
        }
        field(86303; "Retention Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Retention Line';
            Description = 'Indica si esta línea de compra es una línea de retención.';
            ToolTip = 'Indica si esta línea de compra es una línea de retención.';
        }
        field(86304; "IRPF %"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'IRPF %';
            Description = 'Porcentaje de retención IRPF aplicado a esta línea de compra.';
            ToolTip = 'Muestra el porcentaje de retención IRPF aplicado a esta línea de compra.';
        }
        field(86305; "Apply Retention"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Apply Retention';
            Description = 'Generar automáticamente la línea de retención para esta línea de compra.';
            ToolTip = 'Indica si se debe generar automáticamente la línea de retención para esta línea de compra.';
        }


        Modify("No.")
        {
            trigger OnAfterValidate()
            var
                PurchaseHeader: Record "Purchase Header";
                RecClavePercepcion: Record "EXC Perception Keys";
            begin
                PurchaseHeader.Get(rec."Document Type", rec."Document No.");
                if PurchaseHeader."Perception Key" <> '' then begin
                    "Apply Retention" := true;
                    RecClavePercepcion.Get(PurchaseHeader."Perception Key");
                    "IRPF %" := RecClavePercepcion."Retention %";
                end;
            end;
        }
    }
    trigger OnAfterInsert()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: record "Purchase Line";
        PerceptionKey: Record "EXC Perception Keys";
    begin

        PurchaseHeader.Get(rec."Document Type", rec."Document No.");
        if PurchaseHeader."Perception Key" <> '' then begin
            PurchaseLine.Get(rec."Document Type", rec."Document No.", rec."Line No.");
            PurchaseLine."Apply Retention" := true;
            PerceptionKey.Get(PurchaseHeader."Perception Key");
            PurchaseLine."IRPF %" := PerceptionKey."Retention %";
            PurchaseLine.Modify();
        end;

    end;

    var
        PurchHeader2: record "Purchase Header";
        TextRet0001: Label 'Aplicar a todas las líneas,Aplicar desde la última línea de retención';


    procedure CreateAutoRetentionLine(LCompra: record "Purchase Line")
    var
        ClaveRet: Record "EXC Perception Keys";
        AuxLinCompra: Record "Purchase Line";
        NoLin: Integer;
        Imp: Decimal;
        ImpIva: Decimal;
        SeleccionRet: Integer;
        LinRetencion: Integer;
    begin
        PurchHeader2.Get("Document Type", "Document No.");
        if ClaveRet.Get(PurchHeader2."Perception Key") then begin
            clear(SeleccionRet);
            clear(LinRetencion);
            AuxLinCompra.Reset();
            AuxLinCompra.Setrange("Document Type", PurchHeader2."Document Type");
            AuxLinCompra.Setrange("Document No.", PurchHeader2."No.");
            AuxLinCompra.Setrange("Retention Line", true);
            if AuxLinCompra.FindLast() then begin
                SeleccionRet := STRMENU(TextRet0001, 2);
                LinRetencion := AuxLinCompra."Line No.";
            end;
            clear(LCompra);
            LCompra.INIT();
            LCompra."Document Type" := PurchHeader2."Document Type";
            LCompra.Validate("Document No.", PurchHeader2."No.");
            NoLin := TraerNoLinea() + 10000;
            LCompra.Validate("Line No.", NoLin);
            LCompra.Validate("Buy-from Vendor No.", PurchHeader2."Buy-from Vendor No.");
            LCompra.Type := LCompra.Type::"G/L Account";
            ClaveRet.Testfield("Retention Acc.");
            LCompra."Retention Line" := true;
            LCompra.Validate("No.", ClaveRet."Retention Acc.");
            if SeleccionRet = 1 then begin
                AuxLinCompra.Reset();
                AuxLinCompra.Setrange("Document Type", PurchHeader2."Document Type");
                AuxLinCompra.Setrange("Document No.", PurchHeader2."No.");
                AuxLinCompra.Setrange("Retention Line", false);
                if AuxLinCompra.Find('-') then
                    repeat
                        Imp += AuxLinCompra."VAT Base Amount";

                        ImpIva += AuxLinCompra."Amount Including VAT";
                    until (AuxLinCompra.Next() = 0);
            end
            else begin

                AuxLinCompra.Reset();
                AuxLinCompra.Setrange("Document Type", PurchHeader2."Document Type");
                AuxLinCompra.Setrange("Document No.", PurchHeader2."No.");
                AuxLinCompra.SETFILTER("Line No.", '>%1', LinRetencion);
                if AuxLinCompra.Findset() then
                    repeat
                        Imp += AuxLinCompra."VAT Base Amount";
                        ImpIva += AuxLinCompra."Amount Including VAT";
                    until AuxLinCompra.Next() = 0;
            end;
            if ClaveRet."Calculation Type" = ClaveRet."Calculation Type"::Base then
                LCompra.Validate(Quantity, Imp)
            else
                LCompra.Validate(Quantity, ImpIva);
            LCompra.Validate("Direct Unit Cost", -(ClaveRet."Retention %" / 100));
            LCompra.Validate("Pay-to Vendor No.", PurchHeader2."Pay-to Vendor No.");
            LCompra.Validate("Perception Type", PurchHeader2."Perception Type");
            LCompra.Validate("Perception key", PurchHeader2."Perception Key");
            LCompra.Validate("Retention Line", true);
            LCompra."Currency Code" := PurchHeader2."Currency Code";
            LCompra.Validate("Job No.", '');
            LCompra.Insert();
        end;

    end;

    procedure TraerNoLinea(): integer
    var
        AuxLinCompra: record "Purchase Line";
    begin
        PurchHeader2.Get("Document Type", "Document No.");
        AuxLinCompra.Setrange("Document Type", PurchHeader2."Document Type");
        AuxLinCompra.Setrange("Document No.", PurchHeader2."No.");
        if AuxLinCompra.FindLast() then
            exit(AuxLinCompra."Line No.")
        else
            exit(0);
    end;

    procedure CrearAutoLinRetencion2(LCompra: record "Purchase Line"; ImpRetenInterface: Decimal)
    var
        ClaveRet: Record "EXC Perception Keys";
        AuxLinCompra: Record "Purchase Line";
        NoLin: Integer;
        SeleccionRet: Integer;
        LinRetencion: Integer;
    begin
        PurchHeader2.Get("Document Type", "Document No.");

        if ClaveRet.Get(PurchHeader2."Perception Key") then begin
            clear(SeleccionRet);
            clear(LinRetencion);

            AuxLinCompra.Reset();
            AuxLinCompra.Setrange("Document Type", PurchHeader2."Document Type");
            AuxLinCompra.Setrange("Document No.", PurchHeader2."No.");
            AuxLinCompra.Setrange("Retention Line", true);
            if AuxLinCompra.FindLast() then begin
                SeleccionRet := STRMENU(TextRet0001, 2);
                LinRetencion := AuxLinCompra."Line No.";
            end;
            clear(LCompra);
            LCompra.INIT();
            LCompra."Document Type" := PurchHeader2."Document Type";
            LCompra.Validate("Document No.", PurchHeader2."No.");
            NoLin := TraerNoLinea() + 10000;
            LCompra.Validate("Line No.", NoLin);
            LCompra.Validate("Buy-from Vendor No.", PurchHeader2."Buy-from Vendor No.");
            LCompra.Type := LCompra.Type::"G/L Account";
            ClaveRet.Testfield("Retention Acc.");
            LCompra."Retention Line" := true;
            LCompra.Validate("No.", ClaveRet."Retention Acc.");
            LCompra.Validate(Quantity, ImpRetenInterface);
            Validate("Direct Unit Cost", -(ClaveRet."Retention %" / 100));
            LCompra.Validate("Pay-to Vendor No.", PurchHeader2."Pay-to Vendor No.");
            LCompra.Validate("Perception Type", PurchHeader2."Perception Type");
            LCompra.Validate("Perception key", PurchHeader2."Perception Key");
            LCompra.Validate("Retention Line", true);
            LCompra."Currency Code" := PurchHeader2."Currency Code";
            LCompra.Validate("Job No.", '');
            LCompra.Insert();
        end;
    end;

    procedure CrearAutoLinRetencionAlRegistrar(LCompra: record "Purchase Line")
    var
        ClaveRet: Record "EXC Perception Keys";
        LPurchHeader2: record "Purchase Header";
        AuxLinCompra: Record "Purchase Line";
        PurchLine: record "Purchase Line";
        NoLin: Integer;
        Imp: Decimal;
        ImpIva: Decimal;
        SeleccionRet: Integer;
        LinRetencion: Integer;
        DecImporteConDescuento: decimal;
    begin

        DecImporteConDescuento := 0;
        LPurchHeader2.Get("Document Type", "Document No.");
        PurchLine.Setrange("Document Type", LPurchHeader2."Document Type");
        PurchLine.Setrange("Document No.", LPurchHeader2."No.");
        PurchLine.SETFILTER(Type, '>0');
        PurchLine.SETFILTER(Quantity, '<>0');
        if ClaveRet.Get(LPurchHeader2."Perception Key") then
            if claveret."Retention %" <> 0 then begin
                clear(SeleccionRet);
                clear(LinRetencion);
                AuxLinCompra.Reset();
                AuxLinCompra.Setrange("Document Type", LPurchHeader2."Document Type");
                AuxLinCompra.Setrange("Document No.", LPurchHeader2."No.");
                AuxLinCompra.Setrange("Retention Line", true);
                if auxlincompra.isempty then begin
                    clear(LCompra);
                    LCompra.INIT();
                    LCompra."Document Type" := LPurchHeader2."Document Type";
                    LCompra.Validate("Document No.", LPurchHeader2."No.");
                    NoLin := TraerNoLinea() + 10000;
                    LCompra.Validate("Line No.", NoLin);
                    LCompra.Validate("Buy-from Vendor No.", LPurchHeader2."Buy-from Vendor No.");
                    LCompra.Type := LCompra.Type::"G/L Account";
                    ClaveRet.Testfield("Retention Acc.");
                    LCompra."Retention Line" := true;
                    LCompra.Validate("No.", ClaveRet."Retention Acc.");
                    AuxLinCompra.Reset();
                    AuxLinCompra.Setrange("Document Type", LPurchHeader2."Document Type");
                    AuxLinCompra.Setrange("Document No.", LPurchHeader2."No.");
                    AuxLinCompra.Setrange("Apply Retention", true);
                    AuxLinCompra.Setrange("Retention Line", false);
                    if AuxLinCompra.Find('-') then
                        repeat
                            if LPurchHeader2."Payment Discount %" <> 0 then begin
                                DecImporteConDescuento := (auxlincompra."Line Amount" - (auxlincompra."Line Amount" * LPurchHeader2."Payment Discount %" / 100));
                                Imp += DecImporteConDescuento;
                            end
                            else
                                Imp += auxlincompra."VAT Base Amount";

                            ImpIva += AuxLinCompra."Amount Including VAT";
                        until (AuxLinCompra.Next() = 0);

                    if ClaveRet."Calculation Type" = ClaveRet."Calculation Type"::Base then
                        LCompra.Validate(Quantity, round(Imp, 0.01))
                    else
                        LCompra.Validate(Quantity, ImpIva);
                    LCompra.Validate("Direct Unit Cost", -(ClaveRet."Retention %" / 100));
                    LCompra.Validate("Pay-to Vendor No.", LPurchHeader2."Pay-to Vendor No.");
                    LCompra.Validate("Perception Type", LPurchHeader2."Perception Type");
                    LCompra.Validate("Perception key", LPurchHeader2."Perception Key");
                    LCompra.Validate("Retention Line", true);
                    LCompra."Currency Code" := LPurchHeader2."Currency Code";
                    LCompra.Validate("Job No.", '');
                    LCompra.Insert();
                end;
            end;
    end;

    procedure CrearAutoLinRetencionAlRegistrarManual(LCompra: record "Purchase Line")
    var
        ClaveRet: Record "EXC Perception Keys";
        AuxLinCompra: Record "Purchase Line";
        LPurchHeader2: record "Purchase Header";
        NoLin: Integer;
        Imp: Decimal;
        ImpIva: Decimal;
        SeleccionRet: Integer;
        LinRetencion: Integer;
        DecImporteConDescuento: decimal;
    begin
        PurchHeader2.Get("Document Type", "Document No.");

        if ClaveRet.Get(PurchHeader2."Perception Key") then
            if claveret."Retention %" <> 0 then begin
                clear(SeleccionRet);
                clear(LinRetencion);
                AuxLinCompra.Reset();
                AuxLinCompra.Setrange("Document Type", PurchHeader2."Document Type");
                AuxLinCompra.Setrange("Document No.", PurchHeader2."No.");
                AuxLinCompra.Setrange("Retention Line", true);
                if auxlincompra.isempty then begin
                    clear(LCompra);
                    LCompra.INIT();
                    LCompra."Document Type" := PurchHeader2."Document Type";
                    LCompra.Validate("Document No.", PurchHeader2."No.");
                    NoLin := TraerNoLinea() + 10000;
                    LCompra.Validate("Line No.", NoLin);
                    LCompra.Validate("Buy-from Vendor No.", PurchHeader2."Buy-from Vendor No.");
                    LCompra.Type := Type::"G/L Account";
                    ClaveRet.Testfield("Retention Acc.");
                    LCompra."Retention Line" := true;
                    LCompra.Validate("No.", ClaveRet."Retention Acc.");
                    AuxLinCompra.Reset();
                    AuxLinCompra.Setrange("Document Type", PurchHeader2."Document Type");
                    AuxLinCompra.Setrange("Document No.", PurchHeader2."No.");
                    AuxLinCompra.Setrange("Apply Retention", true);
                    AuxLinCompra.Setrange("Retention Line", false);
                    if AuxLinCompra.Find('-') then
                        repeat
                            if LPurchHeader2."Payment Discount %" <> 0 then begin
                                DecImporteConDescuento := (auxlincompra."Line Amount" - (auxlincompra."Line Amount" * LPurchHeader2."Payment Discount %" / 100));
                                Imp += DecImporteConDescuento;
                            end
                            else
                                Imp += AuxLinCompra."VAT Base Amount";
                            ImpIva += AuxLinCompra."Amount Including VAT";
                        until (AuxLinCompra.Next() = 0);
                    if ClaveRet."Calculation Type" = ClaveRet."Calculation Type"::Base then
                        LCompra.Validate(Quantity, round(Imp, 0.01))
                    else
                        LCompra.Validate(Quantity, ImpIva);
                    LCompra.Validate("Direct Unit Cost", -(ClaveRet."Retention %" / 100));
                    LCompra.Validate("Pay-to Vendor No.", PurchHeader2."Pay-to Vendor No.");
                    LCompra.Validate("Perception Type", PurchHeader2."Perception Type");
                    LCompra.Validate("Perception key", PurchHeader2."Perception Key");
                    LCompra.Validate("Retention Line", true);
                    "Currency Code" := PurchHeader2."Currency Code";
                    LCompra.Validate("Job No.", '');
                    LCompra.Insert();
                end;
            end;
    end;
}
