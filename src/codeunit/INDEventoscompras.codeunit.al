namespace ScriptumVita.IRPF;

codeunit 86300 "IND Eventos compras"
{
    // version INDRA
    //Codeunit 90
    //++ OT2-062971 Se cambia al evento OnAfterProcessPurchLines porque con la 23 no funciona el antiguo
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchLines', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterProcessPurchLines', '', false, false)]
    //-- OT2-062971
    local procedure CrearRetencionesLineas(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchLine.SETRANGE("Document No.", PurchHeader."No.");
        if PurchLine.FINDSET then
            repeat
                IF PurchLine."Lín. retención" THEN //081220>>añado Credit memo
                    //CreaRetencionesCompras(PurchLine, PurchHeader, PurchInvHeader);
                    CreaRetencionesCompras(PurchLine, PurchHeader, PurchInvHeader, PurchCrMemoHdr);
            //081220202<<
            until PurchLine.next = 0;
    end;

    procedure CreaRetencionesCompras(PurchLine: record "Purchase Line"; PurchHeader: Record "Purchase Header"; PurchInvHeader: Record "Purch. Inv. Header"; PurchInvCrMemo: record "Purch. Cr. Memo Hdr.")
    var
        Cuenta: record "G/L Account";
        SourceCodeSetup: record "Source Code Setup";
        SrcCode: code[10];
        GenJnlLineDocType: integer;
        GenJnlLineDocNo: code[20];
        ImpTotal: decimal;
        ImpTotalSinIVA: decimal;
        GenJnlLine: Record 81;
    begin
        Cuenta.GET(PurchLine."No.");
        IF (PurchLine."Mov. retención" = 0) THEN BEGIN
            //extra LTM
            SourceCodeSetup.GET;
            SrcCode := SourceCodeSetup.Sales;
            //++ OT2-051963
            if PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice then begin
                //GenJnlLineDocType := GenJnlLine."Document Type"::Invoice;
                GenJnlLineDocType := GenJnlLine."Document Type"::Invoice.AsInteger();
                //08122020>>
                GenJnlLineDocNo := PurchInvHeader."No.";
                //08122020<<
            end
            else begin
                //GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo";
                GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo".AsInteger();
                //08122020>>
                GenJnlLineDocNo := PurchInvCrMemo."No.";
                //08122020<<
                //-- OT2-051963
            end;
            //08122020>>
            //GenJnlLineDocNo := PurchInvHeader."No.";
            //08122020<<
            //extra LTM
            PurchHeader.CALCFIELDS(Amount, "Amount Including VAT");
            //08122020>>
            PurchHeader.CALCFIELDS("Importe IRPF", "Importe IVA incl.IRPF");
            //08122020<<
            IF (Cuenta."Tipo Cuenta Retención" = Cuenta."Tipo Cuenta Retención"::Proveedor) AND (Purchline."Mov. retención" = 0) THEN BEGIN
                IF Purchline."Document Type" = Purchline."Document Type"::Order THEN BEGIN
                    PurchInvHeader.CALCFIELDS("Amount Including VAT", Amount);
                    ImpTotal := PurchInvHeader."Amount Including VAT";
                    ImpTotalSinIva := PurchInvHeader.Amount;
                END
                ELSE BEGIN
                    //08122020>>
                    /*
                    ImpTotal := PurchHeader."Amount Including VAT";
                    ImpTotalSinIva := PurchHeader.Amount;
                    */
                    ImpTotal := PurchHeader."Importe IVA incl.IRPF";
                    ImpTotalSinIva := PurchHeader."Importe IRPF";
                    //08122020>>
                END;
                CrearRetencionIRPF(GenJnlLineDocType, GenJnlLineDocNo, PurchLine.Amount, SrcCode, PurchLine."Tipo Percepción", PurchLine."Clave Percepción", PurchLine."Qty. to Invoice", PurchLine."Job No.", PurchHeader."Posting Description", PurchHeader."Document Date", PurchHeader."Posting Date", ImpTotalSinIva, PurchHeader."Buy-from Post Code", PurchHeader."Currency Code", -(PurchLine."Direct Unit Cost" * 100), PurchHeader."Buy-from Vendor No.", PurchHeader."VAT Registration No.", ImpTotal);
            END;
            IF (Cuenta."Tipo Cuenta Retención" = Cuenta."Tipo Cuenta Retención"::Cliente) AND (PurchLine."Mov. retención" = 0) THEN CrearRetencionIRPF(GenJnlLineDocType, GenJnlLineDocNo, PurchLine.Amount, SrcCode, PurchLine."Tipo Percepción", PurchLine."Clave Percepción", PurchLine."Qty. to Invoice", PurchLine."Job No.", PurchHeader."Posting Description", PurchHeader."Document Date", PurchHeader."Posting Date", PurchHeader.Amount, PurchHeader."Buy-from Post Code", PurchHeader."Currency Code", -(PurchLine."Direct Unit Cost" * 100), PurchHeader."Buy-from Vendor No.", PurchHeader."VAT Registration No.", PurchHeader."Amount Including VAT");
        END
        ELSE IF (PurchLine."Mov. retención" <> 0) THEN LiqRetencion(PurchInvHeader."No.", PurchLine."Mov. retención", PurchLine.Amount, PurchInvHeader."Posting Date");
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
                                                                                                                                                                                                                 //++ OT2-055642
                                                                                                                                                                                                                 //AboCompra1."No.", -ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep,
                            AboCompra1."No.", ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, //-- OT2-055642
                                                                                                           //-Imp,AboCompra1.Amount,AboCompra1."Pay-to Post Code",SourcCode,AboCompra1."Currency Code",
                                                                                                           //++ OT2-055642
                                                                                                           //-Imp, -ImpFactura, AboCompra1."Pay-to Post Code", SourcCode, AboCompra1."Currency Code",
                            Imp, ImpFactura, AboCompra1."Pay-to Post Code", SourcCode, AboCompra1."Currency Code", //-- OT2-055642
                            Tipo::"Credit Memo");
                            //TECNOCOM - EFS - 070912
                            NMovRentencion := UltMovRetención;
                            PasarDimensionesRet(LinAboCompra1."Document No.", LinAboCompra1."Line No.", NMovRentencion, FALSE, FALSE);
                            //FIN TECNOCOM - EFS - 070912
                        END;
                    END;
                END;
        END;
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
        // end;
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
    end;
    //-- OT2-051963
    procedure LiqRetencion(VAR Ndocuemnto: Code[20]; NumMov: Integer; Importep: Decimal; FechaReg: Date)
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
    begin
        MovRetencion2.LOCKTABLE;
        MovRetencion2.RESET;
        IF MovRetencion2.FIND('+') THEN BEGIN
            VNumMovReten := MovRetencion2."Nº mov." + 1;
        END;
        MovRetencion3.RESET;
        //MovRetencion3.SETRANGE(MovRetencion3."Nº documento", Ndocuemnto);
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
            MovRetencion4."Nº documento" := Ndocuemnto;
            MovRetencion4."Nº mov." := VNumMovReten;
            MovRetencion4."Tipo Documento" := MovRetencion4."Tipo Documento"::" ";
            MovRetencion4.Descripción := 'Liq. Retención ' + MovRetencion3."Nº documento";
            MovRetencion4."Fecha registro" := FechaReg;
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
            MovRetencion4.Factura := MovRetencion4.Factura::"Con factura";
            MovRetencion4.Efecto := MovRetencion3.Efecto;
            MovRetencion4."Tipo Liquidacion" := MovRetencion3."Tipo Liquidacion";
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterCheckPurchDoc', '', false, false)]
    local procedure CrearLineaRetencionPedidoCm(var PurchHeader: Record "Purchase Header")
    begin
        //TECNOCOM - TecnoRet - 001
        IF (PurchHeader."Document Type" IN [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::"Return Order"]) AND (PurchHeader."Clave Percepción" <> '') AND PurchHeader.Invoice THEN PurchHeader.CreaLinRetencionPedido(PurchHeader);
        //FIN TECNOCOM - TecnoRet - 001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterDeleteAfterPosting', '', false, false)]
    local procedure EliminarLineas(PurchHeader: Record "Purchase Header")
    var
        PurchLine: record "Purchase Line";
    begin
        //TECNOCOM - TecnoRet - 006 - 007
        IF (PurchHeader."Document Type" IN [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::"Return Order"]) AND (PurchHeader."Clave Percepción" <> '') AND PurchHeader.Invoice THEN BEGIN
            CLEAR(PurchLine);
            PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
            PurchLine.SETRANGE("Document No.", PurchHeader."No.");
            PurchLine.SETRANGE("Lín. retención", TRUE);
            PurchLine.DELETEALL;
        END;
        //FIN TECNOCOM - TecnoRet - 006 - 007
    end;
    /* [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', false, false)]
    local procedure OnAfterPurchRcptLineInsert_purchpost(PurchaseLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        IF PurchaseLine."Lín. retención" THEN
            PurchRcptLine.Delete();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterReturnShptLineInsert', '', false, false)]
    local procedure OnAfterReturnShptLineInsert_purchpost(PurchLine: Record "Purchase Line"; var ReturnShptLine: Record "Return Shipment Line")
    begin
        IF PurchLine."Lín. retención" THEN
            ReturnShptLine.Delete();
    end;
 */
    //Codeunit 90 FIN
    //Codeunit 91
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure ComprobarLineasRetencion(var PurchaseHeader: Record "Purchase Header")
    var
        PurchSetup: record "Purchases & Payables Setup";
    begin
        IF NOT PurchSetup."Post with Job Queue" THEN BEGIN
            //TECNOCOM - TecnoRet
            IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) AND (PurchaseHeader."Clave Percepción" <> '') THEN //++001 IND
                CompruebaLinRet(PurchaseHeader);
            //--001 IND
            //08122020>>
            IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"credit memo") AND (PurchaseHeader."Clave Percepción" <> '') THEN //++001 IND
                CompruebaLinRet(PurchaseHeader);
            //08122020<<
            //FIN TECNOCOM - TecnoRet
        END;
    end;

    PROCEDURE CompruebaLinRet(CabCompra: Record 38);
    VAR
        LinCompra: Record 39;
        LocalText001: Label 'El/la %1 no tiene generada la l¡nea de retención.';
        LocalText002: Label 'El proceso se ha interrumpido.';
        Text001: Label '¿Confirma que desea registrar el/la %1?';
        LocalText003: Label 'Se va a calcular la retención.';
    BEGIN
        //RET
        CLEAR(LinCompra);
        LinCompra.SETRANGE("Document Type", CabCompra."Document Type");
        LinCompra.SETRANGE("Document No.", CabCompra."No.");
        LinCompra.SETRANGE("Lín. retención", TRUE);
        IF NOT LinCompra.FINDFIRST THEN //08122020. al ser la generacion de la linea automática cambiamos el mensaje      
            //IF NOT CONFIRM(LocalText001 + Text001, FALSE, CabCompra."Document Type") THEN
            IF NOT CONFIRM(LocalText003 + Text001, FALSE, CabCompra."Document Type") THEN ERROR(LocalText002);
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', true, true)]
    local procedure OnAfterConfirmPost_PurchPostYN(PurchaseHeader: Record "Purchase Header")
    var
        recpurchline: record "Purchase Line";
    begin
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) or (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") then begin
            //19122020>>se crea la linea al importar con interface
            recpurchline.RESET;
            recpurchline.SETRANGE("Document Type", PurchaseHeader."Document Type");
            recpurchline.SETRANGE("Document No.", PurchaseHeader."No.");
            recpurchline.SETRANGE("Aplica Retencion", true);
            IF recpurchline.FINDFIRST THEN recpurchline.CrearAutoLinRetencionAlRegistrar(recpurchline);
            //19122020<<
        end;
    end;
    //Codeunit 91 FIN
    //Codeunit 92
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post + Print", 'OnAfterConfirmPost', '', false, false)]
    local procedure CompruebaLineaRet(PurchaseHeader: Record "Purchase Header")
    var
        PurchSetup: record "Purchases & Payables Setup";
    begin
        PurchSetup.GET;
        IF NOT PurchSetup."Post & Print with Job Queue" THEN BEGIN
            //TECNOCOM - TecnoRet
            IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) AND (PurchaseHeader."Clave Percepción" <> '') THEN CompruebaLinRet(PurchaseHeader);
            //FIN TECNOCOM - TecnoRet
        END;
    end;
    //Codeunit 92 FIN
    //Tabla 38
    [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
    local procedure ValidarPercepciones(var Rec: Record "Purchase Header")
    var
        Vend: record vendor;
    begin
        Vend.Reset();
        if Vend.get(Rec."Buy-from Vendor No.") then begin
            Rec."Clave Percepción" := Vend."Clave Percepción";
            Rec."Tipo Percepción" := Vend."Tipo Percepción";
        end;
    end;
    //Tabla 38 FIN
}
