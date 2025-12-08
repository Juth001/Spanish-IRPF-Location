namespace ScriptumVita.IRPF;
tableextension 86306 "Purchase Line_IRPF" extends "Purchase Line"
{
    fields
    {
        field(60500; "Mov. retención"; Integer)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Deduction Entry', ESP = 'Mov. retención';
            Caption = 'Mov. retención'; //'Deduction Entry';
        }
        field(60501; "Tipo Percepción"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Type (IRPF)"."Código";
            //CaptionML = ENU = 'Perception Type', ESP = 'Tipo Percepción';
            Caption = 'Tipo Percepción'; //'Perception Type';
        }
        field(60502; "Clave Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Keys (IRPF)"."Código" WHERE("Cli/Prov" = CONST(Proveedor));
            //CaptionML = ENU = 'Perception key', ESP = 'Clave Percepción';
            Caption = 'Clave Percepción'; //'Perception key';
        }
        field(60503; "Lín. retención"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            //CaptionML = ENU = 'Deduction Line', ESP = 'Lín. retención';
            Caption = 'Lín. retención'; //'Deduction Line';
        }
        field(60505; "Porc.IRPF"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = '% IRPF';
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                RecPurchaseHeader: Record "Purchase Header";
                RecClavePercepcion: Record "IND Perception Keys (IRPF)";
            begin
                //IRPF 30122020>>
                RecPurchaseHeader.get(rec."Document Type", rec."Document No.");
                if RecPurchaseHeader."Clave Percepción" <> '' then begin
                    "Aplica Retencion" := true;
                    RecClavePercepcion.get(RecPurchaseHeader."Clave Percepción");
                    "Porc.IRPF" := RecClavePercepcion."% Retención";
                end;
                //IRPF 30122020<<
            end;
        }
    }
    trigger OnAfterInsert()
    var
        RecPurchaseHeader: Record "Purchase Header";
        Reclincompra: record "Purchase Line";
        RecClavePercepcion: Record "IND Perception Keys (IRPF)";
    begin
        //IRPF 05122020>>
        RecPurchaseHeader.get(rec."Document Type", rec."Document No.");
        if RecPurchaseHeader."Clave Percepción" <> '' then begin
            Reclincompra.get(rec."Document Type", rec."Document No.", rec."Line No.");
            Reclincompra."Aplica Retencion" := true;
            RecClavePercepcion.get(RecPurchaseHeader."Clave Percepción");
            Reclincompra."Porc.IRPF" := RecClavePercepcion."% Retención";
            Reclincompra.modify;
        end;
        //IRPF 05122020<<
    end;

    var
        TextRet0001: Label 'Aplicar a todas las líneas,Aplicar desde la última línea de retención';
        PurchHeader2: record "Purchase Header";

    procedure CrearAutoLinRetencion(LCompra: record "Purchase Line")
    var
        ClaveRet: Record "IND Perception Keys (IRPF)";
        GrContableProv: Record "Vendor Posting Group";
        NoLin: Integer;
        Imp: Decimal;
        AuxLinCompra: Record "Purchase Line";
        ImpIva: Decimal;
        Ventana: Dialog;
        SeleccionRet: Integer;
        LinRetencion: Integer;
    begin
        //Esta función se encargar  de generar automaticamente la línea de la retención.
        PurchHeader2.GET("Document Type", "Document No.");
        //TECNOCOM - GFM - 141216 - OT2-032966
        //CodRefCatastral := ControlRefCatastral;
        //FIN TECNOCOM - GFM - 141216 - OT2-032966
        //++ OT2-051963
        //         WITH LCompra DO BEGIN
        //             //Cogemos el registro de la clave de retención.
        //             IF ClaveRet.GET(PurchHeader2."Clave Percepción") THEN BEGIN
        //                 CLEAR(SeleccionRet);
        //                 CLEAR(LinRetencion);
        //                 //Compruebo si ya hay alguna línea de retención
        //                 AuxLinCompra.RESET;
        //                 AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
        //                 AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
        //                 AuxLinCompra.SETRANGE("Lín. retención", TRUE);
        //                 IF AuxLinCompra.FINDLAST THEN BEGIN
        //                     SeleccionRet := STRMENU(TextRet0001, 2);
        //                     LinRetencion := AuxLinCompra."Line No.";
        //                 END;
        //                 CLEAR(LCompra);
        //                 INIT;
        //                 "Document Type" := PurchHeader2."Document Type";
        //                 VALIDATE("Document No.", PurchHeader2."No.");
        //                 NoLin := TraerNoLinea + 10000;
        //                 VALIDATE("Line No.", NoLin);
        //                 VALIDATE("Buy-from Vendor No.", PurchHeader2."Buy-from Vendor No.");
        //                 Type := Type::"G/L Account";
        //                 ClaveRet.TESTFIELD("Cta. retención");
        //                 "Lín. retención" := TRUE; //TECNOCOM - GFM - 141216: Marcamos la linea antes de validar la cuenta
        //                 VALIDATE("No.", ClaveRet."Cta. retención");
        //                 //"Ref. Catastral" := CodRefCatastral;  //TECNOCOM - GFM - 040117 - OT2-032966
        //                 IF SeleccionRet = 1 THEN BEGIN
        //                     AuxLinCompra.RESET;
        //                     AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
        //                     AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
        //                     AuxLinCompra.SETRANGE("Lín. retención", FALSE);
        //                     IF AuxLinCompra.FIND('-') THEN
        //                         REPEAT
        //                             //Correccion importes 030221>>
        //                             //Correccion importes 01/02/21<<
        //                             //Imp += AuxLinCompra."Line Amount";
        //                             Imp += AuxLinCompra."VAT Base Amount";
        //                             //Correccion importes 01/02/21<<
        //                             //ImpIva += AuxLinCompra."Amount Including VAT";
        //                             /*
        //                             if auxlincompra."Pmt. Discount Amount" <> 0 then
        //                                 Imp += AuxLinCompra."Line Amount" - auxlincompra."Pmt. Discount Amount"
        //                             else
        //                                 Imp += AuxLinCompra."Line Amount";
        //                                 */
        //                             //Correccion importes 030221<<
        //                             ImpIva += AuxLinCompra."Amount Including VAT";
        //                         UNTIL (AuxLinCompra.NEXT = 0);
        //                 END
        //                 ELSE BEGIN
        //                     //La retencion se aplica a las líneas a partir de la £ltima línea de retencion
        //                     AuxLinCompra.RESET;
        //                     AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
        //                     AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
        //                     AuxLinCompra.SETFILTER("Line No.", '>%1', LinRetencion);
        //                     IF AuxLinCompra.FINDSET THEN
        //                         REPEAT
        //                             //Correccion importes 030221>>
        //                             //Correccion importes 01/02/21>>
        //                             //Imp += AuxLinCompra."Line Amount";
        //                             Imp += AuxLinCompra."VAT Base Amount";
        //                             //Correccion importes 01/02/21<<
        //                             /*
        // if auxlincompra."Pmt. Discount Amount" <> 0 then
        //     Imp += AuxLinCompra."Line Amount" - auxlincompra."Pmt. Discount Amount"
        // else
        //     Imp += AuxLinCompra."Line Amount";
        //     */
        //                             //Correccion importes 030221<<
        //                             ImpIva += AuxLinCompra."Amount Including VAT";
        //                         UNTIL AuxLinCompra.NEXT = 0;
        //                 END;
        //                 IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
        //                     VALIDATE(Quantity, Imp)
        //                 ELSE
        //                     VALIDATE(Quantity, ImpIva);
        //                 VALIDATE("Direct Unit Cost", -(ClaveRet."% Retención" / 100));
        //                 VALIDATE("Pay-to Vendor No.", PurchHeader2."Pay-to Vendor No.");
        //                 VALIDATE("Tipo Percepción", PurchHeader2."Tipo Percepción");
        //                 VALIDATE("Clave Percepción", PurchHeader2."Clave Percepción");
        //                 VALIDATE("Lín. retención", TRUE);
        //                 "Currency Code" := PurchHeader2."Currency Code";
        //                 VALIDATE("Job No.", '');
        //                 INSERT;
        //             END;
        //         END;
        //Cogemos el registro de la clave de retención.
        IF ClaveRet.GET(PurchHeader2."Clave Percepción") THEN BEGIN
            CLEAR(SeleccionRet);
            CLEAR(LinRetencion);
            //Compruebo si ya hay alguna línea de retención
            AuxLinCompra.RESET;
            AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
            AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
            AuxLinCompra.SETRANGE("Lín. retención", TRUE);
            IF AuxLinCompra.FINDLAST THEN BEGIN
                SeleccionRet := STRMENU(TextRet0001, 2);
                LinRetencion := AuxLinCompra."Line No.";
            END;
            CLEAR(LCompra);
            LCompra.INIT;
            LCompra."Document Type" := PurchHeader2."Document Type";
            LCompra.VALIDATE("Document No.", PurchHeader2."No.");
            NoLin := TraerNoLinea + 10000;
            LCompra.VALIDATE("Line No.", NoLin);
            LCompra.VALIDATE("Buy-from Vendor No.", PurchHeader2."Buy-from Vendor No.");
            LCompra.Type := LCompra.Type::"G/L Account";
            ClaveRet.TESTFIELD("Cta. retención");
            LCompra."Lín. retención" := TRUE; //TECNOCOM - GFM - 141216: Marcamos la linea antes de validar la cuenta
            LCompra.VALIDATE("No.", ClaveRet."Cta. retención");
            //"Ref. Catastral" := CodRefCatastral;  //TECNOCOM - GFM - 040117 - OT2-032966
            IF SeleccionRet = 1 THEN BEGIN
                AuxLinCompra.RESET;
                AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
                AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
                AuxLinCompra.SETRANGE("Lín. retención", FALSE);
                IF AuxLinCompra.FIND('-') THEN
                    REPEAT //Correccion importes 030221>>
                        //Correccion importes 01/02/21<<
                        //Imp += AuxLinCompra."Line Amount";
                        Imp += AuxLinCompra."VAT Base Amount";
                        //Correccion importes 01/02/21<<
                        //ImpIva += AuxLinCompra."Amount Including VAT";
                        /*
                        if auxlincompra."Pmt. Discount Amount" <> 0 then
                            Imp += AuxLinCompra."Line Amount" - auxlincompra."Pmt. Discount Amount"
                        else
                            Imp += AuxLinCompra."Line Amount";
                            */
                        //Correccion importes 030221<<
                        ImpIva += AuxLinCompra."Amount Including VAT";
                    UNTIL (AuxLinCompra.NEXT = 0);
            END
            ELSE BEGIN
                //La retencion se aplica a las líneas a partir de la £ltima línea de retencion
                AuxLinCompra.RESET;
                AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
                AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
                AuxLinCompra.SETFILTER("Line No.", '>%1', LinRetencion);
                IF AuxLinCompra.FINDSET THEN
                    REPEAT //Correccion importes 030221>>
                        //Correccion importes 01/02/21>>
                        //Imp += AuxLinCompra."Line Amount";
                        Imp += AuxLinCompra."VAT Base Amount";
                        //Correccion importes 01/02/21<<
                        /*
if auxlincompra."Pmt. Discount Amount" <> 0 then
Imp += AuxLinCompra."Line Amount" - auxlincompra."Pmt. Discount Amount"
else
Imp += AuxLinCompra."Line Amount";
*/
                        //Correccion importes 030221<<
                        ImpIva += AuxLinCompra."Amount Including VAT";
                    UNTIL AuxLinCompra.NEXT = 0;
            END;
            IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
                LCompra.VALIDATE(Quantity, Imp)
            ELSE
                LCompra.VALIDATE(Quantity, ImpIva);
            LCompra.VALIDATE("Direct Unit Cost", -(ClaveRet."% Retención" / 100));
            LCompra.VALIDATE("Pay-to Vendor No.", PurchHeader2."Pay-to Vendor No.");
            LCompra.VALIDATE("Tipo Percepción", PurchHeader2."Tipo Percepción");
            LCompra.VALIDATE("Clave Percepción", PurchHeader2."Clave Percepción");
            LCompra.VALIDATE("Lín. retención", TRUE);
            LCompra."Currency Code" := PurchHeader2."Currency Code";
            LCompra.VALIDATE("Job No.", '');
            LCompra.INSERT;
        END;
        //-- OT2-051963
    end;

    procedure TraerNoLinea(): integer
    var
        AuxLinCompra: record "Purchase Line";
    begin
        //Esta función se encarga de evaluar cual es la £ltima línea de la factura.
        PurchHeader2.GET("Document Type", "Document No.");
        AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
        AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
        IF AuxLinCompra.FINDLAST THEN
            EXIT(AuxLinCompra."Line No.")
        ELSE
            EXIT(0);
    end;

    procedure CrearAutoLinRetencion2(LCompra: record "Purchase Line"; ImpRetenInterface: Decimal)
    var
        ClaveRet: Record "IND Perception Keys (IRPF)";
        GrContableProv: Record "Vendor Posting Group";
        NoLin: Integer;
        Imp: Decimal;
        AuxLinCompra: Record "Purchase Line";
        ImpIva: Decimal;
        Ventana: Dialog;
        SeleccionRet: Integer;
        LinRetencion: Integer;
    begin
        //TECNOCOM - GFM - 291214: Se duplica la funcion CrearLinRetencion para que calcule la base para ciertos casos del Interface contable
        //Esta función se encargar  de generar automaticamente la línea de la retención.
        PurchHeader2.GET("Document Type", "Document No.");
        //++ OT2-051963
        // WITH LCompra DO BEGIN
        //     //Cogemos el registro de la clave de retención.
        //     IF ClaveRet.GET(PurchHeader2."Clave Percepción") THEN BEGIN
        //         CLEAR(SeleccionRet);
        //         CLEAR(LinRetencion);
        //         //Compruebo si ya hay alguna línea de retención
        //         AuxLinCompra.RESET;
        //         AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
        //         AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
        //         AuxLinCompra.SETRANGE("Lín. retención", TRUE);
        //         IF AuxLinCompra.FINDLAST THEN BEGIN
        //             SeleccionRet := STRMENU(TextRet0001, 2);
        //             LinRetencion := AuxLinCompra."Line No.";
        //         END;
        //         CLEAR(LCompra);
        //         INIT;
        //         "Document Type" := PurchHeader2."Document Type";
        //         VALIDATE("Document No.", PurchHeader2."No.");
        //         NoLin := TraerNoLinea + 10000;
        //         VALIDATE("Line No.", NoLin);
        //         VALIDATE("Buy-from Vendor No.", PurchHeader2."Buy-from Vendor No.");
        //         Type := Type::"G/L Account";
        //         ClaveRet.TESTFIELD("Cta. retención");
        //         "Lín. retención" := TRUE; //TECNOCOM - GFM - 141216: Marcamos la linea antes de validar la cuenta
        //         VALIDATE("No.", ClaveRet."Cta. retención");
        //         //"Ref. Catastral" := CodRefCatastral;  //TECNOCOM - GFM - 040117 - OT2-032966
        //         /*
        //         IF SeleccionRet = 1 THEN BEGIN
        //             AuxLinCompra.RESET;
        //             AuxLinCompra.SETRANGE("Document Type", PurchHeader."Document Type");
        //             AuxLinCompra.SETRANGE("Document No.", PurchHeader."No.");
        //             AuxLinCompra.SETRANGE("Lín. retención", FALSE);
        //             IF AuxLinCompra.FIND('-') THEN
        //                 REPEAT
        //                     Imp += AuxLinCompra."Line Amount";
        //                     ImpIva += AuxLinCompra."Amount Including VAT";
        //                 UNTIL (AuxLinCompra.NEXT = 0);
        //         END
        //         ELSE BEGIN
        //             //La retencion se aplica a las líneas a partir de la £ltima línea de retencion
        //             AuxLinCompra.RESET;
        //             AuxLinCompra.SETRANGE("Document Type", PurchHeader."Document Type");
        //             AuxLinCompra.SETRANGE("Document No.", PurchHeader."No.");
        //             AuxLinCompra.SETFILTER("Line No.", '>%1', LinRetencion);
        //             IF AuxLinCompra.FINDSET THEN
        //                 REPEAT
        //                     Imp += AuxLinCompra."Line Amount";
        //                     ImpIva += AuxLinCompra."Amount Including VAT";
        //                 UNTIL AuxLinCompra.NEXT = 0;
        //         END;
        //         IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
        //             VALIDATE(Quantity, Imp)
        //         ELSE
        //             VALIDATE(Quantity, ImpIva);*/
        //         //VALIDATE(Quantity,ImpRetenInterface/(-ClaveRet."% Retención" / 100));
        //         VALIDATE(Quantity, ImpRetenInterface);
        //         VALIDATE("Direct Unit Cost", -(ClaveRet."% Retención" / 100));
        //         VALIDATE("Pay-to Vendor No.", PurchHeader2."Pay-to Vendor No.");
        //         VALIDATE("Tipo Percepción", PurchHeader2."Tipo Percepción");
        //         VALIDATE("Clave Percepción", PurchHeader2."Clave Percepción");
        //         VALIDATE("Lín. retención", TRUE);
        //         "Currency Code" := PurchHeader2."Currency Code";
        //         VALIDATE("Job No.", '');
        //         INSERT;
        //     END;
        // END;
        //Cogemos el registro de la clave de retención.
        IF ClaveRet.GET(PurchHeader2."Clave Percepción") THEN BEGIN
            CLEAR(SeleccionRet);
            CLEAR(LinRetencion);
            //Compruebo si ya hay alguna línea de retención
            AuxLinCompra.RESET;
            AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
            AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
            AuxLinCompra.SETRANGE("Lín. retención", TRUE);
            IF AuxLinCompra.FINDLAST THEN BEGIN
                SeleccionRet := STRMENU(TextRet0001, 2);
                LinRetencion := AuxLinCompra."Line No.";
            END;
            CLEAR(LCompra);
            LCompra.INIT;
            LCompra."Document Type" := PurchHeader2."Document Type";
            LCompra.VALIDATE("Document No.", PurchHeader2."No.");
            NoLin := TraerNoLinea + 10000;
            LCompra.VALIDATE("Line No.", NoLin);
            LCompra.VALIDATE("Buy-from Vendor No.", PurchHeader2."Buy-from Vendor No.");
            LCompra.Type := LCompra.Type::"G/L Account";
            ClaveRet.TESTFIELD("Cta. retención");
            LCompra."Lín. retención" := TRUE; //TECNOCOM - GFM - 141216: Marcamos la linea antes de validar la cuenta
            LCompra.VALIDATE("No.", ClaveRet."Cta. retención");
            //"Ref. Catastral" := CodRefCatastral;  //TECNOCOM - GFM - 040117 - OT2-032966
            /*
            IF SeleccionRet = 1 THEN BEGIN
                AuxLinCompra.RESET;
                AuxLinCompra.SETRANGE("Document Type", PurchHeader."Document Type");
                AuxLinCompra.SETRANGE("Document No.", PurchHeader."No.");
                AuxLinCompra.SETRANGE("Lín. retención", FALSE);
                IF AuxLinCompra.FIND('-') THEN
                    REPEAT
                        Imp += AuxLinCompra."Line Amount";
                        ImpIva += AuxLinCompra."Amount Including VAT";
                    UNTIL (AuxLinCompra.NEXT = 0);
            END
            ELSE BEGIN
                //La retencion se aplica a las líneas a partir de la £ltima línea de retencion
                AuxLinCompra.RESET;
                AuxLinCompra.SETRANGE("Document Type", PurchHeader."Document Type");
                AuxLinCompra.SETRANGE("Document No.", PurchHeader."No.");
                AuxLinCompra.SETFILTER("Line No.", '>%1', LinRetencion);
                IF AuxLinCompra.FINDSET THEN
                    REPEAT
                        Imp += AuxLinCompra."Line Amount";
                        ImpIva += AuxLinCompra."Amount Including VAT";
                    UNTIL AuxLinCompra.NEXT = 0;
            END;

            IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
                VALIDATE(Quantity, Imp)
            ELSE
                VALIDATE(Quantity, ImpIva);*/
            //VALIDATE(Quantity,ImpRetenInterface/(-ClaveRet."% Retención" / 100));
            LCompra.VALIDATE(Quantity, ImpRetenInterface);
            VALIDATE("Direct Unit Cost", -(ClaveRet."% Retención" / 100));
            LCompra.VALIDATE("Pay-to Vendor No.", PurchHeader2."Pay-to Vendor No.");
            LCompra.VALIDATE("Tipo Percepción", PurchHeader2."Tipo Percepción");
            LCompra.VALIDATE("Clave Percepción", PurchHeader2."Clave Percepción");
            LCompra.VALIDATE("Lín. retención", TRUE);
            LCompra."Currency Code" := PurchHeader2."Currency Code";
            LCompra.VALIDATE("Job No.", '');
            LCompra.INSERT;
            //-- OT2-051963
        END;
    end;
    //06122020 -> crear la linea de retencion al registar :CrearAutoLinRetencionAlRegistrar -se utiliza para generar la linea cuando la factura viene de interface
    procedure CrearAutoLinRetencionAlRegistrar(LCompra: record "Purchase Line")
    var
        ClaveRet: Record "IND Perception Keys (IRPF)";
        GrContableProv: Record "Vendor Posting Group";
        NoLin: Integer;
        Imp: Decimal;
        AuxLinCompra: Record "Purchase Line";
        ImpIva: Decimal;
        Ventana: Dialog;
        SeleccionRet: Integer;
        LinRetencion: Integer;
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        LPurchHeader2: record "Purchase Header";
        PurchLine: record "Purchase Line";
        cduPurchCalcDisc: Codeunit "Purch.-Calc.Discount";
        DecImporteConDescuento: decimal;
    begin
        //Esta función se encargar  de generar automaticamente la línea de la retención antes del registro.
        DecImporteConDescuento := 0;
        LPurchHeader2.GET("Document Type", "Document No.");
        /*
        ReleasePurchDoc.PerformManualRelease(LPurchHeader2);
        ReleasePurchDoc.PerformManualReopen(LPurchHeader2);
        */
        PurchLine.SETRANGE("Document Type", LPurchHeader2."Document Type");
        PurchLine.SETRANGE("Document No.", LPurchHeader2."No.");
        PurchLine.SETFILTER(Type, '>0');
        PurchLine.SETFILTER(Quantity, '<>0');
        //++ OT2-051963
        // WITH LCompra DO BEGIN
        //     //Cogemos el registro de la clave de retención.
        //     IF ClaveRet.GET(LPurchHeader2."Clave Percepción") THEN BEGIN
        //         if claveret."% Retención" <> 0 then begin
        //             CLEAR(SeleccionRet);
        //             CLEAR(LinRetencion);
        //             //Compruebo si ya hay alguna línea de retención
        //             /* 081220202--> se genera la retención desde la interface
        //             AuxLinCompra.RESET;
        //             AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
        //             AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
        //             AuxLinCompra.SETRANGE("Lín. retención", TRUE);
        //                             IF AuxLinCompra.FINDLAST THEN BEGIN
        //                                 SeleccionRet := STRMENU(TextRet0001, 2);
        //                                 LinRetencion := AuxLinCompra."Line No.";
        //                             END;
        //             081220202>>*/
        //             //La linea de retencion se inserta con la interface y en las manuales al registrar
        //             //por ello se filtra para que no haya ninguna linea de retención en el documento.
        //             AuxLinCompra.RESET;
        //             AuxLinCompra.SETRANGE("Document Type", LPurchHeader2."Document Type");
        //             AuxLinCompra.SETRANGE("Document No.", LPurchHeader2."No.");
        //             AuxLinCompra.SETRANGE("Lín. retención", TRUE);
        //             if auxlincompra.isempty then begin
        //                 CLEAR(LCompra);
        //                 INIT;
        //                 "Document Type" := LPurchHeader2."Document Type";
        //                 VALIDATE("Document No.", LPurchHeader2."No.");
        //                 NoLin := TraerNoLinea + 10000;
        //                 VALIDATE("Line No.", NoLin);
        //                 VALIDATE("Buy-from Vendor No.", LPurchHeader2."Buy-from Vendor No.");
        //                 Type := Type::"G/L Account";
        //                 ClaveRet.TESTFIELD("Cta. retención");
        //                 "Lín. retención" := TRUE; //TECNOCOM - GFM - 141216: Marcamos la linea antes de validar la cuenta
        //                 VALIDATE("No.", ClaveRet."Cta. retención");
        //                 /*081220202--> se genera la retención para todas las líneas que tenga aplica retencion = true
        //                 IF SeleccionRet = 1 THEN BEGIN
        //                     AuxLinCompra.RESET;
        //                     AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
        //                     AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
        //                     AuxLinCompra.setrange("Aplica Retencion", true);
        //                     AuxLinCompra.SETRANGE("Lín. retención", FALSE);
        //                     IF AuxLinCompra.FIND('-') THEN
        //                         REPEAT
        //                             Imp += AuxLinCompra."Line Amount";
        //                             ImpIva += AuxLinCompra."Amount Including VAT";
        //                         UNTIL (AuxLinCompra.NEXT = 0);
        //                 END
        //                 ELSE BEGIN
        //                     //La retencion se aplica a las líneas a partir de la £ltima línea de retencion
        //                     AuxLinCompra.RESET;
        //                     AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
        //                     AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
        //                     AuxLinCompra.SETFILTER("Line No.", '>%1', LinRetencion);
        //                     IF AuxLinCompra.FINDSET THEN
        //                         REPEAT
        //                             Imp += AuxLinCompra."Line Amount";
        //                             ImpIva += AuxLinCompra."Amount Including VAT";
        //                         UNTIL AuxLinCompra.NEXT = 0;
        //                 END;
        //                 */
        //                 AuxLinCompra.RESET;
        //                 AuxLinCompra.SETRANGE("Document Type", LPurchHeader2."Document Type");
        //                 AuxLinCompra.SETRANGE("Document No.", LPurchHeader2."No.");
        //                 AuxLinCompra.setrange("Aplica Retencion", true);
        //                 AuxLinCompra.SETRANGE("Lín. retención", FALSE);
        //                 IF AuxLinCompra.FIND('-') THEN
        //                     REPEAT
        //                         //Correccion importes 030221<<
        //                         //Correccion importes 01/02/21>>
        //                         //Imp += AuxLinCompra."Line Amount";
        //                         if LPurchHeader2."Payment Discount %" <> 0 then begin
        //                             DecImporteConDescuento := (auxlincompra."Line Amount" - (auxlincompra."Line Amount" * LPurchHeader2."Payment Discount %" / 100));
        //                             Imp += DecImporteConDescuento;
        //                         end else
        //                             Imp += auxlincompra."VAT Base Amount";
        //                         //Correccion importes 01/02/21<<
        //                         //ImpIva += AuxLinCompra."Amount Including VAT";
        //                         /*
        //                         if auxlincompra."Pmt. Discount Amount" <> 0 then
        //                             Imp += AuxLinCompra."Line Amount" - auxlincompra."Pmt. Discount Amount"
        //                         else
        //                             Imp += AuxLinCompra."Line Amount";
        //                             */
        //                         //Correccion importes 030221<<
        //                         ImpIva += AuxLinCompra."Amount Including VAT";
        //                     UNTIL (AuxLinCompra.NEXT = 0);
        //                 //081220202>>
        //                 IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
        //                     VALIDATE(Quantity, round(Imp, 0.01))
        //                 ELSE
        //                     VALIDATE(Quantity, ImpIva);
        //                 VALIDATE("Direct Unit Cost", -(ClaveRet."% Retención" / 100));
        //                 VALIDATE("Pay-to Vendor No.", LPurchHeader2."Pay-to Vendor No.");
        //                 VALIDATE("Tipo Percepción", LPurchHeader2."Tipo Percepción");
        //                 VALIDATE("Clave Percepción", LPurchHeader2."Clave Percepción");
        //                 VALIDATE("Lín. retención", TRUE);
        //                 "Currency Code" := LPurchHeader2."Currency Code";
        //                 VALIDATE("Job No.", '');
        //                 INSERT;
        //             end;
        //         end;
        //     END;
        // END;
        //Cogemos el registro de la clave de retención.
        IF ClaveRet.GET(LPurchHeader2."Clave Percepción") THEN BEGIN
            if claveret."% Retención" <> 0 then begin
                CLEAR(SeleccionRet);
                CLEAR(LinRetencion);
                //Compruebo si ya hay alguna línea de retención
                /* 081220202--> se genera la retención desde la interface
                AuxLinCompra.RESET;
                AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
                AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
                AuxLinCompra.SETRANGE("Lín. retención", TRUE);


                                IF AuxLinCompra.FINDLAST THEN BEGIN
                                    SeleccionRet := STRMENU(TextRet0001, 2);
                                    LinRetencion := AuxLinCompra."Line No.";
                                END;
                081220202>>*/
                //La linea de retencion se inserta con la interface y en las manuales al registrar
                //por ello se filtra para que no haya ninguna linea de retención en el documento.
                AuxLinCompra.RESET;
                AuxLinCompra.SETRANGE("Document Type", LPurchHeader2."Document Type");
                AuxLinCompra.SETRANGE("Document No.", LPurchHeader2."No.");
                AuxLinCompra.SETRANGE("Lín. retención", TRUE);
                if auxlincompra.isempty then begin
                    CLEAR(LCompra);
                    LCompra.INIT;
                    LCompra."Document Type" := LPurchHeader2."Document Type";
                    LCompra.VALIDATE("Document No.", LPurchHeader2."No.");
                    NoLin := TraerNoLinea + 10000;
                    LCompra.VALIDATE("Line No.", NoLin);
                    LCompra.VALIDATE("Buy-from Vendor No.", LPurchHeader2."Buy-from Vendor No.");
                    LCompra.Type := LCompra.Type::"G/L Account";
                    ClaveRet.TESTFIELD("Cta. retención");
                    LCompra."Lín. retención" := TRUE; //TECNOCOM - GFM - 141216: Marcamos la linea antes de validar la cuenta
                    LCompra.VALIDATE("No.", ClaveRet."Cta. retención");
                    /*081220202--> se genera la retención para todas las líneas que tenga aplica retencion = true
                    IF SeleccionRet = 1 THEN BEGIN
                        AuxLinCompra.RESET;
                        AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
                        AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
                        AuxLinCompra.setrange("Aplica Retencion", true);
                        AuxLinCompra.SETRANGE("Lín. retención", FALSE);
                        IF AuxLinCompra.FIND('-') THEN
                            REPEAT
                                Imp += AuxLinCompra."Line Amount";
                                ImpIva += AuxLinCompra."Amount Including VAT";
                            UNTIL (AuxLinCompra.NEXT = 0);
                    END
                    ELSE BEGIN
                        //La retencion se aplica a las líneas a partir de la £ltima línea de retencion
                        AuxLinCompra.RESET;
                        AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
                        AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
                        AuxLinCompra.SETFILTER("Line No.", '>%1', LinRetencion);
                        IF AuxLinCompra.FINDSET THEN
                            REPEAT
                                Imp += AuxLinCompra."Line Amount";
                                ImpIva += AuxLinCompra."Amount Including VAT";
                            UNTIL AuxLinCompra.NEXT = 0;
                    END;
                    */
                    AuxLinCompra.RESET;
                    AuxLinCompra.SETRANGE("Document Type", LPurchHeader2."Document Type");
                    AuxLinCompra.SETRANGE("Document No.", LPurchHeader2."No.");
                    AuxLinCompra.setrange("Aplica Retencion", true);
                    AuxLinCompra.SETRANGE("Lín. retención", FALSE);
                    IF AuxLinCompra.FIND('-') THEN
                        REPEAT //Correccion importes 030221<<
                            //Correccion importes 01/02/21>>
                            //Imp += AuxLinCompra."Line Amount";
                            if LPurchHeader2."Payment Discount %" <> 0 then begin
                                DecImporteConDescuento := (auxlincompra."Line Amount" - (auxlincompra."Line Amount" * LPurchHeader2."Payment Discount %" / 100));
                                Imp += DecImporteConDescuento;
                            end
                            else
                                Imp += auxlincompra."VAT Base Amount";
                            //Correccion importes 01/02/21<<
                            //ImpIva += AuxLinCompra."Amount Including VAT";
                            /*
                            if auxlincompra."Pmt. Discount Amount" <> 0 then
                                Imp += AuxLinCompra."Line Amount" - auxlincompra."Pmt. Discount Amount"
                            else
                                Imp += AuxLinCompra."Line Amount";
                                */
                            //Correccion importes 030221<<
                            ImpIva += AuxLinCompra."Amount Including VAT";
                        UNTIL (AuxLinCompra.NEXT = 0);
                    //081220202>>
                    IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
                        LCompra.VALIDATE(Quantity, round(Imp, 0.01))
                    ELSE
                        LCompra.VALIDATE(Quantity, ImpIva);
                    LCompra.VALIDATE("Direct Unit Cost", -(ClaveRet."% Retención" / 100));
                    LCompra.VALIDATE("Pay-to Vendor No.", LPurchHeader2."Pay-to Vendor No.");
                    LCompra.VALIDATE("Tipo Percepción", LPurchHeader2."Tipo Percepción");
                    LCompra.VALIDATE("Clave Percepción", LPurchHeader2."Clave Percepción");
                    LCompra.VALIDATE("Lín. retención", TRUE);
                    LCompra."Currency Code" := LPurchHeader2."Currency Code";
                    LCompra.VALIDATE("Job No.", '');
                    LCompra.INSERT;
                end;
            end;
        END;
        //-- OT2-051963
    end;
    //CrearAutoLinRetencionAlRegistrarManual se utiliza para generar la retencion al registrar de las facturas que no vienen de interface...
    procedure CrearAutoLinRetencionAlRegistrarManual(LCompra: record "Purchase Line")
    var
        ClaveRet: Record "IND Perception Keys (IRPF)";
        GrContableProv: Record "Vendor Posting Group";
        NoLin: Integer;
        Imp: Decimal;
        AuxLinCompra: Record "Purchase Line";
        ImpIva: Decimal;
        Ventana: Dialog;
        SeleccionRet: Integer;
        LinRetencion: Integer;
        LPurchHeader2: record "Purchase Header";
        DecImporteConDescuento: decimal;
    begin
        //Esta función se encargar  de generar automaticamente la línea de la retención antes del registro.
        PurchHeader2.GET("Document Type", "Document No.");
        //++ OT2-051963
        // WITH LCompra DO BEGIN
        //     //Cogemos el registro de la clave de retención.
        //     IF ClaveRet.GET(PurchHeader2."Clave Percepción") THEN BEGIN
        //         if claveret."% Retención" <> 0 then begin
        //             CLEAR(SeleccionRet);
        //             CLEAR(LinRetencion);
        //             AuxLinCompra.RESET;
        //             AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
        //             AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
        //             AuxLinCompra.SETRANGE("Lín. retención", TRUE);
        //             if auxlincompra.isempty then begin
        //                 CLEAR(LCompra);
        //                 INIT;
        //                 "Document Type" := PurchHeader2."Document Type";
        //                 VALIDATE("Document No.", PurchHeader2."No.");
        //                 NoLin := TraerNoLinea + 10000;
        //                 VALIDATE("Line No.", NoLin);
        //                 VALIDATE("Buy-from Vendor No.", PurchHeader2."Buy-from Vendor No.");
        //                 Type := Type::"G/L Account";
        //                 ClaveRet.TESTFIELD("Cta. retención");
        //                 "Lín. retención" := TRUE; //TECNOCOM - GFM - 141216: Marcamos la linea antes de validar la cuenta
        //                 VALIDATE("No.", ClaveRet."Cta. retención");
        //                 AuxLinCompra.RESET;
        //                 AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
        //                 AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
        //                 AuxLinCompra.setrange("Aplica Retencion", true);
        //                 AuxLinCompra.SETRANGE("Lín. retención", FALSE);
        //                 IF AuxLinCompra.FIND('-') THEN
        //                     REPEAT
        //                         //Correccion importes 030221>>
        //                         //Correccion importes 01/02/21>>
        //                         //Imp += AuxLinCompra."Line Amount";
        //                         if LPurchHeader2."Payment Discount %" <> 0 then begin
        //                             DecImporteConDescuento := (auxlincompra."Line Amount" - (auxlincompra."Line Amount" * LPurchHeader2."Payment Discount %" / 100));
        //                             Imp += DecImporteConDescuento;
        //                         end else
        //                             Imp += AuxLinCompra."VAT Base Amount";
        //                         //Correccion importes 01/02/21<<
        //                         //ImpIva += AuxLinCompra."Amount Including VAT";
        //                         /*
        //                                                 if auxlincompra."Pmt. Discount Amount" <> 0 then
        //                                                     Imp += AuxLinCompra."Line Amount" - auxlincompra."Pmt. Discount Amount"
        //                                                 else
        //                                                     Imp += AuxLinCompra."Line Amount";
        //                                                     */
        //                         //Correccion importes 030221<<
        //                         ImpIva += AuxLinCompra."Amount Including VAT";
        //                     UNTIL (AuxLinCompra.NEXT = 0);
        //                 IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
        //                     VALIDATE(Quantity, round(Imp, 0.01))
        //                 ELSE
        //                     VALIDATE(Quantity, ImpIva);
        //                 VALIDATE("Direct Unit Cost", -(ClaveRet."% Retención" / 100));
        //                 VALIDATE("Pay-to Vendor No.", PurchHeader2."Pay-to Vendor No.");
        //                 VALIDATE("Tipo Percepción", PurchHeader2."Tipo Percepción");
        //                 VALIDATE("Clave Percepción", PurchHeader2."Clave Percepción");
        //                 VALIDATE("Lín. retención", TRUE);
        //                 "Currency Code" := PurchHeader2."Currency Code";
        //                 VALIDATE("Job No.", '');
        //                 INSERT;
        //             end;
        //         end;
        //     END;
        // END;
        //Cogemos el registro de la clave de retención.
        IF ClaveRet.GET(PurchHeader2."Clave Percepción") THEN BEGIN
            if claveret."% Retención" <> 0 then begin
                CLEAR(SeleccionRet);
                CLEAR(LinRetencion);
                AuxLinCompra.RESET;
                AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
                AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
                AuxLinCompra.SETRANGE("Lín. retención", TRUE);
                if auxlincompra.isempty then begin
                    CLEAR(LCompra);
                    LCompra.INIT;
                    LCompra."Document Type" := PurchHeader2."Document Type";
                    LCompra.VALIDATE("Document No.", PurchHeader2."No.");
                    NoLin := TraerNoLinea + 10000;
                    LCompra.VALIDATE("Line No.", NoLin);
                    LCompra.VALIDATE("Buy-from Vendor No.", PurchHeader2."Buy-from Vendor No.");
                    LCompra.Type := Type::"G/L Account";
                    ClaveRet.TESTFIELD("Cta. retención");
                    LCompra."Lín. retención" := TRUE; //TECNOCOM - GFM - 141216: Marcamos la linea antes de validar la cuenta
                    LCompra.VALIDATE("No.", ClaveRet."Cta. retención");
                    AuxLinCompra.RESET;
                    AuxLinCompra.SETRANGE("Document Type", PurchHeader2."Document Type");
                    AuxLinCompra.SETRANGE("Document No.", PurchHeader2."No.");
                    AuxLinCompra.setrange("Aplica Retencion", true);
                    AuxLinCompra.SETRANGE("Lín. retención", FALSE);
                    IF AuxLinCompra.FIND('-') THEN
                        REPEAT //Correccion importes 030221>>
                            //Correccion importes 01/02/21>>
                            //Imp += AuxLinCompra."Line Amount";
                            if LPurchHeader2."Payment Discount %" <> 0 then begin
                                DecImporteConDescuento := (auxlincompra."Line Amount" - (auxlincompra."Line Amount" * LPurchHeader2."Payment Discount %" / 100));
                                Imp += DecImporteConDescuento;
                            end
                            else
                                Imp += AuxLinCompra."VAT Base Amount";
                            //Correccion importes 01/02/21<<
                            //ImpIva += AuxLinCompra."Amount Including VAT";
                            /*
                                                    if auxlincompra."Pmt. Discount Amount" <> 0 then
                                                        Imp += AuxLinCompra."Line Amount" - auxlincompra."Pmt. Discount Amount"
                                                    else
                                                        Imp += AuxLinCompra."Line Amount";
                                                        */
                            //Correccion importes 030221<<
                            ImpIva += AuxLinCompra."Amount Including VAT";
                        UNTIL (AuxLinCompra.NEXT = 0);
                    IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
                        LCompra.VALIDATE(Quantity, round(Imp, 0.01))
                    ELSE
                        LCompra.VALIDATE(Quantity, ImpIva);
                    LCompra.VALIDATE("Direct Unit Cost", -(ClaveRet."% Retención" / 100));
                    LCompra.VALIDATE("Pay-to Vendor No.", PurchHeader2."Pay-to Vendor No.");
                    LCompra.VALIDATE("Tipo Percepción", PurchHeader2."Tipo Percepción");
                    LCompra.VALIDATE("Clave Percepción", PurchHeader2."Clave Percepción");
                    LCompra.VALIDATE("Lín. retención", TRUE);
                    "Currency Code" := PurchHeader2."Currency Code";
                    LCompra.VALIDATE("Job No.", '');
                    LCompra.INSERT;
                end;
            end;
        END;
    end;
    //-- OT2-051963
}
