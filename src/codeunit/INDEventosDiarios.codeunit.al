namespace ScriptumVita.IRPF;
codeunit 86302 "IND Eventos Diarios"
{
    // version INDRA
    trigger OnRun()
    begin
    end;
    //Codeunit 12 INICIO
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostGenJnlLine', '', true, true)]
    local procedure OnBeforePostGenJnlLine(VAR GenJournalLine: Record "Gen. Journal Line")
    var
        MovRetencion2: Record "IND Witholding Tax registers";
        RetencionesGeneradas: Boolean;
        VNumMovReten: Integer;
        MovRetencion3: Record "IND Witholding Tax registers";
        MovRetencion4: Record "IND Witholding Tax registers";
        RetGener: Boolean;
        Auxliqretencionl: Record "IND Aux. liq mov. retención";
        ReversePostingDate: Date;
        ReverseDocument: Code[20];
        NMovRentencion: Integer;
        GlobalRETGLEntry: Record 17;
        GlobalRETGenJnlLine: Record 81;
        Proyecto: Code[20];
        CodDivisa: Code[10];
        //rIberPostCharges : Record 50053;
        EsDiario: Boolean;
        Rec: codeunit "Gen. Jnl.-Post Line";
    begin
        IF (GenJournalLine."Importe retención" <> 0) AND (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account") then Crearmovretención(GenJournalLine);
    END;

    procedure Crearmovretención(LiDiario: record "Gen. Journal Line")
    var
        NoMovRet1: Integer;
        MovRet1: record "IND Witholding Tax registers";
        RCliente: record Customer;
        CPl1: record "Post Code";
        RProveedor: record vendor;
        Clavepercepcionl1: record "IND Perception Keys (IRPF)";
        Regdivisa1: record Currency;
        CurrExchRate: record "Currency Exchange Rate";
        CodDivisa: code[10];
        GLSetup: record "General Ledger Setup";
        LRec_PostCode: Record "Post Code";
    begin
        //CrearMovRetencion
        NoMovRet1 := TraerNoMovRetencion;
        //++ OT2-051963
        // WITH MovRet1 DO BEGIN
        //     MovRet1."Nº mov." := NoMovRet1 + 1;
        //     MovRet1."Nº Proveedor / Nº Cliente" := LiDiario."Nº Cliente/Proveedor";
        //     IF LiDiario."Cliente/Proveedor" = LiDiario."Cliente/Proveedor"::Cliente THEN BEGIN
        //         IF RCliente.GET(LiDiario."Nº Cliente/Proveedor") THEN BEGIN
        //             MovRet1.Descripción := RCliente.Name;
        //             MovRet1."Cif/Nif" := RCliente."VAT Registration No.";
        //             "C.P" := RCliente."Post Code";
        //             //MovRet1."Código provincia" := RCliente.County;
        //             LRec_PostCode.Reset();
        //             LRec_PostCode.SetRange(Code, RCliente."Post Code");
        //             if LRec_PostCode.FindFirst() then
        //                 MovRet1."Código provincia" := LRec_PostCode."County Code";
        //             "Cód. divisa" := RCliente."Currency Code";
        //             CodDivisa := RCliente."Currency Code";
        //             CLEAR(CPl1);
        //             CPl1.RESET;
        //             IF CPl1.GET(RCliente."Post Code", RCliente.City) THEN
        //                 "Código provincia" := CPl1."County Code";
        //             //"Código provincia" := CPl1."County";
        //         END
        //         ELSE BEGIN
        //             IF RProveedor.GET(LiDiario."Nº Cliente/Proveedor") THEN BEGIN
        //                 MovRet1.Descripción := RProveedor.Name;
        //                 MovRet1."Cif/Nif" := RProveedor."VAT Registration No.";
        //                 "C.P" := RProveedor."Post Code";
        //                 //MovRet1."Código provincia" := RProveedor.County;
        //                 LRec_PostCode.Reset();
        //                 LRec_PostCode.SetRange(Code, RProveedor."Post Code");
        //                 if LRec_PostCode.FindFirst() then
        //                     MovRet1."Código provincia" := LRec_PostCode."County Code";
        //                 "Cód. divisa" := RProveedor."Currency Code";
        //                 CodDivisa := RProveedor."Currency Code";
        //                 CLEAR(CPl1);
        //                 CPl1.RESET;
        //                 IF CPl1.GET(RProveedor."Post Code", RProveedor.City) THEN
        //                     "Código provincia" := CPl1."County Code";
        //                 //"Código provincia" := CPl1."County";
        //             END;
        //         END;
        //     END;
        //     "Fecha registro" := LiDiario."Posting Date";
        //     "Nº documento" := LiDiario."Document No.";
        //     "Tipo Documento" := LiDiario."Document Type";
        //     "Importe factura iva incl." := LiDiario."VAT Amount";
        //     "Importe factura" := LiDiario."Importe Factura";
        //     "Base retención" := LiDiario."Base retención";
        //     "% retención" := LiDiario."Porcentaje retención";
        //     "Tipo de Perceptor" := LiDiario."Tipo percepción";
        //     "Clave de Percepción" := LiDiario."Clave percepción";
        //     VALIDATE("Nº Proyecto", LiDiario."Job No.");
        //     "Nº asiento" := 0;
        //     "Cód. origen" := LiDiario."Source Code";
        //     MovRet1."Año devengo" := DATE2DMY("Fecha registro", 3);
        //     Clavepercepcionl1.RESET;
        //     IF Clavepercepcionl1.GET(LiDiario."Clave percepción") THEN BEGIN
        //         MovRet1."Cta. retención" := Clavepercepcionl1."Cta. retención";
        //         MovRet1."Clave IRPF" := Clavepercepcionl1."Clave IRPF";
        //         MovRet1."Subclave IRPF" := Clavepercepcionl1."Subclave IRPF";
        //         MovRet1."Tipo percepción" := Clavepercepcionl1."Tipo percepción";
        //         MovRet1."Cli/Prov" := Clavepercepcionl1."Cli/Prov";
        //         MovRet1."Tipo Retención" := Clavepercepcionl1."Tipo Retención";
        //     END;
        //     "Importe retención" := CurrExchRate.ExchangeAmtLCYToFCY(WORKDATE, "Cód. divisa",
        //                           LiDiario."Importe retención", CurrExchRate.ExchangeRate(WORKDATE, "Cód. divisa"));
        //     IF Regdivisa1.GET(CodDivisa) THEN
        //         "Importe retención" := ROUND("Importe retención", Regdivisa1."Amount Rounding Precision");
        //     GLSetup.GET;
        //     "Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                            "Base retención", CurrExchRate.ExchangeRate(WORKDATE, "Cód. divisa"));
        //     "Base retencion (DL)" := ROUND("Base retencion (DL)", GLSetup."Amount Rounding Precision");
        //     "Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                 "Importe retención", CurrExchRate.ExchangeRate(WORKDATE, "Cód. divisa"));
        //     "Importe retención (DL)" := ROUND("Importe retención (DL)", GLSetup."Amount Rounding Precision");
        //     "Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                               "Importe factura iva incl.", CurrExchRate.ExchangeRate(WORKDATE, "Cód. divisa"));
        //     "Importe Factura (DL)" := ROUND("Importe Factura (DL)", GLSetup."Amount Rounding Precision");
        //     MovRet1."Importe Pendiente" := "Importe retención";
        //     //-008
        //     "Importe Pendiente (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                 "Importe Pendiente", CurrExchRate.ExchangeRate(WORKDATE, "Cód. divisa"));
        //     "Importe Pendiente (DL)" := ROUND("Importe Pendiente (DL)", GLSetup."Amount Rounding Precision");
        //     //+008
        //     MovRet1.Pendiente := TRUE;
        //     MovRet1."Importe a Liquidar" := "Importe retención";
        //     //-008
        //     "Importe a Liquidar (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                 "Importe a Liquidar", CurrExchRate.ExchangeRate(WORKDATE, "Cód. divisa"));
        //     "Importe a Liquidar (DL)" := ROUND("Importe a Liquidar (DL)", GLSetup."Amount Rounding Precision");
        //     //+008
        //     //TECNOCOM TecnoRet - EFS - 070912
        //     "Shortcut Dimension 1 Code" := LiDiario."Shortcut Dimension 1 Code";
        //     "Shortcut Dimension 2 Code" := LiDiario."Shortcut Dimension 2 Code";
        //     //FIN TECNOCOM TecnoRet - EFS - 070912
        //     INSERT;
        // END;
        MovRet1."Nº mov." := NoMovRet1 + 1;
        MovRet1."Nº Proveedor / Nº Cliente" := LiDiario."Nº Cliente/Proveedor";
        IF LiDiario."Cliente/Proveedor" = LiDiario."Cliente/Proveedor"::Cliente THEN BEGIN
            IF RCliente.GET(LiDiario."Nº Cliente/Proveedor") THEN BEGIN
                MovRet1.Descripción := RCliente.Name;
                MovRet1."Cif/Nif" := RCliente."VAT Registration No.";
                MovRet1."C.P" := RCliente."Post Code";
                //MovRet1."Código provincia" := RCliente.County;
                LRec_PostCode.Reset();
                LRec_PostCode.SetRange(Code, RCliente."Post Code");
                if LRec_PostCode.FindFirst() then MovRet1."Código provincia" := LRec_PostCode."County Code";
                MovRet1."Cód. divisa" := RCliente."Currency Code";
                CodDivisa := RCliente."Currency Code";
                CLEAR(CPl1);
                CPl1.RESET;
                IF CPl1.GET(RCliente."Post Code", RCliente.City) THEN MovRet1."Código provincia" := CPl1."County Code";
                //"Código provincia" := CPl1."County";
            END
            ELSE BEGIN
                IF RProveedor.GET(LiDiario."Nº Cliente/Proveedor") THEN BEGIN
                    MovRet1.Descripción := RProveedor.Name;
                    MovRet1."Cif/Nif" := RProveedor."VAT Registration No.";
                    MovRet1."C.P" := RProveedor."Post Code";
                    //MovRet1."Código provincia" := RProveedor.County;
                    LRec_PostCode.Reset();
                    LRec_PostCode.SetRange(Code, RProveedor."Post Code");
                    if LRec_PostCode.FindFirst() then MovRet1."Código provincia" := LRec_PostCode."County Code";
                    MovRet1."Cód. divisa" := RProveedor."Currency Code";
                    CodDivisa := RProveedor."Currency Code";
                    CLEAR(CPl1);
                    CPl1.RESET;
                    IF CPl1.GET(RProveedor."Post Code", RProveedor.City) THEN MovRet1."Código provincia" := CPl1."County Code";
                    //"Código provincia" := CPl1."County";
                END;
            END;
        END;
        MovRet1."Fecha registro" := LiDiario."Posting Date";
        MovRet1."Nº documento" := LiDiario."Document No.";
        //++ OT2-051963
        //MovRet1."Tipo Documento" := LiDiario."Document Type";
        MovRet1."Tipo Documento" := LiDiario."Document Type".AsInteger();
        //-- OT2-051963
        MovRet1."Importe factura iva incl." := LiDiario."VAT Amount";
        MovRet1."Importe factura" := LiDiario."Importe Factura";
        MovRet1."Base retención" := LiDiario."Base retención";
        MovRet1."% retención" := LiDiario."Porcentaje retención";
        MovRet1."Tipo de Perceptor" := LiDiario."Tipo percepción";
        MovRet1."Clave de Percepción" := LiDiario."Clave percepción";
        MovRet1.VALIDATE("Nº Proyecto", LiDiario."Job No.");
        MovRet1."Nº asiento" := 0;
        MovRet1."Cód. origen" := LiDiario."Source Code";
        MovRet1."Año devengo" := DATE2DMY(MovRet1."Fecha registro", 3);
        Clavepercepcionl1.RESET;
        IF Clavepercepcionl1.GET(LiDiario."Clave percepción") THEN BEGIN
            MovRet1."Cta. retención" := Clavepercepcionl1."Cta. retención";
            MovRet1."Clave IRPF" := Clavepercepcionl1."Clave IRPF";
            MovRet1."Subclave IRPF" := Clavepercepcionl1."Subclave IRPF";
            MovRet1."Tipo percepción" := Clavepercepcionl1."Tipo percepción";
            MovRet1."Cli/Prov" := Clavepercepcionl1."Cli/Prov";
            MovRet1."Tipo Retención" := Clavepercepcionl1."Tipo Retención";
        END;
        MovRet1."Importe retención" := CurrExchRate.ExchangeAmtLCYToFCY(WORKDATE, MovRet1."Cód. divisa", LiDiario."Importe retención", CurrExchRate.ExchangeRate(WORKDATE, MovRet1."Cód. divisa"));
        IF Regdivisa1.GET(CodDivisa) THEN MovRet1."Importe retención" := ROUND(MovRet1."Importe retención", Regdivisa1."Amount Rounding Precision");
        GLSetup.GET;
        MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Base retención", CurrExchRate.ExchangeRate(WORKDATE, MovRet1."Cód. divisa"));
        MovRet1."Base retencion (DL)" := ROUND(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
        MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Importe retención", CurrExchRate.ExchangeRate(WORKDATE, MovRet1."Cód. divisa"));
        MovRet1."Importe retención (DL)" := ROUND(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
        MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", CurrExchRate.ExchangeRate(WORKDATE, MovRet1."Cód. divisa"));
        MovRet1."Importe Factura (DL)" := ROUND(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
        MovRet1."Importe Pendiente" := MovRet1."Importe retención";
        //-008
        MovRet1."Importe Pendiente (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Importe Pendiente", CurrExchRate.ExchangeRate(WORKDATE, MovRet1."Cód. divisa"));
        MovRet1."Importe Pendiente (DL)" := ROUND(MovRet1."Importe Pendiente (DL)", GLSetup."Amount Rounding Precision");
        //+008
        MovRet1.Pendiente := TRUE;
        MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
        //-008
        MovRet1."Importe a Liquidar (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Importe a Liquidar", CurrExchRate.ExchangeRate(WORKDATE, MovRet1."Cód. divisa"));
        MovRet1."Importe a Liquidar (DL)" := ROUND(MovRet1."Importe a Liquidar (DL)", GLSetup."Amount Rounding Precision");
        //+008
        //TECNOCOM TecnoRet - EFS - 070912
        MovRet1."Shortcut Dimension 1 Code" := LiDiario."Shortcut Dimension 1 Code";
        MovRet1."Shortcut Dimension 2 Code" := LiDiario."Shortcut Dimension 2 Code";
        //FIN TECNOCOM TecnoRet - EFS - 070912
        MovRet1.INSERT;
        //-- OT2-051963
    end;

    procedure TraerNoMovRetencion(): integer
    var
        MovRet: record "IND Witholding Tax registers";
    begin
        MovRet.LOCKTABLE;
        MovRet.RESET;
        IF MovRet.FIND('+') THEN
            EXIT(MovRet."Nº mov.")
        ELSE
            EXIT(0);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInsertGlobalGLEntry', '', false, false)]
    local procedure ActualizarCampoNoAsiento(var GLEntry: Record "G/L Entry")
    begin
        IF (GLEntry."Document Type" IN [GLEntry."Document Type"::Invoice, GLEntry."Document Type"::"Credit Memo", GLEntry."Document Type"::" "]) AND (GLEntry.Reversed = FALSE) THEN //++ OT2-051963
            //ActualizaAsientoRetención(GLEntry."Document No.", GLEntry."Transaction No.", GLEntry."Document Type",
            ActualizaAsientoRetención(GLEntry."Document No.", GLEntry."Transaction No.", GLEntry."Document Type".AsInteger(), //-- OT2-051963
            GLEntry."Posting Date");
    end;

    procedure ActualizaAsientoRetención(AuxNumDocumento: Code[20]; AuxNumAsiento: Integer; AuxTipo: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo","Reminder","Refund"; AuxFecha: Date)
    var
        NumInicial: Integer;
        NumFinal: integer;
        AuxMovRetención: record "IND Witholding Tax registers";
        AuxMovConta: record "G/L Entry";
    begin
        //Se sitúa primero en los movimientos contables para también actualizar dichos campos en ls mov. de retención
        CLEAR(NumInicial);
        CLEAR(NumFinal);
        AuxMovConta.RESET;
        AuxMovConta.SETCURRENTKEY("Document No.", "Posting Date");
        AuxMovConta.SETFILTER("Document No.", AuxNumDocumento);
        AuxMovConta.SETRANGE("Posting Date", AuxFecha);
        IF AuxMovConta.FINDFIRST THEN BEGIN
            NumInicial := AuxMovConta."Entry No.";
            IF AuxMovConta.FINDLAST THEN NumFinal := AuxMovConta."Entry No.";
        END;
        AuxMovRetención.RESET;
        AuxMovRetención.SETCURRENTKEY("Nº documento", "Tipo Documento", Revertido, "Fecha registro");
        AuxMovRetención.SETFILTER("Nº documento", AuxNumDocumento);
        AuxMovRetención.SETRANGE("Tipo Documento", AuxTipo);
        AuxMovRetención.SETRANGE(Revertido, FALSE);
        AuxMovRetención.SETRANGE("Fecha registro", AuxFecha);
        AuxMovRetención.SETRANGE("Nº asiento", 0);
        IF AuxMovRetención.FINDSET THEN
            REPEAT
                AuxMovRetención."Nº asiento" := AuxNumAsiento;
                AuxMovRetención."Desde Nº Mov. contabilidad" := NumInicial;
                AuxMovRetención."Hasta Nº Mov. contabilidad" := NumFinal;
                AuxMovRetención.MODIFY;
            UNTIL AuxMovRetención.NEXT = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    local procedure OnAfterInitGLEntryIRPF(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        Auxliqretencionl: record "IND Aux. liq mov. retención";
        //GenJnlLine: record "Gen. Journal Line";
        GlobalRETGLEntry: record "G/L Entry";
        GlobalRETGenJnlLine: record "Gen. Journal Line";
    begin
        //TecnoRet
        IF (GenJournalLine."Liq. retención") AND (GLEntry."Source Type" = GLEntry."Source Type"::" ") THEN BEGIN
            CLEAR(Auxliqretencionl);
            Auxliqretencionl.RESET;
            Auxliqretencionl.SETRANGE("Journal Template Name", GenJournalLine."Journal Template Name");
            Auxliqretencionl.SETRANGE("Journal Batch Name", GenJournalLine."Journal Batch Name");
            Auxliqretencionl.SETRANGE("Line No.", GenJournalLine."Line No.");
            IF Auxliqretencionl.FINDFIRST THEN
                REPEAT //-JPP
                    //Variables globales para que utilice en la funcion. No se las puedo pasar como parametro porque a la funcion se la llama
                    //desde la code 80 y 90 donde no tengo estos registros
                    GlobalRETGLEntry := GLEntry;
                    GlobalRETGenJnlLine := GenJournalLine;
                    //+JPP
                    LiqRetencion(Auxliqretencionl."Nº documento", Auxliqretencionl."Mov.retención", Auxliqretencionl."Importe a liquidar", GlobalRETGenJnlLine, GlobalRETGLEntry);
                    Auxliqretencionl.DELETE; // OT2-004391 - 12.09.12 - MBG
                UNTIL Auxliqretencionl.NEXT = 0;
        END;
        //FIN TecnoRet*/
    end;

    procedure LiqRetencion(VAR Ndocuemnto: Code[20]; NumMov: Integer; Importep: Decimal; GlobalRETGenJnlLine: record "Gen. Journal Line"; GlobalRETGLEntry: record "G/L Entry")
    var
        NoMov: Integer;
        Abono: Boolean;
        HistFactCompra: Record "Purch. Inv. Header";
        HistAbonCompra: Record "Purch. Cr. Memo Hdr.";
        HistFactVenta: Record "Sales Invoice Header";
        HistAbonVenta: Record "Sales Cr.Memo Header";
        MovRetencion2: record "IND Witholding Tax registers";
        MovRetencion3: record "IND Witholding Tax registers";
        MovRetencion4: record "IND Witholding Tax registers";
        VNumMovReten: integer;
        CurrExchRate: record "Currency Exchange Rate";
        LastDocNo: code[20];
    begin
        LastDocNo := GlobalRETGLEntry."Document No.";
        MovRetencion2.LOCKTABLE;
        MovRetencion2.RESET;
        IF MovRetencion2.FIND('+') THEN BEGIN
            VNumMovReten := MovRetencion2."Nº mov." + 1;
        END;
        MovRetencion3.RESET;
        MovRetencion3.SETRANGE(MovRetencion3."Nº documento", Ndocuemnto);
        IF NumMov <> 0 THEN MovRetencion3.SETRANGE("Nº mov.", NumMov);
        IF MovRetencion3.FIND('-') THEN BEGIN
            IF MovRetencion3."Cli/Prov" = MovRetencion3."Cli/Prov"::Cliente THEN BEGIN
                IF NOT HistFactVenta.GET(Ndocuemnto) THEN IF HistAbonVenta.GET(Ndocuemnto) THEN Abono := TRUE;
            END
            ELSE BEGIN
                IF NOT HistFactCompra.GET(Ndocuemnto) THEN IF HistAbonCompra.GET(Ndocuemnto) THEN Abono := TRUE;
            END;
            IF MovRetencion3."Importe Pendiente" < 0 THEN
                MovRetencion3."Importe Pendiente (DL)" := MovRetencion3."Importe Pendiente (DL)" + ABS(Importep)
            ELSE
                MovRetencion3."Importe Pendiente (DL)" := MovRetencion3."Importe Pendiente (DL)" - ABS(Importep);
            IF MovRetencion3."Importe Pendiente (DL)" = 0 THEN BEGIN
                MovRetencion3.Pendiente := FALSE;
                MovRetencion3."Importe Pendiente" := 0;
            END
            ELSE BEGIN
                MovRetencion3."Importe Pendiente" := CurrExchRate.ExchangeAmtLCYToFCY(WORKDATE, MovRetencion3."Cód. divisa", MovRetencion3."Importe Pendiente (DL)", CurrExchRate.ExchangeRate(WORKDATE, MovRetencion3."Cód. divisa"));
            END;
            MovRetencion3."Importe a Liquidar" := MovRetencion3."Importe Pendiente";
            MovRetencion3."Importe a Liquidar (DL)" := MovRetencion3."Importe Pendiente (DL)";
            //++OT2-004391 - 12.09.12 - MBG
            MovRetencion3."Liquidado por Movimiento" := FORMAT(VNumMovReten);
            MovRetencion3.MODIFY;
            //--OT2-004391 - 12.09.12 - MBG
            MovRetencion4.RESET;
            MovRetencion4 := MovRetencion3;
            //TECNOCOM - EFS - 201112 - Llevo el Nº de documento con el que se haya registrado el asiento contable
            MovRetencion4."Nº documento" := LastDocNo;
            MovRetencion4."Nº mov." := VNumMovReten;
            MovRetencion4."Tipo Documento" := MovRetencion4."Tipo Documento"::" ";
            MovRetencion4.Descripción := 'Liq. Retención ' + MovRetencion3."Nº documento";
            MovRetencion4."Fecha registro" := GlobalRETGLEntry."Posting Date";
            MovRetencion4."Importe factura iva incl." := 0;
            MovRetencion4."Base retención" := 0;
            MovRetencion4."% retención" := 0;
            MovRetencion4."Nº asiento" := 0;
            MovRetencion4.Revertido := FALSE;
            MovRetencion4."Revertido por el movimiento nº" := 0;
            MovRetencion4."Nº movimiento revertido" := 0;
            IF Abono THEN BEGIN
                IF MovRetencion3."Cli/Prov" = MovRetencion3."Cli/Prov"::Cliente THEN
                    MovRetencion4."Importe retención (DL)" := ABS(Importep)
                ELSE
                    MovRetencion4."Importe retención (DL)" := -ABS(Importep);
            END
            ELSE BEGIN
                IF MovRetencion3."Cli/Prov" = MovRetencion3."Cli/Prov"::Cliente THEN
                    MovRetencion4."Importe retención (DL)" := -ABS(Importep)
                ELSE
                    MovRetencion4."Importe retención (DL)" := ABS(Importep);
            END;
            MovRetencion4."Cód. divisa" := MovRetencion3."Cód. divisa";
            MovRetencion4."Importe retención" := CurrExchRate.ExchangeAmtLCYToFCY(WORKDATE, MovRetencion4."Cód. divisa", MovRetencion4."Importe retención (DL)", CurrExchRate.ExchangeRate(WORKDATE, MovRetencion4."Cód. divisa"));
            MovRetencion4."Importe Pendiente" := 0;
            MovRetencion4."Importe Pendiente (DL)" := 0;
            MovRetencion4."Liquidado por Movimiento" := FORMAT(MovRetencion3."Nº mov.");
            MovRetencion4."Importe a Liquidar" := 0;
            MovRetencion4."Importe a Liquidar (DL)" := 0;
            MovRetencion4.Pendiente := FALSE;
            MovRetencion4.Factura := GlobalRETGenJnlLine.Factura;
            MovRetencion4.Efecto := GlobalRETGenJnlLine.Efecto;
            MovRetencion4."Tipo Liquidacion" := GlobalRETGenJnlLine."Tipo Liquidacion";
            MovRetencion4."Liquidado por Movimiento" := FORMAT(MovRetencion3."Nº mov.");
            //TECNOCOM TecnoRet - EFS - 070912
            MovRetencion4."Shortcut Dimension 1 Code" := MovRetencion3."Shortcut Dimension 1 Code";
            MovRetencion4."Shortcut Dimension 2 Code" := MovRetencion3."Shortcut Dimension 2 Code";
            MovRetencion4."Shortcut Dimension 3 Code" := MovRetencion3."Shortcut Dimension 3 Code";
            MovRetencion4."Shortcut Dimension 4 Code" := MovRetencion3."Shortcut Dimension 4 Code";
            //FIN TECNOCOM TecnoRet - EFS - 070912
            MovRetencion4.INSERT;
        END;
    END;

    procedure CrearmovretenciónIRPF(NoMov1: Integer; NoProv1: Code[20]; Descrip1: Text[50]; CifNif1: Text[20]; FEmiDoc1: Date; FReg1: Date; NoDoc1: Code[20]; ImpFactura1: Decimal; BaseRet1: Decimal; "%Ret1": Decimal; TipoPer1: Code[10]; ClavePer1: Code[10]; ImpRet1: Decimal; ImpFacSinIva: Decimal; CP1: Code[10]; CodOrigen1: Code[10]; CodDivisa1: Code[10]; AuxTipo: option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund)
    var
        MovRet1: Record "IND Witholding Tax registers";
        Regdivisa1: Record Currency;
        Confrecursos1: Record "Resources Setup";
        Clavepercepcionl1: Record "IND Perception Keys (IRPF)";
        CPl1: Record "Post Code";
        Proveedorl1: Record Vendor;
        Recursol1: Record Resource;
        Hisfaccompral: Record "Purch. Inv. Header";
        Hisabonocompral: Record "Purch. Cr. Memo Hdr.";
        "//-INC-056 IBdos 15.11.10 JGE": Integer;
        FactCompra: Record "Purch. Inv. Header";
        AbonoCompra: Record "Purch. Cr. Memo Hdr.";
        SalesInvoiceHeaderLocal: Record "Sales Invoice Header";
        SalesCrMemoHeaderLocal: Record "Sales Cr.Memo Header";
        "//+INC-056 IBdos 15.11.10 JGE": Integer;
        "//TECNOCOM DSL ----------": Integer;
        PurchInvLineLocal: Record "Purch. Inv. Line";
        PurchCrMemoLineLocal: Record "Purch. Cr. Memo Line";
        Proyecto: code[20];
        GLSetup: record "General Ledger Setup";
        CurrExchRate: record "Currency Exchange Rate";
        NextTransactionNo: integer;
    begin
        //CrearMovRetencion
        Confrecursos1.GET;
        //++ OT2-051963
        // WITH MovRet1 DO BEGIN
        //     "Nº mov." := NoMov1 + 1;
        //     "Nº Proveedor / Nº Cliente" := NoProv1;
        //     Descripción := Descrip1;
        //     "Cif/Nif" := CifNif1;
        //     "Fecha emisión documento" := FEmiDoc1;
        //     "Fecha registro" := FReg1;
        //     "Nº documento" := NoDoc1;
        //     "Tipo Documento" := AuxTipo;
        //     "Importe factura iva incl." := ImpFactura1;
        //     "Importe factura" := ImpFacSinIva;
        //     "Base retención" := ABS(BaseRet1);
        //     "% retención" := "%Ret1";
        //     "Tipo de Perceptor" := TipoPer1;
        //     "Clave de Percepción" := ClavePer1;
        //     "C.P" := CP1;
        //     "Cód. divisa" := CodDivisa1;
        //     Pendiente := TRUE;
        //     VALIDATE("Nº Proyecto", Proyecto);
        //     "Nº asiento" := NextTransactionNo;
        //     "Cód. origen" := CodOrigen1;
        //     Proveedorl1.RESET;
        //     Recursol1.RESET;
        //     IF Proveedorl1.GET(NoProv1) THEN BEGIN
        //         MovRet1."Nombre 1" := Proveedorl1.Name;
        //         MovRet1."Nombre 2/Apellidos" := Proveedorl1."Name 2";
        //     END ELSE
        //         IF Recursol1.GET(NoProv1) THEN BEGIN
        //             MovRet1."Nombre 1" := Recursol1.Name;
        //             MovRet1."Nombre 2/Apellidos" := Recursol1."Name 2";
        //         END;
        //     CPl1.RESET;
        //     IF CPl1.GET(CP1, Proveedorl1.City) THEN BEGIN
        //         "C.P" := CP1;
        //         //MovRet1."Código provincia" := CPl1.County;
        //         MovRet1."Código provincia" := CPl1."County Code";
        //     END;
        //     MovRet1."Año devengo" := DATE2DMY("Fecha registro", 3);
        //     Clavepercepcionl1.RESET;
        //     IF Clavepercepcionl1.GET(ClavePer1) THEN BEGIN
        //         "Clave de Percepción" := ClavePer1;
        //         MovRet1."Cta. retención" := Clavepercepcionl1."Cta. retención";
        //         MovRet1."Clave IRPF" := Clavepercepcionl1."Clave IRPF";
        //         MovRet1."Subclave IRPF" := Clavepercepcionl1."Subclave IRPF";
        //         MovRet1."Tipo percepción" := Clavepercepcionl1."Tipo percepción";
        //         MovRet1."Cli/Prov" := Clavepercepcionl1."Cli/Prov";
        //         MovRet1."Tipo Retención" := Clavepercepcionl1."Tipo Retención";
        //     END;
        //     "Importe retención" := ImpRet1;
        //     IF Regdivisa1.GET(CodDivisa1) THEN
        //         "Importe retención" := ROUND("Importe retención", Regdivisa1."Amount Rounding Precision");
        //     //++MBG TEMPORAL
        //     IF AuxTipo = AuxTipo::Invoice THEN BEGIN
        //         //--MBG TEMPORAL
        //         IF Clavepercepcionl1."Cli/Prov" = Clavepercepcionl1."Cli/Prov"::Proveedor THEN BEGIN
        //             GLSetup.GET;
        //             FactCompra.RESET;
        //             FactCompra.GET(NoDoc1);
        //             "Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                      "Base retención", FactCompra."Currency Factor");
        //             "Base retencion (DL)" := ROUND("Base retencion (DL)", GLSetup."Amount Rounding Precision");
        //             "Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                         "Importe retención", FactCompra."Currency Factor");
        //             "Importe retención (DL)" := ROUND("Importe retención (DL)", GLSetup."Amount Rounding Precision");
        //             "Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                       "Importe factura iva incl.", FactCompra."Currency Factor");
        //             "Importe Factura (DL)" := ROUND("Importe Factura (DL)", GLSetup."Amount Rounding Precision");
        //             MovRet1."Importe Pendiente" := "Importe retención";
        //             MovRet1.Pendiente := TRUE;
        //             MovRet1."Importe a Liquidar" := "Importe retención";
        //             MovRet1."Importe Pendiente (DL)" := "Importe retención (DL)";
        //             MovRet1."Importe a Liquidar (DL)" := "Importe retención (DL)";
        //             //++MBG TEMPORAL
        //             //TECNOCOM TecnoRet - EFS - 070912
        //             MovRet1."Shortcut Dimension 1 Code" := FactCompra."Shortcut Dimension 1 Code";
        //             MovRet1."Shortcut Dimension 2 Code" := FactCompra."Shortcut Dimension 2 Code";
        //             //FIN TECNOCOM TecnoRet - EFS - 070912
        //             //TECNOCOM - GFM - 151216 - OT2-032966
        //             /*CLEAR(PurchInvLineLocal);
        //             PurchInvLineLocal.RESET;
        //             PurchInvLineLocal.SETRANGE("Document No.", NoDoc1);
        //             PurchInvLineLocal.SETRANGE(Type, PurchInvLineLocal.Type::"G/L Account");
        //             IF PurchInvLineLocal.FINDFIRST THEN BEGIN
        //                 MovRet1."Ref. Catastral" := PurchInvLineLocal."Ref. Catastral";
        //             END;*/
        //             //FIN TECNOCOM - GFM - 151216 - OT2-032966
        //         END ELSE BEGIN
        //             GLSetup.GET;
        //             SalesInvoiceHeaderLocal.RESET;
        //             SalesInvoiceHeaderLocal.GET(NoDoc1);
        //             "Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                      "Base retención", SalesInvoiceHeaderLocal."Currency Factor");
        //             "Base retencion (DL)" := ROUND("Base retencion (DL)", GLSetup."Amount Rounding Precision");
        //             "Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                         "Importe retención", SalesInvoiceHeaderLocal."Currency Factor");
        //             "Importe retención (DL)" := ROUND("Importe retención (DL)", GLSetup."Amount Rounding Precision");
        //             "Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                       "Importe factura iva incl.", SalesInvoiceHeaderLocal."Currency Factor");
        //             "Importe Factura (DL)" := ROUND("Importe Factura (DL)", GLSetup."Amount Rounding Precision");
        //             MovRet1."Importe Pendiente" := "Importe retención";
        //             MovRet1.Pendiente := TRUE;
        //             MovRet1."Importe a Liquidar" := "Importe retención";
        //             MovRet1."Importe Pendiente (DL)" := "Importe retención (DL)";
        //             MovRet1."Importe a Liquidar (DL)" := "Importe retención (DL)";
        //             MovRet1."Shortcut Dimension 1 Code" := SalesInvoiceHeaderLocal."Shortcut Dimension 1 Code";
        //             MovRet1."Shortcut Dimension 2 Code" := SalesInvoiceHeaderLocal."Shortcut Dimension 2 Code";
        //         END;
        //     END ELSE BEGIN
        //         IF AuxTipo = AuxTipo::"Credit Memo" THEN BEGIN
        //             IF Clavepercepcionl1."Cli/Prov" = Clavepercepcionl1."Cli/Prov"::Proveedor THEN BEGIN
        //                 GLSetup.GET;
        //                 AbonoCompra.RESET;
        //                 AbonoCompra.GET(NoDoc1);
        //                 "Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                          "Base retención", AbonoCompra."Currency Factor");
        //                 "Base retencion (DL)" := ROUND("Base retencion (DL)", GLSetup."Amount Rounding Precision");
        //                 "Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                             "Importe retención", AbonoCompra."Currency Factor");
        //                 "Importe retención (DL)" := ROUND("Importe retención (DL)", GLSetup."Amount Rounding Precision");
        //                 "Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                           "Importe factura iva incl.", AbonoCompra."Currency Factor");
        //                 "Importe Factura (DL)" := ROUND("Importe Factura (DL)", GLSetup."Amount Rounding Precision");
        //                 MovRet1."Importe Pendiente" := "Importe retención";
        //                 MovRet1.Pendiente := TRUE;
        //                 MovRet1."Importe a Liquidar" := "Importe retención";
        //                 MovRet1."Importe Pendiente (DL)" := "Importe retención (DL)";
        //                 MovRet1."Importe a Liquidar (DL)" := "Importe retención (DL)";
        //                 //TECNOCOM TecnoRet - EFS - 070912
        //                 MovRet1."Shortcut Dimension 1 Code" := AbonoCompra."Shortcut Dimension 1 Code";
        //                 MovRet1."Shortcut Dimension 2 Code" := AbonoCompra."Shortcut Dimension 2 Code";
        //                 //FIN TECNOCOM TecnoRet - EFS - 070912
        //                 //TECNOCOM - GFM - 151216 - OT2-032966
        //                 /*CLEAR(PurchCrMemoLineLocal);
        //                 PurchCrMemoLineLocal.RESET;
        //                 PurchCrMemoLineLocal.SETRANGE("Document No.", NoDoc1);
        //                 PurchCrMemoLineLocal.SETRANGE(Type, PurchCrMemoLineLocal.Type::"G/L Account");
        //                 IF PurchCrMemoLineLocal.FINDFIRST THEN BEGIN
        //                     MovRet1."Ref. Catastral" := PurchCrMemoLineLocal."Ref. Catastral";
        //                 END;*/
        //                 //FIN TECNOCOM - GFM - 151216 - OT2-032966
        //             END ELSE BEGIN
        //                 GLSetup.GET;
        //                 SalesCrMemoHeaderLocal.RESET;
        //                 SalesCrMemoHeaderLocal.GET(NoDoc1);
        //                 "Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                          "Base retención", SalesCrMemoHeaderLocal."Currency Factor");
        //                 "Base retencion (DL)" := ROUND("Base retencion (DL)", GLSetup."Amount Rounding Precision");
        //                 "Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                             "Importe retención", SalesCrMemoHeaderLocal."Currency Factor");
        //                 "Importe retención (DL)" := ROUND("Importe retención (DL)", GLSetup."Amount Rounding Precision");
        //                 "Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa",
        //                                           "Importe factura iva incl.", SalesCrMemoHeaderLocal."Currency Factor");
        //                 "Importe Factura (DL)" := ROUND("Importe Factura (DL)", GLSetup."Amount Rounding Precision");
        //                 MovRet1."Importe Pendiente" := "Importe retención";
        //                 MovRet1.Pendiente := TRUE;
        //                 MovRet1."Importe a Liquidar" := "Importe retención";
        //                 MovRet1."Importe Pendiente (DL)" := "Importe retención (DL)";
        //                 MovRet1."Importe a Liquidar (DL)" := "Importe retención (DL)";
        //                 MovRet1."Shortcut Dimension 1 Code" := SalesCrMemoHeaderLocal."Shortcut Dimension 1 Code";
        //                 MovRet1."Shortcut Dimension 2 Code" := SalesCrMemoHeaderLocal."Shortcut Dimension 2 Code";
        //             END;
        //         END;
        //     END;
        //     IF AuxTipo = AuxTipo::"Credit Memo" THEN BEGIN
        //         "Base retencion (DL)" := -"Base retencion (DL)";
        //         "Base retención" := -"Base retención";
        //     END;
        //     //--MBG TEMPORAL
        //     CLEAR(Hisfaccompral);
        //     Hisfaccompral.RESET;
        //     IF Hisfaccompral.GET(NoDoc1) THEN BEGIN
        //         País := Hisfaccompral."Buy-from Country/Region Code";
        //         //TECNOCOM DSL - Insertamos el código Inmueble en el movimiento de retención
        //         //Falta Subir Desarrollo AMS
        //         /*PuchInvLineLocal.RESET;
        //               PuchInvLineLocal.SETRANGE("Document No.", NoDoc1);
        //               IF PuchInvLineLocal.FINDSET THEN
        //                   REPEAT
        //                       IF PuchInvLineLocal."Ref. Catastral" <> '' THEN
        //                           "Cod Inmueble" := PuchInvLineLocal."Ref. Catastral";
        //                   UNTIL PuchInvLineLocal.NEXT = 0;*/
        //         //FIN TECNOCOM DSL
        //     END ELSE BEGIN
        //         CLEAR(Hisabonocompral);
        //         Hisabonocompral.RESET;
        //         IF Hisabonocompral.GET(NoDoc1) THEN
        //             País := Hisabonocompral."Buy-from Country/Region Code";
        //     END;
        //     CLEAR(SalesInvoiceHeaderLocal);
        //     SalesInvoiceHeaderLocal.RESET;
        //     IF SalesInvoiceHeaderLocal.GET(NoDoc1) THEN
        //         // TEC1 (15/04/14) (Est  asignando el Código Cliente en lugar de Código País)
        //         //País:= SalesInvoiceHeaderLocal."Sell-to Customer No."
        //         País := SalesInvoiceHeaderLocal."Sell-to Country/Region Code"
        //     // TEC1 (15/04/14) (Est  asignando el Código Cliente en lugar de Código País)
        //     ELSE BEGIN
        //         CLEAR(SalesCrMemoHeaderLocal);
        //         SalesCrMemoHeaderLocal.RESET;
        //         IF SalesCrMemoHeaderLocal.GET(NoDoc1) THEN
        //             // TEC1 (15/04/14) (Est  asignando el Código Cliente en lugar de Código País)
        //             //País:= SalesCrMemoHeaderLocal."Sell-to Customer No.";
        //             País := SalesCrMemoHeaderLocal."Sell-to Country/Region Code";
        //         // TEC1 (15/04/14) (Est  asignando el Código Cliente en lugar de Código País)
        //     END;
        //     INSERT;
        MovRet1."Nº mov." := NoMov1 + 1;
        MovRet1."Nº Proveedor / Nº Cliente" := NoProv1;
        MovRet1.Descripción := Descrip1;
        MovRet1."Cif/Nif" := CifNif1;
        MovRet1."Fecha emisión documento" := FEmiDoc1;
        MovRet1."Fecha registro" := FReg1;
        MovRet1."Nº documento" := NoDoc1;
        MovRet1."Tipo Documento" := AuxTipo;
        MovRet1."Importe factura iva incl." := ImpFactura1;
        MovRet1."Importe factura" := ImpFacSinIva;
        MovRet1."Base retención" := ABS(BaseRet1);
        MovRet1."% retención" := "%Ret1";
        MovRet1."Tipo de Perceptor" := TipoPer1;
        MovRet1."Clave de Percepción" := ClavePer1;
        MovRet1."C.P" := CP1;
        MovRet1."Cód. divisa" := CodDivisa1;
        MovRet1.Pendiente := TRUE;
        MovRet1.VALIDATE("Nº Proyecto", Proyecto);
        MovRet1."Nº asiento" := NextTransactionNo;
        MovRet1."Cód. origen" := CodOrigen1;
        Proveedorl1.RESET;
        Recursol1.RESET;
        IF Proveedorl1.GET(NoProv1) THEN BEGIN
            MovRet1."Nombre 1" := Proveedorl1.Name;
            MovRet1."Nombre 2/Apellidos" := Proveedorl1."Name 2";
        END
        ELSE IF Recursol1.GET(NoProv1) THEN BEGIN
            MovRet1."Nombre 1" := Recursol1.Name;
            MovRet1."Nombre 2/Apellidos" := Recursol1."Name 2";
        END;
        CPl1.RESET;
        IF CPl1.GET(CP1, Proveedorl1.City) THEN BEGIN
            MovRet1."C.P" := CP1;
            //MovRet1."Código provincia" := CPl1.County;
            MovRet1."Código provincia" := CPl1."County Code";
        END;
        MovRet1."Año devengo" := DATE2DMY(MovRet1."Fecha registro", 3);
        Clavepercepcionl1.RESET;
        IF Clavepercepcionl1.GET(ClavePer1) THEN BEGIN
            MovRet1."Clave de Percepción" := ClavePer1;
            MovRet1."Cta. retención" := Clavepercepcionl1."Cta. retención";
            MovRet1."Clave IRPF" := Clavepercepcionl1."Clave IRPF";
            MovRet1."Subclave IRPF" := Clavepercepcionl1."Subclave IRPF";
            MovRet1."Tipo percepción" := Clavepercepcionl1."Tipo percepción";
            MovRet1."Cli/Prov" := Clavepercepcionl1."Cli/Prov";
            MovRet1."Tipo Retención" := Clavepercepcionl1."Tipo Retención";
        END;
        MovRet1."Importe retención" := ImpRet1;
        IF Regdivisa1.GET(CodDivisa1) THEN MovRet1."Importe retención" := ROUND(MovRet1."Importe retención", Regdivisa1."Amount Rounding Precision");
        //++MBG TEMPORAL
        IF AuxTipo = AuxTipo::Invoice THEN BEGIN
            //--MBG TEMPORAL
            IF Clavepercepcionl1."Cli/Prov" = Clavepercepcionl1."Cli/Prov"::Proveedor THEN BEGIN
                GLSetup.GET;
                FactCompra.RESET;
                FactCompra.GET(NoDoc1);
                MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Base retención", FactCompra."Currency Factor");
                MovRet1."Base retencion (DL)" := ROUND(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
                MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Importe retención", FactCompra."Currency Factor");
                MovRet1."Importe retención (DL)" := ROUND(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
                MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", FactCompra."Currency Factor");
                MovRet1."Importe Factura (DL)" := ROUND(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
                MovRet1."Importe Pendiente" := MovRet1."Importe retención";
                MovRet1.Pendiente := TRUE;
                MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
                MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
                MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
                //++MBG TEMPORAL
                //TECNOCOM TecnoRet - EFS - 070912
                MovRet1."Shortcut Dimension 1 Code" := FactCompra."Shortcut Dimension 1 Code";
                MovRet1."Shortcut Dimension 2 Code" := FactCompra."Shortcut Dimension 2 Code";
                //FIN TECNOCOM TecnoRet - EFS - 070912
                //TECNOCOM - GFM - 151216 - OT2-032966
                /*CLEAR(PurchInvLineLocal);
                    PurchInvLineLocal.RESET;
                    PurchInvLineLocal.SETRANGE("Document No.", NoDoc1);
                    PurchInvLineLocal.SETRANGE(Type, PurchInvLineLocal.Type::"G/L Account");
                    IF PurchInvLineLocal.FINDFIRST THEN BEGIN
                        MovRet1."Ref. Catastral" := PurchInvLineLocal."Ref. Catastral";
                    END;*/
                //FIN TECNOCOM - GFM - 151216 - OT2-032966
            END
            ELSE BEGIN
                GLSetup.GET;
                SalesInvoiceHeaderLocal.RESET;
                SalesInvoiceHeaderLocal.GET(NoDoc1);
                MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Base retención", SalesInvoiceHeaderLocal."Currency Factor");
                MovRet1."Base retencion (DL)" := ROUND(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
                MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Importe retención", SalesInvoiceHeaderLocal."Currency Factor");
                MovRet1."Importe retención (DL)" := ROUND(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
                MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", SalesInvoiceHeaderLocal."Currency Factor");
                MovRet1."Importe Factura (DL)" := ROUND(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
                MovRet1."Importe Pendiente" := MovRet1."Importe retención";
                MovRet1.Pendiente := TRUE;
                MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
                MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
                MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
                MovRet1."Shortcut Dimension 1 Code" := SalesInvoiceHeaderLocal."Shortcut Dimension 1 Code";
                MovRet1."Shortcut Dimension 2 Code" := SalesInvoiceHeaderLocal."Shortcut Dimension 2 Code";
            END;
        END
        ELSE BEGIN
            IF AuxTipo = AuxTipo::"Credit Memo" THEN BEGIN
                IF Clavepercepcionl1."Cli/Prov" = Clavepercepcionl1."Cli/Prov"::Proveedor THEN BEGIN
                    GLSetup.GET;
                    AbonoCompra.RESET;
                    AbonoCompra.GET(NoDoc1);
                    MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Base retención", AbonoCompra."Currency Factor");
                    MovRet1."Base retencion (DL)" := ROUND(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
                    MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Importe retención", AbonoCompra."Currency Factor");
                    MovRet1."Importe retención (DL)" := ROUND(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
                    MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", AbonoCompra."Currency Factor");
                    MovRet1."Importe Factura (DL)" := ROUND(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
                    MovRet1."Importe Pendiente" := MovRet1."Importe retención";
                    MovRet1.Pendiente := TRUE;
                    MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
                    MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
                    MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
                    //TECNOCOM TecnoRet - EFS - 070912
                    MovRet1."Shortcut Dimension 1 Code" := AbonoCompra."Shortcut Dimension 1 Code";
                    MovRet1."Shortcut Dimension 2 Code" := AbonoCompra."Shortcut Dimension 2 Code";
                    //FIN TECNOCOM TecnoRet - EFS - 070912
                    //TECNOCOM - GFM - 151216 - OT2-032966
                    /*CLEAR(PurchCrMemoLineLocal);
                        PurchCrMemoLineLocal.RESET;
                        PurchCrMemoLineLocal.SETRANGE("Document No.", NoDoc1);
                        PurchCrMemoLineLocal.SETRANGE(Type, PurchCrMemoLineLocal.Type::"G/L Account");
                        IF PurchCrMemoLineLocal.FINDFIRST THEN BEGIN
                            MovRet1."Ref. Catastral" := PurchCrMemoLineLocal."Ref. Catastral";
                        END;*/
                    //FIN TECNOCOM - GFM - 151216 - OT2-032966
                END
                ELSE BEGIN
                    GLSetup.GET;
                    SalesCrMemoHeaderLocal.RESET;
                    SalesCrMemoHeaderLocal.GET(NoDoc1);
                    MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Base retención", SalesCrMemoHeaderLocal."Currency Factor");
                    MovRet1."Base retencion (DL)" := ROUND(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
                    MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Importe retención", SalesCrMemoHeaderLocal."Currency Factor");
                    MovRet1."Importe retención (DL)" := ROUND(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
                    MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", SalesCrMemoHeaderLocal."Currency Factor");
                    MovRet1."Importe Factura (DL)" := ROUND(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
                    MovRet1."Importe Pendiente" := MovRet1."Importe retención";
                    MovRet1.Pendiente := TRUE;
                    MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
                    MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
                    MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
                    MovRet1."Shortcut Dimension 1 Code" := SalesCrMemoHeaderLocal."Shortcut Dimension 1 Code";
                    MovRet1."Shortcut Dimension 2 Code" := SalesCrMemoHeaderLocal."Shortcut Dimension 2 Code";
                END;
            END;
        END;
        IF AuxTipo = AuxTipo::"Credit Memo" THEN BEGIN
            MovRet1."Base retencion (DL)" := -MovRet1."Base retencion (DL)";
            MovRet1."Base retención" := -MovRet1."Base retención";
        END;
        //--MBG TEMPORAL
        CLEAR(Hisfaccompral);
        Hisfaccompral.RESET;
        IF Hisfaccompral.GET(NoDoc1) THEN BEGIN
            MovRet1.País := Hisfaccompral."Buy-from Country/Region Code";
            //TECNOCOM DSL - Insertamos el código Inmueble en el movimiento de retención
            //Falta Subir Desarrollo AMS
            /*PuchInvLineLocal.RESET;
                      PuchInvLineLocal.SETRANGE("Document No.", NoDoc1);
                      IF PuchInvLineLocal.FINDSET THEN
                          REPEAT
                              IF PuchInvLineLocal."Ref. Catastral" <> '' THEN
                                  "Cod Inmueble" := PuchInvLineLocal."Ref. Catastral";
                          UNTIL PuchInvLineLocal.NEXT = 0;*/
            //FIN TECNOCOM DSL
        END
        ELSE BEGIN
            CLEAR(Hisabonocompral);
            Hisabonocompral.RESET;
            IF Hisabonocompral.GET(NoDoc1) THEN MovRet1.País := Hisabonocompral."Buy-from Country/Region Code";
        END;
        CLEAR(SalesInvoiceHeaderLocal);
        SalesInvoiceHeaderLocal.RESET;
        IF SalesInvoiceHeaderLocal.GET(NoDoc1) THEN // TEC1 (15/04/14) (Est  asignando el Código Cliente en lugar de Código País)
            //País:= SalesInvoiceHeaderLocal."Sell-to Customer No."
            MovRet1.País := SalesInvoiceHeaderLocal."Sell-to Country/Region Code"
        // TEC1 (15/04/14) (Est  asignando el Código Cliente en lugar de Código País)
        ELSE BEGIN
            CLEAR(SalesCrMemoHeaderLocal);
            SalesCrMemoHeaderLocal.RESET;
            IF SalesCrMemoHeaderLocal.GET(NoDoc1) THEN // TEC1 (15/04/14) (Est  asignando el Código Cliente en lugar de Código País)
                //País:= SalesCrMemoHeaderLocal."Sell-to Customer No.";
                MovRet1.País := SalesCrMemoHeaderLocal."Sell-to Country/Region Code";
            // TEC1 (15/04/14) (Est  asignando el Código Cliente en lugar de Código País)
        END;
        MovRet1.INSERT;
        // end;
        //-- OT2-051963
    end;

    procedure CrearRetencionIRPF(Tipo: option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,Bill; Num: Code[20]; Imp: Decimal; SourcCode: Code[10]; Tipopercep: Code[10]; Clavepercep: Code[10]; BaseRet: Decimal; Proy: Code[20]; Desc: Text[50]; DocDate: Date; PostDate: Date; ImpFactura: Decimal; CP: Code[20]; CurrencyCode: Code[10]; PorcRet: Decimal; ProvCLi: Code[20]; CifNif: Text[20]; ImpFacturaSinIva: Decimal)
    var
        InfoEmp1: Record "Company Information";
        ConfConta: Record "General Ledger Setup";
        FacCompra1: Record "Purch. Inv. Header";
        LinFacCompra1: Record "Purch. Inv. Line";
        AboCompra1: Record "Purch. Cr. Memo Hdr.";
        LinAboCompra1: Record "Purch. Cr. Memo Line";
        NoMovRet1: Integer;
        GLSetup: record "General Ledger Setup";
        Proyecto: code[20];
        NMovRentencion: integer;
    begin
        //CrearRetencion
        //Evaluamos si la línea proviene de una factura o directamente de un diario.
        CASE Tipo OF //Diario.
            Tipo::" ":
                BEGIN
                    //Tenemos que evaluar si la línea es de liquidación de la cuenta o si es una nómina.
                    ConfConta.GET;
                    InfoEmp1.GET;
                    IF (Tipopercep = GLSetup."Tipo perceptor liq.") THEN BEGIN
                        IF (Tipopercep <> ConfConta."Tipo perceptor liq.") THEN BEGIN
                            NoMovRet1 := TraerNoMovRetencion;
                            Proyecto := Proy;
                            IF Imp < 0 THEN
                                CrearmovretenciónIRPF(NoMovRet1, ProvCLi, Desc, CifNif, DocDate, PostDate, Num, ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, CP, SourcCode, CurrencyCode, Tipo::" ")
                            ELSE
                                CrearmovretenciónIRPF(NoMovRet1, ProvCLi, Desc, CifNif, DocDate, PostDate, Num, ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, CP, SourcCode, CurrencyCode, Tipo::" ")
                        END;
                    END;
                END;
            //Factura
            Tipo::Invoice:
                BEGIN
                    //Traemos el documento.
                    IF FacCompra1.GET(Num) THEN BEGIN
                        FacCompra1.CALCFIELDS("Amount Including VAT", Amount);
                        LinFacCompra1.RESET;
                        LinFacCompra1.SETRANGE("Document No.", FacCompra1."No.");
                        LinFacCompra1.SETRANGE("Lín. retención", TRUE);
                        IF LinFacCompra1.FIND('-') THEN BEGIN
                            NoMovRet1 := TraerNoMovRetencion;
                            Proyecto := LinFacCompra1."Job No.";
                            CrearmovretenciónIRPF(NoMovRet1, FacCompra1."Pay-to Vendor No.", FacCompra1."Pay-to Name", FacCompra1."VAT Registration No.", FacCompra1."Document Date", FacCompra1."Posting Date", FacCompra1."No.", ImpFacturaSinIva, -BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, FacCompra1."Pay-to Post Code", SourcCode, FacCompra1."Currency Code", Tipo::Invoice);
                            //TECNOCOM - EFS - 070912
                            NMovRentencion := UltMovRetención;
                            PasarDimensionesRet(LinFacCompra1."Document No.", LinFacCompra1."Line No.", NMovRentencion, TRUE, FALSE);
                            //FIN TECNOCOM - EFS - 070912
                        END;
                    END;
                END;
            //Abono
            Tipo::"Credit Memo":
                BEGIN
                    //Traemos el documento.
                    IF AboCompra1.GET(Num) THEN BEGIN
                        AboCompra1.CALCFIELDS("Amount Including VAT", Amount);
                        LinAboCompra1.RESET;
                        LinAboCompra1.SETRANGE("Document No.", AboCompra1."No.");
                        LinAboCompra1.SETRANGE("Lín. retención", TRUE);
                        IF LinAboCompra1.FIND('-') THEN BEGIN
                            NoMovRet1 := TraerNoMovRetencion;
                            Proyecto := LinAboCompra1."Job No.";
                            CrearmovretenciónIRPF(NoMovRet1, AboCompra1."Pay-to Vendor No.", AboCompra1."Pay-to Name", AboCompra1."VAT Registration No.", AboCompra1."Document Date", AboCompra1."Posting Date", //AboCompra1."No.",AboCompra1."Amount Including VAT",BaseRet,PorcRet,Tipopercep,Clavepercep,
                            AboCompra1."No.", -ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, //-Imp,AboCompra1.Amount,AboCompra1."Pay-to Post Code",SourcCode,AboCompra1."Currency Code",
                            -Imp, -ImpFactura, AboCompra1."Pay-to Post Code", SourcCode, AboCompra1."Currency Code", Tipo::"Credit Memo");
                            //TECNOCOM - EFS - 070912
                            NMovRentencion := UltMovRetención;
                            PasarDimensionesRet(LinAboCompra1."Document No.", LinAboCompra1."Line No.", NMovRentencion, FALSE, FALSE);
                            //FIN TECNOCOM - EFS - 070912
                        END;
                    END;
                END;
        END;
    end;

    PROCEDURE UltMovRetención(): Integer;
    VAR
        AuxMovRetención: Record "IND Witholding Tax registers";
        RVendor: Record vendor;
        RCustomer: Record customer;
    BEGIN
        AuxMovRetención.RESET;
        IF AuxMovRetención.FINDLAST THEN EXIT(AuxMovRetención."Nº mov.");
    END;

    PROCEDURE PasarDimensionesRet(Ndoc: Code[20]; Nlinea: Integer; UltimoMovRet: Integer; Factura: Boolean; Venta: Boolean);
    VAR
        HistFactLinCompra: Record "Purch. Inv. Line";
        HistFactLinVenta: Record "Sales Invoice Line";
        HistAbonoLinCompra: Record "Purch. Cr. Memo Line";
        HistAbonoLinVenta: Record "Sales Cr.Memo Line";
        RcdMovRet: Record "IND Witholding Tax registers";
    BEGIN
        RcdMovRet.GET(UltimoMovRet);
        IF Factura THEN BEGIN
            IF Venta THEN BEGIN
                HistFactLinVenta.GET(Ndoc, Nlinea);
                RcdMovRet."Shortcut Dimension 1 Code" := HistFactLinVenta."Shortcut Dimension 1 Code";
                RcdMovRet."Shortcut Dimension 2 Code" := HistFactLinVenta."Shortcut Dimension 2 Code";
            END
            ELSE BEGIN
                HistFactLinCompra.GET(Ndoc, Nlinea);
                RcdMovRet."Shortcut Dimension 1 Code" := HistFactLinCompra."Shortcut Dimension 1 Code";
                RcdMovRet."Shortcut Dimension 2 Code" := HistFactLinCompra."Shortcut Dimension 2 Code";
            END;
        END
        ELSE BEGIN
            IF Venta THEN BEGIN
                HistAbonoLinVenta.GET(Ndoc, Nlinea);
                RcdMovRet."Shortcut Dimension 1 Code" := HistAbonoLinVenta."Shortcut Dimension 1 Code";
                RcdMovRet."Shortcut Dimension 2 Code" := HistAbonoLinVenta."Shortcut Dimension 2 Code";
            END
            ELSE BEGIN
                HistAbonoLinCompra.GET(Ndoc, Nlinea);
                RcdMovRet."Shortcut Dimension 1 Code" := HistAbonoLinCompra."Shortcut Dimension 1 Code";
                RcdMovRet."Shortcut Dimension 2 Code" := HistAbonoLinCompra."Shortcut Dimension 2 Code";
            END;
        END;
        RcdMovRet.MODIFY;
    END;
    //Codeunit 12 FIN
}
