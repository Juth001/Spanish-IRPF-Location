namespace Excelia.IRPF;
page 86303 "EXC Retention Tax Registers"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "EXC Retention Tax registers";
    Caption = 'Retention Tax registers';

    layout
    {
        area(Content)
        {
            repeater(Registers)
            {
                field("Nº mov."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Nº Proveedor / Nº Cliente"; Rec."Nº Proveedor / Nº Cliente")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Importe retención"; Rec."Importe retención")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Importe retención (DL)"; Rec."Importe retención (DL)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Base retencion (DL)"; Rec."Base retencion (DL)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Descripción"; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cif/Nif"; Rec."CIF/NIF")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fecha registro"; Rec."Fecha registro")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tipo Documento"; Rec."Tipo Documento")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fecha emisión documento"; Rec."Fecha emisión documento")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Nº documento"; Rec."Nº documento")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Importe factura"; Rec."Importe factura")
                {
                    ApplicationArea = All;
                }
                field("Importe factura iva incl."; Rec."Importe factura iva incl.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Base retención"; Rec."Base retención")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("% retención"; Rec."% retención")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tipo de Perceptor"; Rec."Tipo de Perceptor")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Clave de Percepción"; Rec."Clave de Percepción")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cta. retención"; Rec."Cta. retención")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("C.P"; Rec."C.P")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Fecha exportación"; Rec."Fecha exportación")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field(Exportado; Rec.Exportado)
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Nº asiento"; Rec."Nº asiento")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field(Revertido; Rec.Revertido)
                {
                    ApplicationArea = All;
                }
                field("Revertido por el movimiento nº"; Rec."Revertido por el movimiento nº")
                {
                    ApplicationArea = All;
                }
                field("Nº movimiento revertido"; Rec."Nº movimiento revertido")
                {
                    ApplicationArea = All;
                }
                field("Nº archivo"; Rec."Nº archivo")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Cód. origen"; Rec."Cód. origen")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Cód. divisa"; Rec."Cód. divisa")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Importe Factura (DL)"; Rec."Importe Factura (DL)")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Nombre 1"; Rec."Nombre 1")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Nombre 2/Apellidos"; Rec."Nombre 2/Apellidos")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Código provincia"; Rec."Código provincia")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Año devengo"; Rec."Año devengo")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Clave IRPF"; Rec."Clave IRPF")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Subclave IRPF"; Rec."Subclave IRPF")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Tipo percepción"; Rec."Tipo percepción")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cli/Prov"; Rec."Cust/Vend")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tipo Retención"; Rec."Tipo Retención")
                {
                    ApplicationArea = All;
                }
                field(Pendiente; Rec.Pendiente)
                {
                    ApplicationArea = All;
                }
                field("Importe Pendiente"; Rec."Importe Pendiente")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
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
                Caption = 'Movimiento';

                action("Liquidado por movs.")
                {
                    ApplicationArea = All;
                    Caption = 'Applied Entries';
                    Description = 'View the entries applied to the selected withholding tax register movements.';
                    ToolTip = 'View the entries applied to the selected withholding tax register movements.';
                    RunPageOnRec = true;

                    trigger OnAction()
                    var
                        WitholdingTaxregistersLocal: Record "EXC Retention Tax registers";
                        ListaMovimientos: Page "EXC Retention Tax Registers";
                    begin
                        WitholdingTaxregistersLocal.Reset();
                        //TODO:WitholdingTaxregistersLocal.SETFILTER("Entry No.", "Liquidado por Movimiento");
                        if WitholdingTaxregistersLocal.FindFirst() then begin
                            clear(ListaMovimientos);
                            ListaMovimientos.SETTABLEVIEW(WitholdingTaxregistersLocal);
                            ListaMovimientos.RUNMODAL();
                        end;
                    end;
                }
            }
            group("Liq. Retentions")
            {
                Caption = 'Apply Retentions';

                action("Without invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Without invoice';
                    Promoted = true;
                    Image = "Invoicing-Cancel";
                    PromotedCategory = New;

                    trigger OnAction()
                    var
                        ConfContabilidad: Record 98;
                        reLinCompra: Record 39;
                        reDiarioGen: Record 81;
                        MovReten: Record "EXC Retention Tax registers";
                        //TODO:ReportLiqReten: Report "IND Liquidar Retenciones";
                        pgDiarioCartera: Page "EXC Retention Journal";
                        bolContinuar: Boolean;
                    begin
                        MovReten.Reset();
                        CurrPage.SETSELECTIONFILTER(MovReten);
                        if MovReten.Find('-') then
                            repeat
                                if MovReten.Pendiente = false then ERROR(Text001, MovReten."Entry No.");
                                if MovReten."Importe a Liquidar" = 0 then ERROR(Text002, MovReten."Entry No.");

                                reLinCompra.Reset();
                                reLinCompra.Setcurrentkey("Document Type", "Pay-to Vendor No.", "Currency Code");
                                reLinCompra.Setrange("Document Type", reLinCompra."Document Type"::Invoice);
                                reLinCompra.Setrange("Pay-to Vendor No.", MovReten."Nº Proveedor / Nº Cliente");
                                reLinCompra.SETFILTER("Retention Entry", '<>%1', 0);
                                if reLinCompra.FindFIRST() then
                                    ERROR(Text003, MovReten."Entry No.", reLinCompra."Document No.");

                                reDiarioGen.Reset();
                                reDiarioGen.Setrange("Retention Document No.", MovReten."Nº documento");
                                reDiarioGen.Setrange("Liq. Retention", true);
                                if reDiarioGen.FindFIRST() then
                                    ERROR(Text004, MovReten."Entry No.");

                            until MovReten.Next() = 0;
                        //TODO
                        // clear(ReportLiqReten);
                        // ReportLiqReten.CreateInvoice(false);
                        // ReportLiqReten.MostrarDiario(true);
                        // ReportLiqReten.SETTABLEVIEW(MovReten);
                        // ReportLiqReten.RUNMODAL();
                        // clear(bolContinuar);
                        // ReportLiqReten.Continuar(bolContinuar);
                        if bolContinuar then begin
                            COMMIT();
                            GenJnlLine.Reset();
                            ConfContabilidad.Get();
                            GenJnlTemplate.Get(ConfContabilidad."Retention Journal Template");
                            GenJnlLine.FILTERGROUP := 2;
                            GenJnlLine.Setrange("Journal Template Name", ConfContabilidad."Retention Journal Template");
                            GenJnlLine.Setrange("Journal Batch Name", ConfContabilidad."Retention Batch");
                            GenJnlLine.FILTERGROUP := 0;
                            clear(pgDiarioCartera);
                            pgDiarioCartera.SETTABLEVIEW(GenJnlLine);
                            pgDiarioCartera.SETRECORD(GenJnlLine);
                            pgDiarioCartera.LlamadaDesdeLiqRet(ConfContabilidad."Retention Batch");
                            pgDiarioCartera.RUNMODAL();
                        end;
                        CurrPage.UPDATE();
                    end;
                }
                action("With invoice")
                {
                    ApplicationArea = All;
                    Caption = 'With invoice';
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = New;

                    trigger OnAction()
                    var
                        reCabFacCP: Record 38;
                        reCabFacVT: Record 36;
                        reLinCompra: Record 39;
                        reDiarioGen: Record 81;
                        HistFactVenta: Record 112;
                        HistAbontVenta: Record 114;
                        HistFactCompra: Record 122;
                        HistAbonCompra: Record 124;
                        MovReten: record "EXC Retention Tax registers";
                        //TODO:ReportLiqReten: Report "IND Liquidar Retenciones";
                        frmFacCP: Page 51;
                        frmFacVT: Page 43;
                        NumFactura: Code[20];
                        LocalText001: Label 'No se pueden liquidar mov. retención de un Abono con una Factura.';
                        LocalText002: Label 'No se puede liquidar una factura del tipo %1 con factura';
                    begin
                        MovReten.Reset();
                        CurrPage.SETSELECTIONFILTER(MovReten);
                        if MovReten.Find('-') then
                            repeat
                                if (MovReten."Tipo Retención" = MovReten."Tipo Retención"::Profesionales) OR (MovReten."Tipo Retención" = MovReten."Tipo Retención"::Alquiler) then ERROR(LocalText002, MovReten."Tipo Retención");
                                if MovReten."Cust/Vend" = MovReten."Cust/Vend"::Customer then begin
                                    if NOT HistFactVenta.Get(MovReten."Nº documento") then if HistAbontVenta.Get(MovReten."Nº documento") then ERROR(LocalText001);
                                end
                                else
                                    if NOT HistFactCompra.Get(MovReten."Nº documento") then if HistAbonCompra.Get(MovReten."Nº documento") then ERROR(LocalText001);

                                if MovReten.Pendiente = false then ERROR(Text001, MovReten."Entry No.");
                                if MovReten."Importe a Liquidar" = 0 then ERROR(Text002, MovReten."Entry No.");
                                reLinCompra.Reset();
                                reLinCompra.Setcurrentkey("Document Type", "Pay-to Vendor No.", "Currency Code");
                                reLinCompra.Setrange("Document Type", reLinCompra."Document Type"::Invoice);
                                reLinCompra.Setrange("Pay-to Vendor No.", MovReten."Nº Proveedor / Nº Cliente");
                                reLinCompra.SETFILTER("Retention Entry", '<>%1', 0);
                                if reLinCompra.FindFIRST() then
                                    ERROR(Text003, MovReten."Entry No.", reLinCompra."Document No.");
                                reDiarioGen.Reset();
                                reDiarioGen.Setrange("Retention Document No.", MovReten."Nº documento");
                                reDiarioGen.Setrange("Liq. Retention", true);
                                if reDiarioGen.FindFIRST() then
                                    ERROR(Text004, MovReten."Entry No.");

                            until MovReten.Next() = 0;
                        //TODO
                        // clear(ReportLiqReten);
                        // ReportLiqReten.CreateInvoice(true);
                        // ReportLiqReten.SETTABLEVIEW(MovReten);
                        // ReportLiqReten.RUNMODAL();
                        // ReportLiqReten.DevuelveDocumento(NumFactura);
                        // clear(ReportLiqReten);
                        if NumFactura <> '' then
                            //TODO: if "Cust/Vend" = "Cust/Vend"::Customer then begin
                                clear(frmFacVT);

                        reCabFacVT.Reset();
                        reCabFacVT.Setrange("Document Type", reCabFacVT."Document Type"::Invoice);
                        reCabFacVT.Setrange(reCabFacVT."No.", NumFactura);
                        frmFacVT.SETTABLEVIEW(reCabFacVT);
                        frmFacVT.SETRECORD(reCabFacVT);
                        frmFacVT.RUN();

                        //TODO: else begin
                        clear(frmFacCP);
                        reCabFacCP.Reset();
                        reCabFacCP.Setrange("Document Type", reCabFacCP."Document Type"::Invoice);
                        reCabFacCP.Setrange(reCabFacCP."No.", NumFactura);
                        frmFacCP.SETTABLEVIEW(reCabFacCP);
                        frmFacCP.SETRECORD(reCabFacCP);
                        frmFacCP.RUN();
                        //TODO:  end;
                    end;

                    //TODO: CurrPage.UPDATE();
                    //TODO: end;
                }
                action("Liq. credit memo")
                {
                    ApplicationArea = All;
                    Caption = 'Liq. credit memo';

                    trigger OnAction()
                    begin
                        //TODO: LiquidarAbono(Rec);
                    end;
                }
                action(Navigate)
                {
                    ApplicationArea = All;
                    Caption = 'Navigate';
                    Promoted = true;
                    Image = Navigate;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        navigate: page 344;
                    begin
                        Navigate.SetDoc(Rec."Fecha registro", Rec."Nº documento");
                        Navigate.RUN();
                    end;
                }
            }
        }
    }
    var
        GenJnlLine: Record 81;
        GenJnlTemplate: Record 80;
        "Importe a LiquidarEditable": Boolean;
        Text001: Label 'No se puede liquidar los movimientos seleccionados porque el movimiento número %1 no est  pendiente';
        Text002: Label 'No se puede liquidar los movimientos seleccionados porque el movimiento número %1 no tiene importe a liquidar';
        Text003: Label 'No se puede liquidar el movimiento de retención número %1 porque hay una factura de liquidación pendiente de registrar. \Registrela o borrela antes de continuar';
        Text004: Label 'No se puede liquidar el movimiento de retención número %1 porque hay una línea de diario pendiente de registrar. \Registrela o borrela antes de continuar';

    trigger OnInit()
    begin
        "Importe a LiquidarEditable" := true;
    end;

    //TODO:
    // trigger OnAfterGetRecord()
    // var
    // begin
    //     ImporteaLiquidarOnFormat();
    // end;

    //TODO:
    // procedure ImporteaLiquidarOnFormat()
    // begin
    //     if Pendiente = true then
    //         "Importe a LiquidarEditable" := true
    //     else
    //         "Importe a LiquidarEditable" := false;
    // end;

    procedure GetSelectionFilter(): Code[80]
    var
        WitholdingTaxRegistersLocal: record "EXC Retention Tax registers";
        ItemCount: integer;
        firstitem: integer;
        Lastitem: integer;
        More: boolean;
        SelectionFilter: code[250];
    begin
        CurrPage.SETSELECTIONFILTER(WitholdingTaxRegistersLocal);
        ItemCount := WitholdingTaxRegistersLocal.COUNT;
        if ItemCount > 0 then begin
            WitholdingTaxRegistersLocal.Find('-');
            WHILE ItemCount > 0 DO begin
                ItemCount := ItemCount - 1;
                WitholdingTaxRegistersLocal.MARKEDONLY(false);
                FirstItem := WitholdingTaxRegistersLocal."Entry No.";
                LastItem := FirstItem;
                More := (ItemCount > 0);
                WHILE More DO if WitholdingTaxRegistersLocal.Next = 0 then
                        More := false
                    else if NOT WitholdingTaxRegistersLocal.MARK then
                        More := false
                    else begin
                        LastItem := WitholdingTaxRegistersLocal."Entry No.";
                        ItemCount := ItemCount - 1;
                        if ItemCount = 0 then More := false;
                    end;
                if SelectionFilter <> '' then SelectionFilter := SelectionFilter + '|';
                if FirstItem = LastItem then
                    SelectionFilter := SelectionFilter + FORMAT(FirstItem)
                else
                    SelectionFilter := SelectionFilter + FORMAT(FirstItem) + '..' + FORMAT(LastItem);
                if ItemCount > 0 then begin
                    WitholdingTaxRegistersLocal.MARKEDONLY(true);
                    WitholdingTaxRegistersLocal.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;

    procedure SetSelection(VAR WitholdingTaxregistersPara: Record "EXC Retention Tax registers")
    begin
        CurrPage.SETSELECTIONFILTER(WitholdingTaxregistersPara);
    end;
}
