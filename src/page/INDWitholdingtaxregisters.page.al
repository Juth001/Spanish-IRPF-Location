namespace ScriptumVita.IRPF;
page 86303 "IND Witholding tax registers"
{
    // version INDRA
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "IND Witholding Tax registers";
    //CaptionML = ENU = 'SWitholding Tax registers', ESP = 'Movimientos de retención';
    Caption = 'Movimientos de retención'; //'SWitholding Tax registers';

    layout
    {
        area(Content)
        {
            repeater(Registers)
            {
                field("Nº mov."; "Nº mov.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Nº Proveedor / Nº Cliente"; "Nº Proveedor / Nº Cliente")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Importe retención"; "Importe retención")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Importe retención (DL)"; "Importe retención (DL)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Base retencion (DL)"; "Base retencion (DL)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Descripción"; "Descripción")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cif/Nif"; "Cif/Nif")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fecha registro"; "Fecha registro")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tipo Documento"; "Tipo Documento")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fecha emisión documento"; "Fecha emisión documento")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Nº documento"; "Nº documento")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Importe factura"; "Importe factura")
                {
                    ApplicationArea = All;
                }
                field("Importe factura iva incl."; "Importe factura iva incl.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Base retención"; "Base retención")
                {
                    ApplicationArea = All;
                    Visible = FALSE;
                    Editable = FALSE;
                }
                field("% retención"; "% retención")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Tipo de Perceptor"; "Tipo de Perceptor")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Clave de Percepción"; "Clave de Percepción")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Cta. retención"; "Cta. retención")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("C.P"; "C.P")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Fecha exportación"; "Fecha exportación")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field(Exportado; Exportado)
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Nº asiento"; "Nº asiento")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field(Revertido; Revertido)
                {
                    ApplicationArea = All;
                }
                field("Revertido por el movimiento nº"; "Revertido por el movimiento nº")
                {
                    ApplicationArea = All;
                }
                field("Nº movimiento revertido"; "Nº movimiento revertido")
                {
                    ApplicationArea = All;
                }
                field("Nº archivo"; "Nº archivo")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Cód. origen"; "Cód. origen")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Cód. divisa"; "Cód. divisa")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Importe Factura (DL)"; "Importe Factura (DL)")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Nombre 1"; "Nombre 1")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Nombre 2/Apellidos"; "Nombre 2/Apellidos")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Código provincia"; "Código provincia")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Año devengo"; "Año devengo")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Clave IRPF"; "Clave IRPF")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Subclave IRPF"; "Subclave IRPF")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Tipo percepción"; "Tipo percepción")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cli/Prov"; "Cli/Prov")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tipo Retención"; "Tipo Retención")
                {
                    ApplicationArea = All;
                }
                field(Pendiente; Pendiente)
                {
                    ApplicationArea = All;
                }
                field("Importe Pendiente"; "Importe Pendiente")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {
        }
    }
    actions
    {
        area(Processing)
        {
            group(Movimiento)
            {
                //CaptionML = ENU = 'Entry', ESP = 'Movimiento';
                Caption = 'Movimiento'; //'Entry';

                action("Liquidado por movs.")
                {
                    ApplicationArea = All;
                    Caption = 'Liquidado por movs.'; //'Applied Entries';
                    //CaptionML = ENU = 'Applied Entries', ESP = 'Liquidado por movs.';
                    Description = 'Nº mov=field(liquidado por movimiento)';
                    RunPageOnRec = true;

                    trigger OnAction()
                    var
                        WitholdingTaxregistersLocal: Record "IND Witholding Tax registers";
                        ListaMovimientos: Page "IND Witholding tax registers";
                    begin
                        //WitholdingTaxregisters.RESET;
                        //WitholdingTaxregisters.SETFILTER(WitholdingTaxregisters."N§ mov.",'%1',"Liquidado por Movimiento");
                        //PAGE.RUNMODAL(PAGE::"Witholding tax registers",WitholdingTaxregisters);
                        WitholdingTaxregistersLocal.RESET;
                        WitholdingTaxregistersLocal.SETFILTER("Nº mov.", "Liquidado por Movimiento");
                        IF WitholdingTaxregistersLocal.FINDFIRST THEN BEGIN
                            CLEAR(ListaMovimientos);
                            ListaMovimientos.SETTABLEVIEW(WitholdingTaxregistersLocal);
                            ListaMovimientos.RUNMODAL;
                        end;
                    end;
                }
            }
            group("Liq. Deductions")
            {
                //CaptionML = ENU = 'Liq. deductions', ESP = 'Liq. retenciones';
                Caption = 'Liq. retenciones'; //'Liq. deductions';

                action("Sin factura")
                {
                    ApplicationArea = All;
                    //CaptionML = ENU = 'Without invoice', ESP = 'Sin factura';
                    Caption = 'Sin factura'; //'Without invoice';
                    ShortcutKey = 'Shift+F9';
                    Promoted = true;
                    PromotedCategory = New;

                    trigger OnAction()
                    var
                        MovReten: Record "IND Witholding Tax registers";
                        ReportLiqReten: Report "IND Liquidar Retenciones";
                        ConfContabilidad: Record 98;
                        LinDiaGen: Record 81;
                        bolContinuar: Boolean;
                        reLinCompra: Record 39;
                        reDiarioGen: Record 81;
                        GenJnlManagement: Codeunit 230;
                        Formdiario: Page 39;
                        frmFacVT: Page 43;
                        pgDiarioCartera: Page "IND Witholding Journal";
                    begin
                        MovReten.RESET;
                        CurrPage.SETSELECTIONFILTER(MovReten);
                        IF MovReten.FIND('-') THEN
                            REPEAT
                                IF MovReten.Pendiente = FALSE THEN ERROR(Text001, MovReten."Nº mov.");
                                IF MovReten."Importe a Liquidar" = 0 THEN ERROR(Text002, MovReten."Nº mov.");
                                //Compruebo si hay alguna factura pendiente de registrar que liquide el movto.
                                reLinCompra.RESET;
                                reLinCompra.SETCURRENTKEY("Document Type", "Pay-to Vendor No.", "Currency Code");
                                reLinCompra.SETRANGE("Document Type", reLinCompra."Document Type"::Invoice);
                                reLinCompra.SETRANGE("Pay-to Vendor No.", MovReten."Nº Proveedor / Nº Cliente");
                                reLinCompra.SETFILTER("Mov. retención", '<>%1', 0);
                                IF reLinCompra.FINDFIRST THEN BEGIN
                                    ERROR(Text003, MovReten."Nº mov.", reLinCompra."Document No.");
                                END;
                                //Compruebo si hay alguna linea en el diario pendiente de registrar que liquide el movto
                                reDiarioGen.RESET;
                                reDiarioGen.SETRANGE("Nº doc. retención", MovReten."Nº documento");
                                reDiarioGen.SETRANGE("Liq. retención", TRUE);
                                IF reDiarioGen.FINDFIRST THEN BEGIN
                                    ERROR(Text004, MovReten."Nº mov.");
                                END;
                            UNTIL MovReten.NEXT = 0;
                        CLEAR(ReportLiqReten);
                        ReportLiqReten.GeneraFactura(FALSE);
                        //TECNOCOM - EFS - 211112 - Se crea funcion en el report para que te muestre el diario desde la page o desde el propio report
                        ReportLiqReten.MostrarDiario(TRUE);
                        ReportLiqReten.SETTABLEVIEW(MovReten);
                        ReportLiqReten.RUNMODAL;
                        CLEAR(bolContinuar);
                        ReportLiqReten.Continuar(bolContinuar);
                        IF bolContinuar THEN BEGIN
                            /*
                            CLEAR(Formdiario);
                     COMMIT;
                     GenJnlLine.RESET;
                     ConfContabilidad.GET();
                     GenJnlTemplate.GET(ConfContabilidad."Libro retenciones");
                     GenJnlLine.FILTERGROUP := 2;
                     GenJnlLine.SETRANGE("Journal Template Name", ConfContabilidad."Libro retenciones");
                     GenJnlLine.FILTERGROUP := 0;
                     GenJnlManagement.SetName(ConfContabilidad."Sección retenciones", GenJnlLine);
                     PAGE.RUNMODAL(GenJnlTemplate."Page ID", GenJnlLine);
                            //FormDiario.SETTABLEVIEW(GenJnlLine);
                            //FormDiario.SETRECORD(GenJnlLine);
                            //FormDiario.RUNMODAL;
                        */
                            COMMIT;
                            GenJnlLine.RESET;
                            ConfContabilidad.GET();
                            GenJnlTemplate.GET(ConfContabilidad."Libro retenciones");
                            GenJnlLine.FILTERGROUP := 2;
                            GenJnlLine.SETRANGE("Journal Template Name", ConfContabilidad."Libro retenciones");
                            GenJnlLine.SETRANGE("Journal Batch Name", ConfContabilidad."Sección retenciones");
                            GenJnlLine.FILTERGROUP := 0;
                            //GenJnlManagement.SetName(ConfContabilidad."Sección retenciones", GenJnlLine);
                            //GenJnlLine."Journal Batch Name" := ConfContabilidad."Sección retenciones";
                            CLEAR(pgDiarioCartera);
                            pgDiarioCartera.SETTABLEVIEW(GenJnlLine);
                            pgDiarioCartera.SETRECORD(GenJnlLine);
                            pgDiarioCartera.LlamadaDesdeLiqRet(ConfContabilidad."Sección retenciones");
                            pgDiarioCartera.RUNMODAL;
                        END;
                        CurrPage.UPDATE;
                    end;
                }
                action("Con factura")
                {
                    ApplicationArea = All;
                    //CaptionML = ENU = 'With invoice', ESP = 'Con factura';
                    Caption = 'Con factura'; //'With invoice';
                    Promoted = true;
                    PromotedCategory = New;

                    trigger OnAction()
                    var
                        MovReten: record "IND Witholding Tax registers";
                        ReportLiqReten: Report "IND Liquidar Retenciones";
                        NumFactura: Code[20];
                        reCabFacCP: Record 38;
                        reCabFacVT: Record 36;
                        reLinCompra: Record 39;
                        reDiarioGen: Record 81;
                        HistFactVenta: Record 112;
                        HistAbontVenta: Record 114;
                        HistFactCompra: Record 122;
                        HistAbonCompra: Record 124;
                        LocalText001: Label 'No se pueden liquidar mov. retención de un Abono con una Factura.';
                        LocalText002: Label 'No se puede liquidar una factura del tipo %1 con factura';
                        frmFacCP: Page 51;
                        frmFacVT: Page 43;
                    begin
                        MovReten.RESET;
                        CurrPage.SETSELECTIONFILTER(MovReten);
                        IF MovReten.FIND('-') THEN
                            REPEAT
                                IF (MovReten."Tipo Retención" = MovReten."Tipo Retención"::Profesionales) OR (MovReten."Tipo Retención" = MovReten."Tipo Retención"::Alquiler) THEN ERROR(LocalText002, MovReten."Tipo Retención");
                                IF MovReten."Cli/Prov" = MovReten."Cli/Prov"::Cliente THEN BEGIN
                                    IF NOT HistFactVenta.GET(MovReten."Nº documento") THEN IF HistAbontVenta.GET(MovReten."Nº documento") THEN ERROR(LocalText001);
                                END
                                ELSE BEGIN
                                    IF NOT HistFactCompra.GET(MovReten."Nº documento") THEN IF HistAbonCompra.GET(MovReten."Nº documento") THEN ERROR(LocalText001);
                                END;
                                IF MovReten.Pendiente = FALSE THEN ERROR(Text001, MovReten."Nº mov.");
                                IF MovReten."Importe a Liquidar" = 0 THEN ERROR(Text002, MovReten."Nº mov.");
                                //Compruebo si hay alguna factura pendiente de registrar que liquide el movto.
                                reLinCompra.RESET;
                                reLinCompra.SETCURRENTKEY("Document Type", "Pay-to Vendor No.", "Currency Code");
                                reLinCompra.SETRANGE("Document Type", reLinCompra."Document Type"::Invoice);
                                reLinCompra.SETRANGE("Pay-to Vendor No.", MovReten."Nº Proveedor / Nº Cliente");
                                reLinCompra.SETFILTER("Mov. retención", '<>%1', 0);
                                IF reLinCompra.FINDFIRST THEN BEGIN
                                    ERROR(Text003, MovReten."Nº mov.", reLinCompra."Document No.");
                                END;
                                //Compruebo si hay alguna linea en el diario pendiente de registrar que liquide el movto
                                reDiarioGen.RESET;
                                reDiarioGen.SETRANGE("Nº doc. retención", MovReten."Nº documento");
                                reDiarioGen.SETRANGE("Liq. retención", TRUE);
                                IF reDiarioGen.FINDFIRST THEN BEGIN
                                    ERROR(Text004, MovReten."Nº mov.");
                                END;
                            UNTIL MovReten.NEXT = 0;
                        CLEAR(ReportLiqReten);
                        ReportLiqReten.GeneraFactura(TRUE);
                        ReportLiqReten.SETTABLEVIEW(MovReten);
                        ReportLiqReten.RUNMODAL;
                        ReportLiqReten.DevuelveDocumento(NumFactura);
                        CLEAR(ReportLiqReten);
                        IF NumFactura <> '' THEN BEGIN
                            IF "Cli/Prov" = "Cli/Prov"::Cliente THEN BEGIN
                                CLEAR(frmFacVT);
                                reCabFacVT.RESET;
                                reCabFacVT.SETRANGE("Document Type", reCabFacVT."Document Type"::Invoice);
                                reCabFacVT.SETRANGE(reCabFacVT."No.", NumFactura);
                                frmFacVT.SETTABLEVIEW(reCabFacVT);
                                frmFacVT.SETRECORD(reCabFacVT);
                                frmFacVT.RUN;
                            END
                            ELSE BEGIN
                                CLEAR(frmFacCP);
                                reCabFacCP.RESET;
                                reCabFacCP.SETRANGE("Document Type", reCabFacCP."Document Type"::Invoice);
                                reCabFacCP.SETRANGE(reCabFacCP."No.", NumFactura);
                                frmFacCP.SETTABLEVIEW(reCabFacCP);
                                frmFacCP.SETRECORD(reCabFacCP);
                                frmFacCP.RUN;
                            END;
                        END;
                        CurrPage.UPDATE;
                    end;
                }
                action("Liquidar abono")
                {
                    ApplicationArea = All;
                    //CaptionML = ENU = 'Liq. credit memo', ESP = 'Liquidar abono';
                    Caption = 'Liquidar abono'; //'Liq. credit memo';

                    trigger OnAction()
                    begin
                        LiquidarAbono(Rec);
                    end;
                }
                action(Navegar)
                {
                    ApplicationArea = All;
                    //CaptionML = ENU = 'Navigate', ESP = 'Navegar';
                    Caption = 'Navegar'; //'Navigate';
                    Promoted = true;
                    Image = Navigate;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        navigate: page 344;
                    begin
                        Navigate.SetDoc("Fecha registro", "Nº documento");
                        Navigate.RUN;
                    end;
                }
            }
        }
    }
    var
        "Importe a LiquidarEditable": Boolean;
        Text001: Label 'No se puede liquidar los movimientos seleccionados porque el movimiento número %1 no est  pendiente';
        Text002: Label 'No se puede liquidar los movimientos seleccionados porque el movimiento número %1 no tiene importe a liquidar';
        Text003: Label 'No se puede liquidar el movimiento de retención número %1 porque hay una factura de liquidación pendiente de registrar. \Registrela o borrela antes de continuar';
        Text004: Label 'No se puede liquidar el movimiento de retención número %1 porque hay una línea de diario pendiente de registrar. \Registrela o borrela antes de continuar';
        GenJnlLine: Record 81;
        GenJnlTemplate: Record 80;

    trigger OnInit()
    begin
        "Importe a LiquidarEditable" := TRUE;
    end;

    trigger OnAfterGetRecord()
    var
    begin
        ImporteaLiquidarOnFormat;
    end;

    procedure ImporteaLiquidarOnFormat()
    begin
        IF Pendiente = TRUE THEN
            "Importe a LiquidarEditable" := TRUE
        ELSE
            "Importe a LiquidarEditable" := FALSE;
    end;

    Procedure GetSelectionFilter(): Code[80]
    var
        WitholdingTaxRegistersLocal: record "IND Witholding Tax registers";
        ItemCount: integer;
        firstitem: integer;
        Lastitem: integer;
        More: boolean;
        SelectionFilter: code[250];
    begin
        CurrPage.SETSELECTIONFILTER(WitholdingTaxRegistersLocal);
        ItemCount := WitholdingTaxRegistersLocal.COUNT;
        IF ItemCount > 0 THEN BEGIN
            WitholdingTaxRegistersLocal.FIND('-');
            WHILE ItemCount > 0 DO BEGIN
                ItemCount := ItemCount - 1;
                WitholdingTaxRegistersLocal.MARKEDONLY(FALSE);
                FirstItem := WitholdingTaxRegistersLocal."Nº mov.";
                LastItem := FirstItem;
                More := (ItemCount > 0);
                WHILE More DO IF WitholdingTaxRegistersLocal.NEXT = 0 THEN
                        More := FALSE
                    ELSE IF NOT WitholdingTaxRegistersLocal.MARK THEN
                        More := FALSE
                    ELSE BEGIN
                        LastItem := WitholdingTaxRegistersLocal."Nº mov.";
                        ItemCount := ItemCount - 1;
                        IF ItemCount = 0 THEN More := FALSE;
                    END;
                IF SelectionFilter <> '' THEN SelectionFilter := SelectionFilter + '|';
                IF FirstItem = LastItem THEN
                    SelectionFilter := SelectionFilter + FORMAT(FirstItem)
                ELSE
                    SelectionFilter := SelectionFilter + FORMAT(FirstItem) + '..' + FORMAT(LastItem);
                IF ItemCount > 0 THEN BEGIN
                    WitholdingTaxRegistersLocal.MARKEDONLY(TRUE);
                    WitholdingTaxRegistersLocal.NEXT;
                END;
            END;
        END;
        EXIT(SelectionFilter);
    end;

    Procedure SetSelection(VAR WitholdingTaxregistersPara: Record "IND Witholding Tax registers")
    begin
        CurrPage.SETSELECTIONFILTER(WitholdingTaxregistersPara);
    end;
}
