namespace ScriptumVita.IRPF;
codeunit 86304 "IND Eventos ventas"
{
    // version INDRA
    trigger OnRun()
    begin
    end;
    /*
    //Codeunit 80 INICIO
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure CreaRetencion(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; RetRcpHdrNo: Code[20]; CommitIsSuppressed: Boolean)
    var
        xSalesLine: record "Sales Line";
        SalesLine: record "Sales Line";
        LineasVentaRet: record "Sales Line";
        SalesInvHeader: record "Sales Invoice Header";
    begin
        //NO ESTÁ BIEN, HAY QUE VER BIEN EL BOOLEAN
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        if SalesLine.FindFirst() then
            repeat
                IF SalesLine."Lín. retención" THEN
                    CreaRetenciones(SalesLine, SalesInvHdrNo);
            until SalesLine.Next() = 0;

        IF SalesHeader.Invoice THEN BEGIN
            LineasVentaRet.RESET;
            LineasVentaRet.SETRANGE("Document Type", SalesHeader."Document Type");
            LineasVentaRet.SETRANGE("Document No.", SalesHeader."No.");
            LineasVentaRet.SETFILTER("Mov. retención", '<>%1', 0);
            IF LineasVentaRet.FIND('-') THEN
                LiquidaRetencion(SalesHeader, SalesInvHeader."No.");
        END;
        //FIN TECNOCOM - TecnoRet - 005
        //FIN TECNOCOM - TecnoRet - 004
    end;
    */
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLines', '', true, true)]
    local procedure CrearRetencionesLineas(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; WhseShip: Boolean; WhseReceive: Boolean; var SalesLinesProcessed: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean)
    var
        xSalesLine: record "Sales Line";
        SalesLine: record "Sales Line";
        LineasVentaRet: record "Sales Line";
        SalesInvHeader: record "Sales Invoice Header";
    begin
        //NO ESTÁ BIEN, HAY QUE VER BIEN EL BOOLEAN
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        if SalesLine.FindFirst() then
            repeat
                IF SalesLine."Lín. retención" THEN CreaRetenciones(SalesLine, SalesInvoiceHeader."No.");
            until SalesLine.Next() = 0;
        IF SalesHeader.Invoice THEN BEGIN
            LineasVentaRet.RESET;
            LineasVentaRet.SETRANGE("Document Type", SalesHeader."Document Type");
            LineasVentaRet.SETRANGE("Document No.", SalesHeader."No.");
            LineasVentaRet.SETFILTER("Mov. retención", '<>%1', 0);
            IF LineasVentaRet.FIND('-') THEN LiquidaRetencion(SalesHeader, SalesInvHeader."No.");
        END;
        //FIN TECNOCOM - TecnoRet - 005
        //FIN TECNOCOM - TecnoRet - 004
    end;

    local procedure CreaRetencion(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; RetRcpHdrNo: Code[20]; CommitIsSuppressed: Boolean)
    var
        xSalesLine: record "Sales Line";
        SalesLine: record "Sales Line";
        LineasVentaRet: record "Sales Line";
        SalesInvHeader: record "Sales Invoice Header";
    begin
        //NO ESTÁ BIEN, HAY QUE VER BIEN EL BOOLEAN
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        if SalesLine.FindFirst() then
            repeat
                IF SalesLine."Lín. retención" THEN CreaRetenciones(SalesLine, SalesInvHdrNo);
            until SalesLine.Next() = 0;
        IF SalesHeader.Invoice THEN BEGIN
            LineasVentaRet.RESET;
            LineasVentaRet.SETRANGE("Document Type", SalesHeader."Document Type");
            LineasVentaRet.SETRANGE("Document No.", SalesHeader."No.");
            LineasVentaRet.SETFILTER("Mov. retención", '<>%1', 0);
            IF LineasVentaRet.FIND('-') THEN LiquidaRetencion(SalesHeader, SalesInvHeader."No.");
        END;
        //FIN TECNOCOM - TecnoRet - 005
        //FIN TECNOCOM - TecnoRet - 004
    end;

    procedure CreaRetenciones(xSalesLine: record "Sales Line"; SalesInvHdrNo: code[20])
    var
        Cuenta: record "G/L Account";
        GlobSalesHeader: record "Sales Header";
        GenJnlLineDocType: integer;
        GenJnlLine: record "Gen. Journal Line";
        //NoSerie: codeunit NoSeriesManagement;
        GenJnlLineDocNo: code[20];
        SourceCodeSetup: record "Source Code Setup";
        SrcCode: code[10];
        SalesInvHeader: record "Sales Invoice Header";
        ImpTotal: decimal;
        ImpTotalSinIVA: decimal;
    begin
        Cuenta.GET(xSalesLine."No.");
        IF (xSalesLine."Mov. retención" = 0) THEN BEGIN
            //extra LTM
            SourceCodeSetup.GET;
            SrcCode := SourceCodeSetup.Sales;
            GlobSalesHeader.GET(xSalesLine."Document Type", xsalesline."Document No.");
            //++ OT2-051963
            if GlobSalesHeader."Document Type" = GlobSalesHeader."Document Type"::Invoice then //GenJnlLineDocType := GlobSalesHeader."Document Type"::Invoice
                GenJnlLineDocType := GlobSalesHeader."Document Type"::Invoice.AsInteger()
            else
                //GenJnlLineDocType := GlobSalesHeader."Document Type"::"Credit Memo";
                GenJnlLineDocType := GlobSalesHeader."Document Type"::"Credit Memo".AsInteger();
            //-- OT2-051963
            //GenJnlLineDocNo := GlobSalesHeader."No.";
            GenJnlLineDocNo := SalesInvHdrNo;
            //extra LTM
            GlobSalesHeader.CALCFIELDS(Amount, "Amount Including VAT");
            IF (Cuenta."Tipo Cuenta Retención" = Cuenta."Tipo Cuenta Retención"::Proveedor) AND (xSalesLine."Mov. retención" = 0) THEN BEGIN
                CrearRetencionIRPFVentas(GenJnlLineDocType, GenJnlLineDocNo, xSalesLine.Amount, SrcCode, xSalesLine."Tipo Percepción", xSalesLine."Clave Percepción", xSalesLine."Qty. to Invoice", xSalesLine."Job No.", GlobSalesHeader."Posting Description", GlobSalesHeader."Document Date", GlobSalesHeader."Posting Date", GlobSalesHeader.Amount, GlobSalesHeader."Sell-to Post Code", GlobSalesHeader."Currency Code", -(xSalesLine."Unit Price" * 100), GlobSalesHeader."Sell-to Customer No.", GlobSalesHeader."VAT Registration No.", GlobSalesHeader."Amount Including VAT");
            END;
            IF (Cuenta."Tipo Cuenta Retención" = Cuenta."Tipo Cuenta Retención"::Cliente) AND (xSalesLine."Mov. retención" = 0) THEN BEGIN
                IF xSalesLine."Document Type" = xSalesLine."Document Type"::Order THEN BEGIN
                    //Extra LTM
                    IF SalesInvHeader.GET(SalesInvHdrNo) then begin
                        //Extra LTM
                        SalesInvHeader.CALCFIELDS("Amount Including VAT", Amount);
                        ImpTotal := SalesInvHeader."Amount Including VAT";
                        ImpTotalSinIva := SalesInvHeader.Amount;
                    end;
                end;
            END
            ELSE BEGIN
                ImpTotal := GlobSalesHeader."Amount Including VAT";
                ImpTotalSinIva := GlobSalesHeader.Amount;
            END;
            CrearRetencionIRPFVt(GenJnlLineDocType, GenJnlLineDocNo, xSalesLine.Amount, SrcCode, xSalesLine."Tipo Percepción", xSalesLine."Clave Percepción", xSalesLine."Qty. to Invoice", xSalesLine."Job No.", GlobSalesHeader."Posting Description", GlobSalesHeader."Document Date", GlobSalesHeader."Posting Date", ImpTotal, GlobSalesHeader."Sell-to Post Code", GlobSalesHeader."Currency Code", -(xSalesLine."Unit Price" * 100), GlobSalesHeader."Sell-to Customer No.", GlobSalesHeader."VAT Registration No.", ImpTotalSinIva);
        END;
        IF (xSalesLine."Mov. retención" <> 0) THEN LiqRetencion(GenJnlLineDocNo, xSalesLine."Mov. retención", xSalesLine.Amount);
    END;

    procedure LiquidaRetencion(pReCbVenta: Record "Sales Header"; NumDoc: Code[20])
    var
        LinVenta: record "Sales Line";
        MovRetencion2: record "IND Witholding Tax registers";
        MovRetencion3: record "IND Witholding Tax registers";
        MovRetencion4: record "IND Witholding Tax registers";
        VNumMovReten: integer;
        CurrExchRate: record "Currency Exchange Rate";
    begin
        LinVenta.RESET;
        LinVenta.SETRANGE("Document Type", pReCbVenta."Document Type");
        LinVenta.SETRANGE("Document No.", pReCbVenta."No.");
        LinVenta.SETFILTER("Mov. retención", '<>%1', 0);
        IF LinVenta.FIND('-') THEN
            REPEAT
                MovRetencion2.LOCKTABLE;
                MovRetencion2.RESET;
                IF MovRetencion2.FIND('+') THEN BEGIN
                    VNumMovReten := MovRetencion2."Nº mov." + 1;
                END;
                MovRetencion3.RESET;
                IF MovRetencion3.GET(LinVenta."Mov. retención") THEN BEGIN
                    IF MovRetencion3."Importe Pendiente" < 0 THEN
                        MovRetencion3."Importe Pendiente" := MovRetencion3."Importe Pendiente" + ABS(LinVenta."Line Amount")
                    ELSE
                        MovRetencion3."Importe Pendiente" := MovRetencion3."Importe Pendiente" - ABS(LinVenta."Line Amount");
                    IF MovRetencion3."Importe Pendiente" = 0 THEN BEGIN
                        MovRetencion3.Pendiente := FALSE;
                        MovRetencion3."Importe Pendiente (DL)" := 0;
                    END
                    ELSE BEGIN
                        MovRetencion3."Importe Pendiente (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRetencion3."Cód. divisa", MovRetencion3."Importe Pendiente", CurrExchRate.ExchangeRate(WORKDATE, MovRetencion3."Cód. divisa"));
                    END;
                    MovRetencion3."Importe a Liquidar" := MovRetencion3."Importe Pendiente";
                    MovRetencion3."Importe a Liquidar (DL)" := MovRetencion3."Importe Pendiente (DL)";
                    //TECNOCOM TecnoRet - EFS - 070912
                    MovRetencion3."Shortcut Dimension 1 Code" := LinVenta."Shortcut Dimension 1 Code";
                    MovRetencion3."Shortcut Dimension 2 Code" := LinVenta."Shortcut Dimension 2 Code";
                    //FIN TECNOCOM TecnoRet - EFS - 070912
                    MovRetencion3.MODIFY;
                    MovRetencion4.RESET;
                    MovRetencion4 := MovRetencion3;
                    MovRetencion4."Nº mov." := VNumMovReten;
                    MovRetencion4.Descripción := 'Liq. Retención ' + MovRetencion3."Nº documento";
                    MovRetencion4."Nº documento" := NumDoc;
                    MovRetencion4."Fecha registro" := WORKDATE;
                    MovRetencion4."Importe factura iva incl." := 0;
                    MovRetencion4."Importe Factura (DL)" := 0;
                    MovRetencion4."Base retención" := 0;
                    MovRetencion4."Base retencion (DL)" := 0;
                    MovRetencion4."% retención" := 0;
                    MovRetencion4."Cód. divisa" := MovRetencion3."Cód. divisa";
                    MovRetencion4."Importe retención" := -ABS(LinVenta."Line Amount");
                    MovRetencion4."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, MovRetencion4."Cód. divisa", MovRetencion4."Importe retención", CurrExchRate.ExchangeRate(WORKDATE, MovRetencion4."Cód. divisa"));
                    MovRetencion4."Importe Pendiente" := 0;
                    MovRetencion4."Liquidado por Movimiento" := FORMAT(LinVenta."Mov. retención");
                    MovRetencion4."Importe a Liquidar" := 0;
                    MovRetencion4."Importe a Liquidar (DL)" := 0;
                    MovRetencion4.Pendiente := FALSE;
                    //TECNOCOM TecnoRet - EFS - 070912
                    MovRetencion4."Shortcut Dimension 1 Code" := LinVenta."Shortcut Dimension 1 Code";
                    MovRetencion4."Shortcut Dimension 2 Code" := LinVenta."Shortcut Dimension 2 Code";
                    //FIN TECNOCOM TecnoRet - EFS - 070912
                    MovRetencion4.INSERT;
                END;
            UNTIL LinVenta.NEXT = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure CrearLineaRetencionPedido(var SalesHeader: Record "Sales Header")
    begin
        //TECNOCOM - TecnoRet - 001 - 007
        IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order"]) AND (SalesHeader."Clave Percepción" <> '') AND SalesHeader.Invoice THEN SalesHeader.CreaLinRetencionPedido(SalesHeader);
        //FIN TECNOCOM - TecnoRet - 001 - 007
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePosting', '', false, false)]
    local procedure OnAfterFinalizePosting(var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var ReturnReceiptHeader: Record "Return Receipt Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        SalesLine: record "Sales Line";
    begin
        //TECNOCOM - TecnoRet - 006 - 007 - si se est  facturando el pedido se borra la l¡n. de retenc del pedido
        IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order"]) AND (SalesHeader."Clave Percepción" <> '') AND SalesHeader.Invoice THEN BEGIN
            CLEAR(SalesLine);
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            SalesLine.SETRANGE("Lín. retención", TRUE);
            SalesLine.DELETEALL;
        END;
        //FIN TECNOCOM - TecnoRet - 006 - 007
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesShptLineInsert', '', false, false)]
    local procedure BorrarLineaInsertadaAlb(var SalesShipmentLine: Record "Sales Shipment Line"; SalesLine: Record "Sales Line")
    begin
        IF SalesLine."Lín. retención" = true then //si ha insertado lineas con retención debe borrarlas ya que sólo debe insertar las que están libres
            SalesShipmentLine.Delete(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterReturnRcptLineInsert', '', false, false)]
    local procedure BorrarLineaInsertadaDev(var ReturnRcptLine: Record "Return Receipt Line"; SalesLine: Record "Sales Line")
    begin
        IF SalesLine."Lín. retención" = true then //si ha insertado lineas con retención debe borrarlas ya que sólo debe insertar las que están libres
            ReturnRcptLine.Delete(true);
    end;
    //Pendiente revisar
    /* [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostItemTrackingForShipment', '', false, false)]
    local procedure ErrorSiTieneRetencion(var TrackingSpecificationExists: Boolean; var TempTrackingSpecification: Record "Tracking Specification"; var SalesShipmentLine: Record "Sales Shipment Line"; var SalesInvoiceHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; QtyToBeInvoicedBase: Decimal; QtyToBeInvoiced: Decimal)
    var
        Text025: TextConst ENU = 'Line %1 of the return receipt %2, which you are attempting to invoice, has already been invoiced.', ESP = 'Lín. %1 de la devolución %2, que está intentando facturar, ya se ha facturado.';
    begin
        IF SalesLine."Lín. retención" = FALSE THEN //TECNOCOM - TecnoRet - 002
            ERROR(
              Text025,
              SalesLine."Return Receipt Line No.", SalesLine."Return Receipt No.");
    end; */
    procedure CrearRetencionIRPFVentas(Tipo: option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,Bill; Num: Code[20]; Imp: Decimal; SourcCode: Code[10]; Tipopercep: Code[10]; Clavepercep: Code[10]; BaseRet: Decimal; Proy: Code[20]; Desc: Text[50]; DocDate: Date; PostDate: Date; ImpFactura: Decimal; CP: Code[20]; CurrencyCode: Code[10]; PorcRet: Decimal; ProvCLi: Code[20]; CifNif: Text[20]; ImpFacturaSinIva: Decimal)
    var
        InfoEmp1: Record "Company Information";
        ConfConta: Record "General Ledger Setup";
        FacVenta1: Record "Sales Invoice Header";
        LinFacVenta1: Record "Sales Invoice Line";
        AboVenta1: Record "Sales Cr.Memo Header";
        LinAboVenta1: Record "Sales Cr.Memo Line";
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
                    IF FacVenta1.GET(Num) THEN BEGIN
                        FacVenta1.CALCFIELDS("Amount Including VAT", Amount);
                        LinFacVenta1.RESET;
                        LinFacVenta1.SETRANGE("Document No.", FacVenta1."No.");
                        LinFacVenta1.SETRANGE("Lín. retención", TRUE);
                        IF LinFacVenta1.FIND('-') THEN BEGIN
                            NoMovRet1 := TraerNoMovRetencion;
                            Proyecto := LinFacVenta1."Job No.";
                            CrearmovretenciónIRPF(NoMovRet1, FacVenta1."Bill-to Customer No.", FacVenta1."Bill-to Name", FacVenta1."VAT Registration No.", FacVenta1."Document Date", FacVenta1."Posting Date", FacVenta1."No.", ImpFacturaSinIva, -BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, FacVenta1."Bill-to Post Code", SourcCode, FacVenta1."Currency Code", Tipo::Invoice);
                            //TECNOCOM - EFS - 070912
                            NMovRentencion := UltMovRetención;
                            PasarDimensionesRet(LinFacVenta1."Document No.", LinFacVenta1."Line No.", NMovRentencion, TRUE, FALSE);
                            //FIN TECNOCOM - EFS - 070912
                        END;
                    END;
                END;
            //Abono
            Tipo::"Credit Memo":
                BEGIN
                    //Traemos el documento.
                    IF AboVenta1.GET(Num) THEN BEGIN
                        AboVenta1.CALCFIELDS("Amount Including VAT", Amount);
                        LinAboVenta1.RESET;
                        LinAboVenta1.SETRANGE("Document No.", AboVenta1."No.");
                        LinAboVenta1.SETRANGE("Lín. retención", TRUE);
                        IF LinAboVenta1.FIND('-') THEN BEGIN
                            NoMovRet1 := TraerNoMovRetencion;
                            Proyecto := LinAboVenta1."Job No.";
                            CrearmovretenciónIRPF(NoMovRet1, AboVenta1."Bill-to Customer No.", AboVenta1."Bill-to Name", AboVenta1."VAT Registration No.", AboVenta1."Document Date", AboVenta1."Posting Date", //AboCompra1."No.",AboCompra1."Amount Including VAT",BaseRet,PorcRet,Tipopercep,Clavepercep,
                            AboVenta1."No.", -ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, //-Imp,AboCompra1.Amount,AboCompra1."Pay-to Post Code",SourcCode,AboCompra1."Currency Code",
                            -Imp, -ImpFactura, AboVenta1."Bill-to Post Code", SourcCode, AboVenta1."Currency Code", Tipo::"Credit Memo");
                            //TECNOCOM - EFS - 070912
                            NMovRentencion := UltMovRetención;
                            PasarDimensionesRet(LinAboVenta1."Document No.", LinAboVenta1."Line No.", NMovRentencion, FALSE, FALSE);
                            //FIN TECNOCOM - EFS - 070912
                        END;
                    END;
                END;
        END;
    end;

    procedure CrearRetencionIRPFVt(Tipo: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,"Bill"; Num: Code[20]; Imp: Decimal; SourcCode: Code[10]; Tipopercep: Code[10]; Clavepercep: Code[10]; BaseRet: Decimal; Proy: Code[20]; Desc: Text[50]; DocDate: Date; PostDate: Date; ImpFactura: Decimal; CP: Code[20]; CurrencyCode: Code[10]; PorcRet: Decimal; ProvCLi: Code[20]; CifNif: Text[20]; ImpFacturaSinIva: Decimal)
    var
        FacVenta1: record "Sales Invoice Header";
        LinFacVenta1: record "Sales Invoice Line";
        ConfConta: Record "General Ledger Setup";
        NoMovRet1: Integer;
        AboVenta1: Record "Sales Cr.Memo Header";
        LinAboVenta1: Record "Sales Cr.Memo Line";
        ClavesPrecep: Record "IND Perception Keys (IRPF)";
        Proyecto: code[20];
        NMovRentencion: integer;
        RetGener: Boolean;
    begin
        //CrearRetencion
        //Evaluamos si la línea proviene de una factura o directamente de un diario.
        CASE Tipo OF
            Tipo::Invoice:
                BEGIN //Factura de venta
                      //Traemos el documento.
                    IF FacVenta1.GET(Num) THEN BEGIN
                        FacVenta1.CALCFIELDS("Amount Including VAT", Amount);
                        LinFacVenta1.RESET;
                        LinFacVenta1.SETRANGE("Document No.", FacVenta1."No.");
                        LinFacVenta1.SETRANGE("Lín. retención", TRUE);
                        IF LinFacVenta1.FIND('-') THEN
                            REPEAT
                                NoMovRet1 := TraerNoMovRetencion;
                                Proyecto := LinFacVenta1."Job No.";
                                ClavesPrecep.GET(Clavepercep);
                                CrearmovretenciónIRPF(NoMovRet1, FacVenta1."Bill-to Customer No.", FacVenta1."Bill-to Name", FacVenta1."VAT Registration No.", FacVenta1."Document Date", FacVenta1."Posting Date", FacVenta1."No.", ImpFactura, LinFacVenta1.Quantity, PorcRet, Tipopercep, Clavepercep, -Imp, ImpFacturaSinIva, FacVenta1."Bill-to Post Code", SourcCode, FacVenta1."Currency Code", Tipo::Invoice);
                                //TECNOCOM - EFS - 070912
                                NMovRentencion := UltMovRetención;
                                PasarDimensionesRet(LinFacVenta1."Document No.", LinFacVenta1."Line No.", NMovRentencion, TRUE, TRUE);
                                //FIN TECNOCOM - EFS - 070912
                                RetGener := TRUE;
                            UNTIL (LinFacVenta1.NEXT = 0) OR (RetGener);
                    END;
                END;
        END;
        CASE Tipo OF
            Tipo::"Credit Memo":
                BEGIN //Abono de venta
                      //Traemos el documento.
                    IF AboVenta1.GET(Num) THEN BEGIN
                        AboVenta1.CALCFIELDS("Amount Including VAT", Amount);
                        LinAboVenta1.RESET;
                        LinAboVenta1.SETRANGE("Document No.", AboVenta1."No.");
                        LinAboVenta1.SETRANGE("Lín. retención", TRUE);
                        IF LinAboVenta1.FIND('-') THEN
                            REPEAT
                                NoMovRet1 := TraerNoMovRetencion;
                                Proyecto := LinAboVenta1."Job No.";
                                CrearmovretenciónIRPF(NoMovRet1, AboVenta1."Bill-to Customer No.", AboVenta1."Bill-to Name", AboVenta1."VAT Registration No.", AboVenta1."Document Date", AboVenta1."Posting Date", AboVenta1."No.", ImpFactura, LinAboVenta1.Quantity, PorcRet, Tipopercep, Clavepercep, Imp, ImpFacturaSinIva, AboVenta1."Bill-to Post Code", SourcCode, AboVenta1."Currency Code", Tipo::"Credit Memo");
                                //TECNOCOM - EFS - 070912
                                NMovRentencion := UltMovRetención;
                                PasarDimensionesRet(LinAboVenta1."Document No.", LinAboVenta1."Line No.", NMovRentencion, FALSE, TRUE);
                                //FIN TECNOCOM - EFS - 070912
                                RetGener := TRUE;
                            UNTIL (LinAboVenta1.NEXT = 0) OR (RetGener);
                    END;
                END;
        END;
    end;

    procedure LiqRetencion(VAR Ndocuemnto: Code[20]; NumMov: Integer; Importep: Decimal)
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
        GlobalRETGenJnlLine: record "Gen. Journal Line";
        CurrExchRate: record "Currency Exchange Rate";
        GlobalRETGLEntry: record "G/L Entry";
        LastDocNo: code[20];
    begin
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
        //-- OT2-051963
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
    //Codeunit 80 FIN
    //Tabla 36
    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure ValidarPercepciones(var Rec: Record "Sales Header")
    var
        Cust: record Customer;
    begin
        Cust.Reset();
        if Cust.get(Rec."Sell-to Customer No.") then begin
            Rec."Clave Percepción" := Cust."Clave Percepción";
            Rec."Tipo Percepción" := Cust."Tipo Percepción";
        end;
    end;
    //Tabla 36 FIN
}
