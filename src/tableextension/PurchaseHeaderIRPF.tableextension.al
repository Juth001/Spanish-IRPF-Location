namespace ScriptumVita.IRPF;
tableextension 86305 "Purchase Header_IRPF" extends "Purchase Header"
{
    fields
    {
        //REQ_FIN011
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                locVendor: Record Vendor;
                locClavePer: Record "IND Perception Keys (IRPF)";
            begin
                IF locVendor.get("Buy-from Vendor No.") THEN BEGIN
                    IF locClavePer.GET(locVendor."Clave Percepción") THEN "Posting No. Series" := locClavePer."No. serie IRPF";
                END;
            end;
        }
        field(60500; "Tipo Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Type (IRPF)"."Código";
            //CaptionML = ENU = 'Perception Type', ESP = 'Tipo Percepción';
            Caption = 'Tipo Percepción'; //'Perception Type';
        }
        field(60501; "Clave Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Keys (IRPF)"."Código" WHERE("Cli/Prov" = CONST(Proveedor));
            Caption = 'Clave percepción'; //'Perception Key';

            trigger OnValidate()
            var
                reclincompra: Record "Purchase Line";
                recClavePercepcion: record "IND Perception Keys (IRPF)";
            begin
                if rec."Clave Percepción" <> '' then begin
                    reclincompra.reset;
                    reclincompra.setrange("Document Type", "Document Type");
                    reclincompra.setrange("Document No.", "No.");
                    if reclincompra.findset then
                        repeat
                            recClavePercepcion.get(rec."Clave Percepción");
                            Reclincompra."Porc.IRPF" := recClavePercepcion."% Retención";
                            Reclincompra."Aplica Retencion" := true;
                            Reclincompra.modify;
                        until reclincompra.Next() = 0;
                end
                else begin
                    reclincompra.reset;
                    reclincompra.setrange("Document Type", "Document Type");
                    reclincompra.setrange("Document No.", "No.");
                    if reclincompra.findset then
                        repeat
                            Reclincompra."Aplica Retencion" := false;
                            Reclincompra."Porc.IRPF" := 0;
                            Reclincompra.modify;
                        until reclincompra.Next() = 0;
                end;
            end;
        }
        field(60502; "Importe IRPF"; Decimal)
        {
            editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line".Amount WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Aplica Retencion" = const(true)));
        }
        field(60503; "Importe IVA incl.IRPF"; Decimal)
        {
            editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Aplica Retencion" = const(true)));
        }
    }
    //REQ_FIN011
    trigger OnAfterInsert()
    var
        locVendor: Record Vendor;
        locClavePer: Record "IND Perception Keys (IRPF)";
    begin
        IF locVendor.get("Buy-from Vendor No.") THEN BEGIN
            IF locClavePer.GET(locVendor."Clave Percepción") THEN "Posting No. Series" := locClavePer."No. serie IRPF";
        END;
    end;

    var
        TextRet0001: Label 'Aplicar a todas las líneas,Aplicar desde la última línea de retención';

    procedure CreaLinRetencionPedido(PurchHeader: record "Purchase Header")
    var
        ClaveRet: Record "IND Perception Keys (IRPF)";
        GrContableProv: Record "Vendor Posting Group";
        NoLin: Integer;
        Imp: Decimal;
        Lcompra2l: Record "Purchase Line";
        ImpIva: Decimal;
        LCompra: Record "Purchase Line";
        QuantToInvo: Decimal;
        Ventana: Dialog;
        SeleccionRet: Integer;
        LinRetencion: integer;
    begin
        //++ OT2-051963
        //Esta función se encargar  de generar automaticamente la l¡nea de la retención cdo es un pedido y se factura
        // WITH LCompra DO BEGIN
        //     //Cogemos el registro de la clave de retención.
        //     IF ClaveRet.GET(PurchHeader."Clave Percepción") THEN BEGIN
        //         CLEAR(SeleccionRet);
        //         CLEAR(LinRetencion);
        //         //Compruebo si ya hay alguna l¡nea de retención
        //         Lcompra2l.RESET;
        //         Lcompra2l.SETRANGE("Document Type", PurchHeader."Document Type");
        //         Lcompra2l.SETRANGE("Document No.", PurchHeader."No.");
        //         Lcompra2l.SETRANGE("Lín. retención", TRUE);
        //         IF Lcompra2l.FINDLAST THEN BEGIN
        //             SeleccionRet := STRMENU(TextRet0001, 2);
        //             LinRetencion := Lcompra2l."Line No.";
        //         END;
        //         CLEAR(LCompra);
        //         VALIDATE("Document Type", PurchHeader."Document Type");
        //         VALIDATE("Document No.", PurchHeader."No.");
        //         NoLin := TraerNoLinea + 10000;
        //         VALIDATE("Line No.", NoLin);
        //         VALIDATE("Buy-from Vendor No.", PurchHeader."Buy-from Vendor No.");
        //         VALIDATE(Type, Type::"G/L Account");
        //         ClaveRet.TESTFIELD("Cta. retención");
        //         VALIDATE("No.", ClaveRet."Cta. retención");
        //         VALIDATE("Tipo Percepción", PurchHeader."Tipo Percepción");
        //         VALIDATE("Clave Percepción", PurchHeader."Clave Percepción");
        //         VALIDATE("Lín. retención", TRUE);
        //         IF SeleccionRet = 0 THEN BEGIN
        //             //La retencion se aplica a todas las lineas
        //             Lcompra2l.RESET;
        //             Lcompra2l.SETRANGE("Document Type", PurchHeader."Document Type");
        //             Lcompra2l.SETRANGE("Document No.", PurchHeader."No.");
        //             Lcompra2l.SETRANGE("Lín. retención", FALSE);
        //             IF Lcompra2l.FIND('-') THEN
        //                 REPEAT
        //                     CLEAR(QuantToInvo);
        //                     //si hace este codigo no rellena la cantidad
        //                     IF ABS(Lcompra2l."Quantity Received" - Lcompra2l."Quantity Invoiced") < ABS(Lcompra2l."Qty. to Invoice") THEN BEGIN
        //                         QuantToInvo := Lcompra2l."Quantity Received" - Lcompra2l."Quantity Invoiced";
        //                     END;
        //                     IF QuantToInvo = 0 THEN
        //                         QuantToInvo := Lcompra2l."Qty. to Invoice";
        //                     Imp += ROUND(QuantToInvo * Lcompra2l."Direct Unit Cost", 0.01);
        //                     ImpIva += ROUND((Imp + Imp * (Lcompra2l."VAT %" + Lcompra2l."EC %") / 100), 0.01);
        //                 UNTIL (Lcompra2l.NEXT = 0);
        //         END
        //         ELSE BEGIN
        //             //La retencion se aplica a las l¡neas a partir de la £ltima l¡nea de retencion
        //             Lcompra2l.RESET;
        //             Lcompra2l.SETRANGE("Document Type", PurchHeader."Document Type");
        //             Lcompra2l.SETRANGE("Document No.", PurchHeader."No.");
        //             Lcompra2l.SETFILTER("Line No.", '>%1', LinRetencion);
        //             IF Lcompra2l.FINDSET THEN
        //                 REPEAT
        //                     CLEAR(QuantToInvo);
        //                     //si hace este codigo no rellena la cantidad
        //                     IF ABS(Lcompra2l."Quantity Received" - Lcompra2l."Quantity Invoiced") < ABS(Lcompra2l."Qty. to Invoice") THEN BEGIN
        //                         QuantToInvo := Lcompra2l."Quantity Received" - Lcompra2l."Quantity Invoiced";
        //                     END;
        //                     IF QuantToInvo = 0 THEN
        //                         QuantToInvo := Lcompra2l."Qty. to Invoice";
        //                     Imp += ROUND(QuantToInvo * Lcompra2l."Direct Unit Cost", 0.01);
        //                     ImpIva += ROUND((Imp + Imp * (Lcompra2l."VAT %" + Lcompra2l."EC %") / 100), 0.01);
        //                 UNTIL Lcompra2l.NEXT = 0;
        //         END;
        //         IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
        //             VALIDATE(Quantity, Imp)
        //         ELSE
        //             VALIDATE(Quantity, ImpIva);
        //         VALIDATE("Direct Unit Cost", -(ClaveRet."% Retención" / 100));
        //         VALIDATE("Pay-to Vendor No.", PurchHeader."Pay-to Vendor No.");
        //         "Currency Code" := PurchHeader."Currency Code";
        //         VALIDATE("Job No.", '');
        //         LCompra."Outstanding Quantity" := 0;
        //         LCompra."Qty. to Receive" := 0;
        //         LCompra."Qty. Rcd. Not Invoiced" := LCompra.Quantity;
        //         LCompra."Amt. Rcd. Not Invoiced" := LCompra.Amount;
        //         LCompra."Quantity Received" := LCompra.Quantity;
        //         LCompra."Quantity Invoiced" := 0;
        //         LCompra."Outstanding Qty. (Base)" := 0;
        //         LCompra."Qty. to Invoice (Base)" := LCompra."Quantity (Base)";
        //         LCompra."Qty. to Receive (Base)" := 0;
        //         LCompra."Qty. Rcd. Not Invoiced (Base)" := LCompra."Quantity (Base)";
        //         LCompra."Qty. Received (Base)" := LCompra."Quantity (Base)";
        //         LCompra."Qty. Invoiced (Base)" := 0;
        //         LCompra."Outstanding Amount" := 0;
        //         LCompra."Outstanding Amount (LCY)" := 0;
        //         INSERT(TRUE);
        //     END;
        // END;
        //Cogemos el registro de la clave de retención.
        IF ClaveRet.GET(PurchHeader."Clave Percepción") THEN BEGIN
            CLEAR(SeleccionRet);
            CLEAR(LinRetencion);
            //Compruebo si ya hay alguna l¡nea de retención
            Lcompra2l.RESET;
            Lcompra2l.SETRANGE("Document Type", PurchHeader."Document Type");
            Lcompra2l.SETRANGE("Document No.", PurchHeader."No.");
            Lcompra2l.SETRANGE("Lín. retención", TRUE);
            IF Lcompra2l.FINDLAST THEN BEGIN
                SeleccionRet := STRMENU(TextRet0001, 2);
                LinRetencion := Lcompra2l."Line No.";
            END;
            CLEAR(LCompra);
            LCompra.VALIDATE("Document Type", PurchHeader."Document Type");
            LCompra.VALIDATE("Document No.", PurchHeader."No.");
            NoLin := LCompra.TraerNoLinea + 10000;
            LCompra.VALIDATE("Line No.", NoLin);
            LCompra.VALIDATE("Buy-from Vendor No.", PurchHeader."Buy-from Vendor No.");
            LCompra.VALIDATE(Type, LCompra.Type::"G/L Account");
            ClaveRet.TESTFIELD("Cta. retención");
            LCompra.VALIDATE("No.", ClaveRet."Cta. retención");
            LCompra.VALIDATE("Tipo Percepción", PurchHeader."Tipo Percepción");
            LCompra.VALIDATE("Clave Percepción", PurchHeader."Clave Percepción");
            LCompra.VALIDATE("Lín. retención", TRUE);
            IF SeleccionRet = 0 THEN BEGIN
                //La retencion se aplica a todas las lineas
                Lcompra2l.RESET;
                Lcompra2l.SETRANGE("Document Type", PurchHeader."Document Type");
                Lcompra2l.SETRANGE("Document No.", PurchHeader."No.");
                Lcompra2l.SETRANGE("Lín. retención", FALSE);
                IF Lcompra2l.FIND('-') THEN
                    REPEAT
                        CLEAR(QuantToInvo);
                        //si hace este codigo no rellena la cantidad
                        IF ABS(Lcompra2l."Quantity Received" - Lcompra2l."Quantity Invoiced") < ABS(Lcompra2l."Qty. to Invoice") THEN BEGIN
                            QuantToInvo := Lcompra2l."Quantity Received" - Lcompra2l."Quantity Invoiced";
                        END;
                        IF QuantToInvo = 0 THEN QuantToInvo := Lcompra2l."Qty. to Invoice";
                        Imp += ROUND(QuantToInvo * Lcompra2l."Direct Unit Cost", 0.01);
                        ImpIva += ROUND((Imp + Imp * (Lcompra2l."VAT %" + Lcompra2l."EC %") / 100), 0.01);
                    UNTIL (Lcompra2l.NEXT = 0);
            END
            ELSE BEGIN
                //La retencion se aplica a las l¡neas a partir de la £ltima l¡nea de retencion
                Lcompra2l.RESET;
                Lcompra2l.SETRANGE("Document Type", PurchHeader."Document Type");
                Lcompra2l.SETRANGE("Document No.", PurchHeader."No.");
                Lcompra2l.SETFILTER("Line No.", '>%1', LinRetencion);
                IF Lcompra2l.FINDSET THEN
                    REPEAT
                        CLEAR(QuantToInvo);
                        //si hace este codigo no rellena la cantidad
                        IF ABS(Lcompra2l."Quantity Received" - Lcompra2l."Quantity Invoiced") < ABS(Lcompra2l."Qty. to Invoice") THEN BEGIN
                            QuantToInvo := Lcompra2l."Quantity Received" - Lcompra2l."Quantity Invoiced";
                        END;
                        IF QuantToInvo = 0 THEN QuantToInvo := Lcompra2l."Qty. to Invoice";
                        Imp += ROUND(QuantToInvo * Lcompra2l."Direct Unit Cost", 0.01);
                        ImpIva += ROUND((Imp + Imp * (Lcompra2l."VAT %" + Lcompra2l."EC %") / 100), 0.01);
                    UNTIL Lcompra2l.NEXT = 0;
            END;
            IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
                LCompra.VALIDATE(Quantity, Imp)
            ELSE
                LCompra.VALIDATE(Quantity, ImpIva);
            LCompra.VALIDATE("Direct Unit Cost", -(ClaveRet."% Retención" / 100));
            VALIDATE("Pay-to Vendor No.", PurchHeader."Pay-to Vendor No.");
            LCompra."Currency Code" := PurchHeader."Currency Code";
            LCompra.VALIDATE("Job No.", '');
            LCompra."Outstanding Quantity" := 0;
            LCompra."Qty. to Receive" := 0;
            LCompra."Qty. Rcd. Not Invoiced" := LCompra.Quantity;
            LCompra."Amt. Rcd. Not Invoiced" := LCompra.Amount;
            LCompra."Quantity Received" := LCompra.Quantity;
            LCompra."Quantity Invoiced" := 0;
            LCompra."Outstanding Qty. (Base)" := 0;
            LCompra."Qty. to Invoice (Base)" := LCompra."Quantity (Base)";
            LCompra."Qty. to Receive (Base)" := 0;
            LCompra."Qty. Rcd. Not Invoiced (Base)" := LCompra."Quantity (Base)";
            LCompra."Qty. Received (Base)" := LCompra."Quantity (Base)";
            LCompra."Qty. Invoiced (Base)" := 0;
            LCompra."Outstanding Amount" := 0;
            LCompra."Outstanding Amount (LCY)" := 0;
            INSERT(TRUE);
        END;
    end;
    //-- OT2-051963
}
