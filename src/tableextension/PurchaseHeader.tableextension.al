namespace Excelia.IRPF;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;
tableextension 86305 "Purchase Header" extends "Purchase Header"
{
    fields
    {
        Modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                Vendor: Record Vendor;
                PerceptionKey: Record "EXC Perception Keys";
            begin
                if Vendor.Get("Buy-from Vendor No.") then
                    if PerceptionKey.Get(Vendor."Perception Key") then "Posting No. Series" := PerceptionKey."IRPF Series No.";
            end;
        }
        field(86300; "Perception Type"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Perception Type';
            Description = 'Tipo de percepción asociado a este encabezado de compra.';
            ToolTip = 'Muestra el tipo de percepción asociado a este encabezado de compra.';
        }
        field(86301; "Perception Key"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Vendor));
            Caption = 'Perception Key';
            Description = 'Clave de percepción asociada a este encabezado de compra.';
            ToolTip = 'Muestra la clave de percepción asociada a este encabezado de compra.';

            trigger OnValidate()
            var
                PurchaseLine: Record "Purchase Line";
                PerceptionKey: record "EXC Perception Keys";
            begin
                if rec."Perception Key" <> '' then begin
                    PurchaseLine.Reset();
                    PurchaseLine.Setrange("Document Type", "Document Type");
                    PurchaseLine.Setrange("Document No.", "No.");
                    if PurchaseLine.Findset() then
                        repeat
                            PerceptionKey.Get(rec."Perception Key");
                            PurchaseLine."IRPF %" := PerceptionKey."Retention %";
                            PurchaseLine."Apply Retention" := true;
                            PurchaseLine.Modify();
                        until PurchaseLine.Next() = 0;
                end
                else begin
                    PurchaseLine.Reset();
                    PurchaseLine.Setrange("Document Type", "Document Type");
                    PurchaseLine.Setrange("Document No.", "No.");
                    if PurchaseLine.Findset() then
                        repeat
                            PurchaseLine."Apply Retention" := false;
                            PurchaseLine."IRPF %" := 0;
                            PurchaseLine.Modify();
                        until PurchaseLine.Next() = 0;
                end;
            end;
        }
        field(86302; "IRPF Amount"; Decimal)
        {
            editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line".Amount WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Apply Retention" = const(true)));
            Description = 'Importe total de IRPF asociado a este encabezado de compra.';
            ToolTip = 'Muestra el importe total de IRPF asociado a este encabezado de compra.';
        }
        field(86303; "VAT Amount incl. IRPF"; Decimal)
        {
            editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Apply Retention" = const(true)));
            Description = 'Importe total de IVA incluido IRPF asociado a este encabezado de compra.';
            ToolTip = 'Muestra el importe total de IVA incluido IRPF asociado a este encabezado de compra.';
        }
    }
    trigger OnAfterInsert()
    var
        Vendor: Record Vendor;
        locClavePer: Record "EXC Perception Keys";
    begin
        if Vendor.Get("Buy-from Vendor No.") then
            if locClavePer.Get(Vendor."Perception Key") then "Posting No. Series" := locClavePer."IRPF Series No.";

    end;

    var
        TextRet0001: Label 'Aplicar a todas las líneas,Aplicar desde la última línea de retención';

    procedure CreaLinRetencionPedido(PurchHeader: record "Purchase Header")
    var
        PerceptionKey: Record "EXC Perception Keys";
        PurchaseLine: Record "Purchase Line";
        NoLin: Integer;
        Imp: Decimal;
        ImpIva: Decimal;
        QuantToInvo: Decimal;
        SeleccionRet: Integer;
        LinRetencion: integer;
    begin

        if PerceptionKey.Get(PurchHeader."Perception Key") then begin
            clear(SeleccionRet);
            clear(LinRetencion);

            PurchaseLine.Reset();
            PurchaseLine.Setrange("Document Type", PurchHeader."Document Type");
            PurchaseLine.Setrange("Document No.", PurchHeader."No.");
            PurchaseLine.Setrange("Retention Line", true);
            if PurchaseLine.FindLast() then begin
                SeleccionRet := STRMENU(TextRet0001, 2);
                LinRetencion := PurchaseLine."Line No.";
            end;
            clear(PurchaseLine);
            PurchaseLine.Validate("Document Type", PurchHeader."Document Type");
            PurchaseLine.Validate("Document No.", PurchHeader."No.");
            NoLin := PurchaseLine.TraerNoLinea() + 10000;
            PurchaseLine.Validate("Line No.", NoLin);
            PurchaseLine.Validate("Buy-from Vendor No.", PurchHeader."Buy-from Vendor No.");
            PurchaseLine.Validate(Type, PurchaseLine.Type::"G/L Account");
            //TODO: PerceptionKey.Testfield("Retention Acc.");
            PurchaseLine.Validate("No.", PerceptionKey."Retention Acc.");
            PurchaseLine.Validate("Perception Type", PurchHeader."Perception Type");
            PurchaseLine.Validate("Perception Key", PurchHeader."Perception Key");
            PurchaseLine.Validate("Retention Line", true);
            if SeleccionRet = 0 then begin
                PurchaseLine.Reset();
                PurchaseLine.Setrange("Document Type", PurchHeader."Document Type");
                PurchaseLine.Setrange("Document No.", PurchHeader."No.");
                PurchaseLine.Setrange("Retention Line", false);
                if PurchaseLine.Find('-') then
                    repeat
                        clear(QuantToInvo);
                        if ABS(PurchaseLine."Quantity Received" - PurchaseLine."Quantity Invoiced") < ABS(PurchaseLine."Qty. to Invoice") then
                            QuantToInvo := PurchaseLine."Quantity Received" - PurchaseLine."Quantity Invoiced";

                        if QuantToInvo = 0 then QuantToInvo := PurchaseLine."Qty. to Invoice";
                        Imp += round(QuantToInvo * PurchaseLine."Direct Unit Cost", 0.01);
                        ImpIva += round((Imp + Imp * (PurchaseLine."VAT %" + PurchaseLine."EC %") / 100), 0.01);

                    until (PurchaseLine.Next() = 0);
            end
            else begin
                PurchaseLine.Reset();
                PurchaseLine.Setrange("Document Type", PurchHeader."Document Type");
                PurchaseLine.Setrange("Document No.", PurchHeader."No.");
                PurchaseLine.SETFILTER("Line No.", '>%1', LinRetencion);
                if PurchaseLine.Findset() then
                    repeat
                        clear(QuantToInvo);

                        if ABS(PurchaseLine."Quantity Received" - PurchaseLine."Quantity Invoiced") < ABS(PurchaseLine."Qty. to Invoice") then
                            QuantToInvo := PurchaseLine."Quantity Received" - PurchaseLine."Quantity Invoiced";

                        if QuantToInvo = 0 then QuantToInvo := PurchaseLine."Qty. to Invoice";
                        Imp += round(QuantToInvo * PurchaseLine."Direct Unit Cost", 0.01);
                        ImpIva += round((Imp + Imp * (PurchaseLine."VAT %" + PurchaseLine."EC %") / 100), 0.01);
                    until PurchaseLine.Next() = 0;
            end;
            if PerceptionKey."Calculation Type" = PerceptionKey."Calculation Type"::Base then
                PurchaseLine.Validate(Quantity, Imp)
            else
                PurchaseLine.Validate(Quantity, ImpIva);
            PurchaseLine.Validate("Direct Unit Cost", -(PerceptionKey."Retention %" / 100));
            Validate("Pay-to Vendor No.", PurchHeader."Pay-to Vendor No.");
            PurchaseLine."Currency Code" := PurchHeader."Currency Code";
            PurchaseLine.Validate("Job No.", '');
            PurchaseLine."Outstanding Quantity" := 0;
            PurchaseLine."Qty. to Receive" := 0;
            PurchaseLine."Qty. Rcd. Not Invoiced" := PurchaseLine.Quantity;
            PurchaseLine."Amt. Rcd. Not Invoiced" := PurchaseLine.Amount;
            PurchaseLine."Quantity Received" := PurchaseLine.Quantity;
            PurchaseLine."Quantity Invoiced" := 0;
            PurchaseLine."Outstanding Qty. (Base)" := 0;
            PurchaseLine."Qty. to Invoice (Base)" := PurchaseLine."Quantity (Base)";
            PurchaseLine."Qty. to Receive (Base)" := 0;
            PurchaseLine."Qty. Rcd. Not Invoiced (Base)" := PurchaseLine."Quantity (Base)";
            PurchaseLine."Qty. Received (Base)" := PurchaseLine."Quantity (Base)";
            PurchaseLine."Qty. Invoiced (Base)" := 0;
            PurchaseLine."Outstanding Amount" := 0;
            PurchaseLine."Outstanding Amount (LCY)" := 0;
            Insert(true);
        end;
    end;
}
