namespace ScriptumVita.IRPF;
report 86302 "IND Liquidar Retenciones"
{
    // version INDRA
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Liquidar Retenciones';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Mov. retención"; "IND Witholding Tax registers")
        {
            trigger OnPreDataItem()
            begin
                //Dataitem para liquidar retenciones sin FACTURA
                ConfContabilidad.GET;
                ConfContabilidad.TESTFIELD("Libro retenciones");
                ConfContabilidad.TESTFIELD("Sección auxiliar retenciones");
                ConfContabilidad.TESTFIELD("Sección retenciones");
                CLEAR(Seccionr);
                Seccionr.RESET;
                IF Seccionr.GET(ConfContabilidad."Libro retenciones", ConfContabilidad."Sección retenciones") THEN BEGIN
                    Seccionr.TESTFIELD("No. Series");
                    Numdocumentov := Numseriesmgt.GetNextNo(Seccionr."No. Series", WORKDATE, FALSE);
                END;
                LinDiario.RESET;
                LinDiario.SETRANGE("Journal Template Name", ConfContabilidad."Libro retenciones");
                LinDiario.SETRANGE("Journal Batch Name", ConfContabilidad."Sección retenciones");
                IF LinDiario.FIND('-') THEN LinDiario.DELETEALL;
                LinDiario.RESET;
                LinDiario.SETRANGE("Journal Template Name", ConfContabilidad."Libro retenciones");
                LinDiario.SETRANGE("Journal Batch Name", ConfContabilidad."Sección auxiliar retenciones");
                IF LinDiario.FIND('-') THEN LinDiario.DELETEALL;
                CLEAR(bolCabecera);
                CLEAR(numLinea);
                SETRANGE(Pendiente, TRUE);
            end;

            trigger OnAfterGetRecord()
            begin
                IF VEfecto THEN BEGIN
                    IF "Mov. retención"."Cli/Prov" = "Mov. retención"."Cli/Prov"::Cliente THEN BEGIN
                        IF NOT HistFactVenta.GET("Mov. retención"."Nº documento") THEN IF HistAbonVenta.GET("Mov. retención"."Nº documento") THEN ERROR(TextIbdos002);
                    END
                    ELSE BEGIN
                        IF NOT HistFactCompra.GET("Mov. retención"."Nº documento") THEN IF HistAbonCompra.GET("Mov. retención"."Nº documento") THEN ERROR(TextIbdos002);
                    END;
                END;
                IF "Mov. retención"."Nº documento" <> UltDoc THEN BEGIN
                    UltDoc := "Mov. retención"."Nº documento";
                    CLEAR(UltEfectoMismoDoc);
                END;
                IF bolFactura THEN
                    retencionFactura("Mov. retención")
                ELSE
                    retencionSinFactura("Mov. retención");
            end;

            trigger OnPostDataItem()
            begin
                bolContinuar := TRUE;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Opciones")
                {
                    field(optTipo; Tipo)
                    {
                        ApplicationArea = All;
                        //Enabled = bolFacturapage;
                        //CaptionML = ESP = 'Liquidar por';
                        Caption = 'Liquidar por';

                        trigger OnValidate()
                        begin
                            IF Tipo = Tipo::"Cliente/Proveedor" THEN
                                BoolCuenta := FALSE
                            ELSE
                                BoolCuenta := TRUE;
                            IF NOT bolFacturapage THEN BoolCuenta := FALSE;
                        end;
                    }
                    field(txtCuenta; Cuenta)
                    {
                        ApplicationArea = All;
                        //CaptionML = ESP = 'Cuenta';
                        Caption = 'Cuenta';

                        //Enabled = BoolCuenta;
                        ;
                        trigger OnLookup(var txt1: text): Boolean
                        var
                            reBanco: Record 270;
                            frmListaBanco: Page 371;
                            reCuenta: Record 15;
                            frmListaCuentas: Page 18;
                        begin
                            IF Tipo = Tipo::Banco THEN BEGIN
                                reBanco.RESET;
                                CLEAR(frmListaBanco);
                                frmListaBanco.SETTABLEVIEW(reBanco);
                                frmListaBanco.LOOKUPMODE := TRUE;
                                frmListaBanco.SETRECORD(reBanco);
                                IF frmListaBanco.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    frmListaBanco.GETRECORD(reBanco);
                                    Cuenta := reBanco."No.";
                                END
                            END
                            ELSE BEGIN
                                reCuenta.RESET;
                                CLEAR(frmListaCuentas);
                                frmListaCuentas.SETTABLEVIEW(reCuenta);
                                frmListaCuentas.LOOKUPMODE := TRUE;
                                frmListaCuentas.SETRECORD(reCuenta);
                                IF frmListaCuentas.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    frmListaCuentas.GETRECORD(reCuenta);
                                    Cuenta := reCuenta."No.";
                                END
                            END
                        end;
                    }
                    field(chkEfecto; VEfecto)
                    {
                        ApplicationArea = All;
                        //Enabled = bolFacturapage;
                        //CaptionML = ESP = 'Tipo efecto';
                        Caption = 'Tipo efecto';
                    }
                    field(bolFactura; bolFactura)
                    {
                        ApplicationArea = All;
                        //Enabled = bolFacturapage;
                        //CaptionML = ESP = 'Tipo efecto';
                        Caption = 'Factura';
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        CLEAR(bolContinuar);
        CLEAR(UltEfectoMismoDoc);
        CLEAR(UltDoc);
        bolFacturapage := NOT bolFactura;
    end;

    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        Realizaragrupacionporpais;
        IF NOT NoMuestraDiario THEN
            IF NOT bolFactura THEN BEGIN
                ConfContabilidad.GET;
                COMMIT;
                GenJnlLine.RESET;
                GenJnlTemplate.GET(ConfContabilidad."Libro retenciones");
                GenJnlLine.FILTERGROUP := 2;
                GenJnlLine.SETRANGE("Journal Template Name", ConfContabilidad."Libro retenciones");
                GenJnlLine.FILTERGROUP := 0;
                GenJnlManagement.SetName(ConfContabilidad."Sección retenciones", GenJnlLine);
                CLEAR(frmDiarioGen);
                PAGE.RUNMODAL(GenJnlTemplate."Page ID", GenJnlLine);
            END;
    end;

    var
        VEfecto: Boolean;
        LinDiario: Record 81;
        NLin: Integer;
        FormCartera: Page 7000036;
        CarteraSetupw: Record 7000016;
        bolFactura: Boolean;
        bolCabecera: Boolean;
        numLinea: Integer;
        NumDocumento: Code[20];
        TextIbdos001: Label 'debe tener configurada una forma de pago que genere efectos.';
        Tipo: option "Cliente/Proveedor","Banco","Cuenta";
        Cuenta: Code[20];
        bolContinuar: Boolean;
        UltEfectoMismoDoc: Code[20];
        UltDoc: Code[20];
        TipoFactura: Boolean;
        TextIbdos002: Label 'No se pueden liquidar mov. retención de un Abono con un efecto.';
        HistFactVenta: Record 112;
        HistAbonVenta: Record 114;
        HistFactCompra: Record 122;
        HistAbonCompra: Record 124;
        ConfContabilidad: Record 98;
        Seccionr: Record 232;
        Numdocumentov: Code[20];
        Numseriesmgt: Codeunit 396;
        Noseriesr: Record 309;
        Numdocumentooldv: Code[20];
        bolFacturapage: Boolean;
        BoolCuenta: Boolean;
        NoMuestraDiario: Boolean;
        GenJnlLine: Record 81;
        GenJnlTemplate: Record 80;
        GenJnlManagement: Codeunit 230;
        frmDiarioGen: Page 7000036;

    PROCEDURE UltLinea();
    BEGIN
        NLin := 0;
        LinDiario.LOCKTABLE;
        LinDiario.RESET;
        LinDiario.SETRANGE("Journal Template Name", ConfContabilidad."Libro retenciones");
        LinDiario.SETRANGE("Journal Batch Name", ConfContabilidad."Sección auxiliar retenciones");
        IF LinDiario.FIND('+') THEN NLin := LinDiario."Line No.";
    END;

    PROCEDURE FormaPago(): Code[10];
    VAR
        FPago: Record 289;
    BEGIN
        FPago.RESET;
        FPago.SETRANGE("Create Bills", TRUE);
        IF FPago.FIND('-') THEN
            EXIT(FPago.Code)
        ELSE
            ERROR(TextIbdos001);
    END;

    PROCEDURE GeneraFactura(pBolFactura: Boolean);
    BEGIN
        bolFactura := pBolFactura;
        //GFM - Comentado: le doy valor en OnInitReport
        //bolFacturapage := NOT pBolFactura;
    END;

    PROCEDURE CreaFacturaVT(pReRetencion: Record "IND Witholding Tax registers");
    VAR
        reFacVTCb: Record 36;
        reFacVTLin: Record 37;
    BEGIN
        //Cabecera
        IF NOT bolCabecera THEN BEGIN
            reFacVTCb.RESET;
            reFacVTCb.INIT;
            reFacVTCb."Document Type" := reFacVTCb."Document Type"::Invoice;
            reFacVTCb."No." := '';
            reFacVTCb.INSERT(TRUE);
            reFacVTCb.VALIDATE("Sell-to Customer No.", pReRetencion."Nº Proveedor / Nº Cliente");
            reFacVTCb."Tipo Percepción" := pReRetencion."Tipo de Perceptor";
            reFacVTCb."Clave Percepción" := pReRetencion."Clave de Percepción";
            reFacVTCb.VALIDATE("Shortcut Dimension 2 Code", "Mov. retención"."Nº Proyecto");
            reFacVTCb.MODIFY;
            bolCabecera := TRUE;
            NumDocumento := reFacVTCb."No.";
        END;
        //Lineas
        reFacVTLin.RESET;
        reFacVTLin.INIT;
        reFacVTLin."Document Type" := reFacVTLin."Document Type"::Invoice;
        reFacVTLin."Document No." := NumDocumento;
        numLinea += 10000;
        reFacVTLin."Line No." := numLinea;
        reFacVTLin.INSERT(TRUE);
        reFacVTLin.Type := reFacVTLin.Type::"G/L Account";
        reFacVTLin.VALIDATE("No.", pReRetencion."Cta. retención");
        reFacVTLin.VALIDATE(Quantity, 1);
        reFacVTLin.VALIDATE("Unit Price", pReRetencion."Importe a Liquidar");
        reFacVTLin."Tipo Percepción" := pReRetencion."Tipo de Perceptor";
        reFacVTLin."Clave Percepción" := pReRetencion."Clave de Percepción";
        reFacVTLin."Lín. retención" := TRUE;
        reFacVTLin."Mov. retención" := pReRetencion."Nº mov.";
        reFacVTLin.MODIFY;
    END;

    PROCEDURE CreaFacturaCP(pReRetencion: Record "IND Witholding Tax registers");
    VAR
        reFacCPCb: Record 38;
        reFacCPLin: Record 39;
    BEGIN
        //Cabecera
        IF NOT bolCabecera THEN BEGIN
            reFacCPCb.RESET;
            reFacCPCb.INIT;
            reFacCPCb."Document Type" := reFacCPCb."Document Type"::Invoice;
            reFacCPCb."No." := '';
            reFacCPCb.INSERT(TRUE);
            reFacCPCb.VALIDATE("Buy-from Vendor No.", pReRetencion."Nº Proveedor / Nº Cliente");
            reFacCPCb.VALIDATE("Currency Code", pReRetencion."Cód. divisa");
            reFacCPCb."Tipo Percepción" := pReRetencion."Tipo de Perceptor";
            reFacCPCb."Clave Percepción" := pReRetencion."Clave de Percepción";
            reFacCPCb."Vendor Invoice No." := pReRetencion."Nº documento";
            reFacCPCb.VALIDATE("Shortcut Dimension 2 Code", "Mov. retención"."Nº Proyecto");
            reFacCPCb.MODIFY;
            bolCabecera := TRUE;
            NumDocumento := reFacCPCb."No.";
        END;
        //Lineas
        reFacCPLin.RESET;
        reFacCPLin.INIT;
        reFacCPLin."Document Type" := reFacCPLin."Document Type"::Invoice;
        reFacCPLin."Document No." := NumDocumento;
        numLinea += 10000;
        reFacCPLin."Line No." := numLinea;
        reFacCPLin.INSERT(TRUE);
        reFacCPLin.Type := reFacCPLin.Type::"G/L Account";
        reFacCPLin.VALIDATE("No.", pReRetencion."Cta. retención");
        reFacCPLin.VALIDATE(Quantity, 1);
        reFacCPLin.VALIDATE("Direct Unit Cost", -pReRetencion."Importe a Liquidar");
        reFacCPLin."Tipo Percepción" := pReRetencion."Tipo de Perceptor";
        reFacCPLin."Clave Percepción" := pReRetencion."Clave de Percepción";
        reFacCPLin."Lín. retención" := TRUE;
        reFacCPLin.VALIDATE("Mov. retención", pReRetencion."Nº mov.");
        reFacCPLin.VALIDATE("Shortcut Dimension 2 Code", "Mov. retención"."Nº Proyecto");
        reFacCPLin.MODIFY;
    END;

    PROCEDURE retencionFactura(pReRetencion: Record "IND Witholding Tax registers");
    BEGIN
        IF pReRetencion."Cli/Prov" = pReRetencion."Cli/Prov"::Cliente THEN
            CreaFacturaVT(pReRetencion)
        ELSE
            CreaFacturaCP(pReRetencion);
    END;

    PROCEDURE retencionSinFactura(pReRetencion: Record "IND Witholding Tax registers");
    BEGIN
        UltLinea;
        IF pReRetencion."Cli/Prov" = pReRetencion."Cli/Prov"::Proveedor THEN
            TipoFactura := DevuelveTipoDoc(pReRetencion."Nº documento", TRUE)
        ELSE
            TipoFactura := DevuelveTipoDoc(pReRetencion."Nº documento", FALSE);
        // 1º línea.
        NLin := NLin + 10000;
        LinDiario.INIT;
        LinDiario."Journal Template Name" := ConfContabilidad."Libro retenciones";
        LinDiario."Journal Batch Name" := ConfContabilidad."Sección auxiliar retenciones";
        LinDiario."Line No." := NLin;
        //LinDiario.INSERT(TRUE);
        LinDiario."Posting Date" := WORKDATE;
        CASE Tipo OF
            Tipo::"Cliente/Proveedor":
                BEGIN
                    IF pReRetencion."Cli/Prov" = pReRetencion."Cli/Prov"::Cliente THEN LinDiario."Account Type" := LinDiario."Account Type"::Customer;
                    IF pReRetencion."Cli/Prov" = pReRetencion."Cli/Prov"::Proveedor THEN LinDiario."Account Type" := LinDiario."Account Type"::Vendor;
                    LinDiario.VALIDATE("Account No.", pReRetencion."Nº Proveedor / Nº Cliente");
                    LinDiario.VALIDATE("Shortcut Dimension 2 Code", "Mov. retención"."Nº Proyecto");
                END;
            Tipo::Banco:
                BEGIN
                    LinDiario."Account Type" := LinDiario."Account Type"::"Bank Account";
                    LinDiario.VALIDATE("Account No.", Cuenta);
                END;
            Tipo::Cuenta:
                BEGIN
                    LinDiario."Account Type" := LinDiario."Account Type"::"G/L Account";
                    LinDiario.VALIDATE("Account No.", Cuenta);
                END
        END;
        //LinDiario.VALIDATE("Currency Code", "Mov. retención"."Cód. divisa");
        IF VEfecto THEN LinDiario."Document Type" := LinDiario."Document Type"::Bill;
        LinDiario."Document No." := pReRetencion."Nº documento";
        IF VEfecto THEN BEGIN
            IF UltEfectoMismoDoc <> '' THEN BEGIN
                UltEfectoMismoDoc := INCSTR(UltEfectoMismoDoc);
                LinDiario."Bill No." := UltEfectoMismoDoc;
            END
            ELSE
                LinDiario."Bill No." := BuscaUltimoEfecto(pReRetencion."Nº documento", pReRetencion."Cli/Prov", pReRetencion."Nº Proveedor / Nº Cliente");
            LinDiario.VALIDATE("Payment Method Code", FormaPago);
        END;
        IF pReRetencion."Cli/Prov" = pReRetencion."Cli/Prov"::Proveedor THEN BEGIN
            IF TipoFactura THEN
                LinDiario.VALIDATE("Credit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"))
            ELSE
                LinDiario.VALIDATE("Debit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"));
        END
        ELSE BEGIN
            IF TipoFactura THEN
                LinDiario.VALIDATE("Debit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"))
            ELSE
                LinDiario.VALIDATE("Credit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"))
        END;
        LinDiario.VALIDATE(LinDiario."VAT Posting", 0);
        LinDiario.VALIDATE("Gen. Bus. Posting Group", '');
        LinDiario.VALIDATE("Gen. Prod. Posting Group", '');
        LinDiario."Tipo percepción" := pReRetencion."Tipo de Perceptor";
        LinDiario."Clave percepción" := pReRetencion."Clave de Percepción";
        LinDiario."Country/Region Code" := pReRetencion.País;
        //traspaso las 4 dimensiones
        LinDiario.VALIDATE("Shortcut Dimension 1 Code", pReRetencion."Shortcut Dimension 1 Code");
        LinDiario.VALIDATE("Shortcut Dimension 2 Code", pReRetencion."Shortcut Dimension 2 Code");
        //traspaso las 4 dimensiones
        //-001
        //LinDiario."Exported to Payment File" := TRUE;
        LinDiario."Exported to Payment File" := FALSE; //Al generar el diario, obliga a que sea False
        //+001
        LinDiario.INSERT;
        // 2º línea.
        NLin := NLin + 10000;
        LinDiario.INIT;
        LinDiario."Journal Template Name" := ConfContabilidad."Libro retenciones";
        LinDiario."Journal Batch Name" := ConfContabilidad."Sección auxiliar retenciones";
        LinDiario."Line No." := NLin;
        //LinDiario.INSERT(TRUE);
        LinDiario."Account Type" := LinDiario."Account Type"::"G/L Account";
        LinDiario.VALIDATE("Account No.", pReRetencion."Cta. retención");
        LinDiario."Posting Date" := WORKDATE;
        LinDiario."Document No." := pReRetencion."Nº documento";
        //LinDiario.VALIDATE("Currency Code", "Mov. retención"."Cód. divisa");
        IF pReRetencion."Cli/Prov" = pReRetencion."Cli/Prov"::Proveedor THEN BEGIN
            IF TipoFactura THEN
                LinDiario.VALIDATE("Debit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"))
            ELSE
                LinDiario.VALIDATE("Credit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"));
        END
        ELSE BEGIN
            IF TipoFactura THEN
                LinDiario.VALIDATE("Credit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"))
            ELSE
                LinDiario.VALIDATE("Debit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"))
        END;
        LinDiario.VALIDATE("VAT Posting", 0);
        LinDiario.VALIDATE("Gen. Posting Type", 0);
        LinDiario.VALIDATE("Gen. Bus. Posting Group", '');
        LinDiario.VALIDATE("Gen. Prod. Posting Group", '');
        LinDiario."Nº doc. retención" := pReRetencion."Nº documento";
        LinDiario."Liq. retención" := TRUE;
        LinDiario."Tipo percepción" := pReRetencion."Tipo de Perceptor";
        LinDiario."Clave percepción" := pReRetencion."Clave de Percepción";
        LinDiario.VALIDATE("Mov. retención", pReRetencion."Nº mov.");
        //TecnoRet1
        LinDiario.Factura := LinDiario.Factura::"Sin factura";
        LinDiario.Efecto := VEfecto;
        LinDiario."Tipo Liquidacion" := Tipo;
        //FIN TecnoRet1
        LinDiario."Country/Region Code" := pReRetencion.País;
        //TecnoRet3
        LinDiario."Nº mov. retención" := pReRetencion."Nº mov.";
        //FIN TecnoRet3
        //traspaso las 4 dimensiones
        LinDiario.VALIDATE("Shortcut Dimension 1 Code", pReRetencion."Shortcut Dimension 1 Code");
        LinDiario.VALIDATE("Shortcut Dimension 2 Code", pReRetencion."Shortcut Dimension 2 Code");
        //traspaso las 4 dimensiones
        //-001
        //LinDiario."Exported to Payment File" := TRUE;
        LinDiario."Exported to Payment File" := FALSE; //Al generar el diario, obliga a que sea False
        //+001
        LinDiario.INSERT;
    END;

    PROCEDURE DevuelveDocumento(VAR pChDocumento: Code[20]);
    BEGIN
        pChDocumento := NumDocumento;
    END;

    PROCEDURE Continuar(VAR pBolContinuar: Boolean);
    BEGIN
        pBolContinuar := bolContinuar;
    END;

    PROCEDURE BuscaUltimoEfecto(NumDoc: Code[20]; TipoMov: option "Cliente","Proveedor"; CLiProv: Code[20]) NumEfecto: Code[20];
    VAR
        MovCliente: Record 21;
        MovProveedor: Record 25;
    BEGIN
        NumEfecto := '1';
        IF TipoMov = TipoMov::Cliente THEN BEGIN
            MovCliente.RESET;
            MovCliente.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
            MovCliente.SETRANGE("Document No.", NumDoc);
            MovCliente.SETRANGE("Document Type", MovProveedor."Document Type"::Bill);
            MovCliente.SETRANGE("Customer No.", CLiProv);
            IF MovCliente.FIND('+') THEN NumEfecto := INCSTR(MovCliente."Bill No.");
        END
        ELSE BEGIN
            MovProveedor.RESET;
            MovProveedor.SETCURRENTKEY("Vendor No.", "Document No.");
            MovProveedor.SETRANGE("Vendor No.", CLiProv);
            MovProveedor.SETRANGE("Document No.", NumDoc);
            MovProveedor.SETRANGE("Document Type", MovProveedor."Document Type"::Bill);
            IF MovProveedor.FIND('+') THEN NumEfecto := INCSTR(MovProveedor."Bill No.");
        END;
        UltEfectoMismoDoc := NumEfecto;
    END;

    PROCEDURE DevuelveTipoDoc(NumDoc: Code[20]; Compra: Boolean) Factura: Boolean;
    VAR
        HistFactCompra: Record 122;
        HistAbonCompra: Record 124;
        HistFactVenta: Record 112;
        HistAbonVenta: Record 114;
    BEGIN
        IF Compra THEN BEGIN
            IF HistFactCompra.GET(NumDoc) THEN
                Factura := TRUE
            ELSE IF HistAbonCompra.GET(NumDoc) THEN Factura := FALSE;
        END
        ELSE BEGIN
            IF HistFactVenta.GET(NumDoc) THEN
                Factura := TRUE
            ELSE IF HistAbonVenta.GET(NumDoc) THEN Factura := FALSE;
        END;
    END;

    PROCEDURE Realizaragrupacionporpais();
    VAR
        Companyinfol: Record 79;
        Lindiariol: Record 81;
        Imporespañal: Decimal;
        Imporespañaliql: Decimal;
        Imporotrosl: Decimal;
        Imporotrosliql: Decimal;
        Lindiarioinsertl: Record 81;
        Liqretencionl: Record "IND Aux. liq mov. retención";
        Numlineal: Integer;
        Text001l: Label 'Liquidación retención %1';
        Text002l: Label 'Liquidación retención países extranjeros.';
    BEGIN
        CLEAR(Liqretencionl);
        Liqretencionl.RESET;
        Liqretencionl.SETRANGE("Id.usuario", USERID);
        Liqretencionl.DELETEALL;
        Imporespañal := 0;
        Imporespañaliql := 0;
        Imporotrosl := 0;
        Imporotrosliql := 0;
        Numlineal := 10000;
        Companyinfol.GET;
        Lindiariol.RESET;
        Lindiariol.SETRANGE("Journal Template Name", ConfContabilidad."Libro retenciones");
        Lindiariol.SETRANGE("Journal Batch Name", ConfContabilidad."Sección auxiliar retenciones");
        Lindiariol.SETRANGE("Country/Region Code", Companyinfol."Country/Region Code");
        Lindiariol.SETFILTER("Mov. retención", '<>%1', 0);
        IF Lindiariol.FIND('-') THEN BEGIN
            REPEAT
                Imporespañal += Lindiariol.Amount;
                Liqretencionl."Journal Template Name" := ConfContabilidad."Libro retenciones";
                Liqretencionl."Journal Batch Name" := ConfContabilidad."Sección retenciones";
                Liqretencionl."Line No." := Numlineal;
                Liqretencionl."Mov.retención" := Lindiariol."Mov. retención";
                Liqretencionl."Importe a liquidar" := Lindiariol.Amount;
                Liqretencionl."Nº documento" := Lindiariol."Document No.";
                Liqretencionl."Id.usuario" := USERID;
                IF Liqretencionl.INSERT THEN;
            UNTIL Lindiariol.NEXT = 0;
            Lindiarioinsertl.INIT;
            Lindiarioinsertl.COPY(Lindiariol);
            Lindiarioinsertl."Journal Batch Name" := ConfContabilidad."Sección retenciones";
            Lindiarioinsertl."Line No." := Numlineal;
            Lindiarioinsertl.INSERT(TRUE);
            Numlineal += 10000;
            Lindiarioinsertl.VALIDATE(Amount, Imporespañal);
            Lindiarioinsertl."Document No." := Numdocumentov;
            Lindiarioinsertl.Description := STRSUBSTNO(Text001l, Lindiarioinsertl."Country/Region Code");
            //-001
            Lindiarioinsertl."Exported to Payment File" := false;
            Lindiarioinsertl.MODIFY(FALSE);
            //Lindiarioinsertl.MODIFY(TRUE);
            //+001
        END;
        Lindiariol.SETRANGE("Mov. retención");
        Lindiariol.SETRANGE("Mov. retención", 0);
        IF Lindiariol.FIND('-') THEN BEGIN
            REPEAT
                Imporespañaliql += Lindiariol.Amount;
            UNTIL Lindiariol.NEXT = 0;
            Lindiarioinsertl.INIT;
            Lindiarioinsertl.COPY(Lindiariol);
            Lindiarioinsertl."Journal Batch Name" := ConfContabilidad."Sección retenciones";
            Lindiarioinsertl."Line No." := Numlineal;
            Lindiarioinsertl.INSERT(TRUE);
            Numlineal += 10000;
            Lindiarioinsertl.VALIDATE(Amount, Imporespañaliql);
            Lindiarioinsertl."Document No." := Numdocumentov;
            Lindiarioinsertl.Description := STRSUBSTNO(Text001l, Lindiarioinsertl."Country/Region Code");
            //4 DIM
            Lindiarioinsertl.VALIDATE("Shortcut Dimension 1 Code", Lindiariol."Shortcut Dimension 1 Code");
            Lindiarioinsertl.VALIDATE("Shortcut Dimension 2 Code", Lindiariol."Shortcut Dimension 2 Code");
            //4 DIM
            //-001
            Lindiarioinsertl."Exported to Payment File" := false;
            Lindiarioinsertl.MODIFY(FALSE);
            //Lindiarioinsertl.MODIFY(TRUE);
            //+001
        END;
        Lindiariol.SETRANGE("Country/Region Code");
        Lindiariol.SETFILTER("Country/Region Code", '<>%1', Companyinfol."Country/Region Code");
        Lindiariol.SETRANGE("Mov. retención");
        Lindiariol.SETFILTER("Mov. retención", '<>%1', 0);
        IF Lindiariol.FIND('-') THEN BEGIN
            REPEAT
                Liqretencionl."Journal Template Name" := ConfContabilidad."Libro retenciones";
                Liqretencionl."Journal Batch Name" := ConfContabilidad."Sección retenciones";
                Liqretencionl."Line No." := Numlineal;
                Liqretencionl."Mov.retención" := Lindiariol."Mov. retención";
                Liqretencionl."Importe a liquidar" := Lindiariol.Amount;
                Liqretencionl."Nº documento" := Lindiariol."Document No.";
                Liqretencionl."Id.usuario" := USERID;
                IF Liqretencionl.INSERT THEN;
                Imporotrosl += Lindiariol.Amount;
            UNTIL Lindiariol.NEXT = 0;
            Lindiarioinsertl.INIT;
            Lindiarioinsertl.COPY(Lindiariol);
            Lindiarioinsertl."Journal Batch Name" := ConfContabilidad."Sección retenciones";
            Lindiarioinsertl."Line No." := Numlineal;
            Lindiarioinsertl.INSERT(TRUE);
            Numlineal += 10000;
            Lindiarioinsertl.VALIDATE(Amount, Imporotrosl);
            Lindiarioinsertl."Document No." := Numdocumentov;
            Lindiarioinsertl.Description := STRSUBSTNO(Text002l);
            //4 DIM
            Lindiarioinsertl.VALIDATE("Shortcut Dimension 1 Code", Lindiariol."Shortcut Dimension 1 Code");
            Lindiarioinsertl.VALIDATE("Shortcut Dimension 2 Code", Lindiariol."Shortcut Dimension 2 Code");
            //4 DIM
            //-001
            Lindiarioinsertl."Exported to Payment File" := false;
            Lindiarioinsertl.MODIFY(FALSE);
            //Lindiarioinsertl.MODIFY(TRUE);
            //+001
        END;
        Lindiariol.SETRANGE("Mov. retención");
        Lindiariol.SETRANGE("Mov. retención", 0);
        IF Lindiariol.FIND('-') THEN BEGIN
            REPEAT
                Imporotrosliql += Lindiariol.Amount;
            UNTIL Lindiariol.NEXT = 0;
            Lindiarioinsertl.INIT;
            Lindiarioinsertl.COPY(Lindiariol);
            Lindiarioinsertl."Journal Batch Name" := ConfContabilidad."Sección retenciones";
            Lindiarioinsertl."Line No." := Numlineal;
            Lindiarioinsertl.INSERT(TRUE);
            Numlineal += 10000;
            Lindiarioinsertl.VALIDATE(Amount, Imporotrosliql);
            Lindiarioinsertl."Document No." := Numdocumentov;
            Lindiarioinsertl.Description := STRSUBSTNO(Text002l);
            //4 DIM
            Lindiarioinsertl.VALIDATE("Shortcut Dimension 1 Code", Lindiariol."Shortcut Dimension 1 Code");
            Lindiarioinsertl.VALIDATE("Shortcut Dimension 2 Code", Lindiariol."Shortcut Dimension 2 Code");
            //4 DIM
            //-001
            Lindiarioinsertl."Exported to Payment File" := false;
            Lindiarioinsertl.MODIFY(FALSE);
            //Lindiarioinsertl.MODIFY(TRUE);
            //+001
        END;
        Lindiariol.RESET;
        Lindiariol.SETRANGE("Journal Template Name", ConfContabilidad."Libro retenciones");
        Lindiariol.SETRANGE("Journal Batch Name", ConfContabilidad."Sección auxiliar retenciones");
        IF Lindiariol.FINDFIRST THEN Lindiariol.DELETEALL(TRUE);
    END;

    PROCEDURE MostrarDiario(boolMuestra: Boolean);
    BEGIN
        NoMuestraDiario := boolMuestra;
    END;
}
