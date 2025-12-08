namespace ScriptumVita.IRPF;
table 86303 "IND Witholding Tax registers"
{
    // version INDRA
    DataClassification = CustomerContent;
    //CaptionML = ENU = 'Witholding Tax registers', ESP = 'Mov. Retención';
    Caption = 'Movimientos de retención'; //'Witholding Tax registers';
    LookupPageId = "IND Witholding tax registers";
    DrillDownPageId = "IND Witholding tax registers";

    fields
    {
        field(1; "Nº mov."; Integer)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Entry No.', ESP = 'Nº mov.';
            Caption = 'Nº mov.'; //'Entry No.';
        }
        field(2; "Nº Proveedor / Nº Cliente"; Code[20])
        {
            DataClassification = CustomerContent;
            //aptionML = ENU = 'Vendor No. / Customer no.', ESP = 'Nº Proveedor';
            Caption = 'Nº proveedor / Nº cliente'; //'Vendor No. / Customer no.';
            TableRelation = IF ("Cli/Prov" = CONST(Cliente)) Customer."No."
            ELSE IF ("Cli/Prov" = CONST(Proveedor)) Vendor."No.";
        }
        field(3; Descripción; text[50])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Description', ESP = 'Descripción';
            Caption = 'Descripción'; //'Description';
        }
        field(4; "Cif/Nif"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CIF/NIF'; //'VAT Registration No.';
                                 //CaptionML = ENU = 'VAT Registration No.', ESP = 'Cif/Nif';
        }
        field(5; "Fecha emisión documento"; Date)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Document emission date', ESP = 'Fecha emisión documento';
            Caption = 'Fecha emisión documento'; //'Document emission date';
        }
        field(6; "Fecha registro"; Date)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = ' Posting Date', ESP = 'Fecha registro';
            Caption = 'Fecha registro'; //' Posting Date';
        }
        field(7; "Nº documento"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nº documento'; //'Document No.';
                                      //CaptionML = ENU = 'Document No.', ESP = 'Nº documento';
        }
        field(9; "Importe factura iva incl."; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Invoice Amount Including VAT', ESP = 'Importe factura iva incl.';
            Caption = 'Importe factura IVA incl.'; //'Invoice Amount Including VAT';
        }
        field(10; "Base retención"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Deduction BASE', ESP = 'Base retención';
            Caption = 'Base retención'; //'Deduction BASE';
        }
        field(11; "% retención"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Deduction %', ESP = '% retención';
            Caption = '% retención'; //'Deduction %';
        }
        field(12; "Tipo de Perceptor"; Code[10])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Receiving Type', ESP = 'Tipo de Percepción';
            Caption = 'Tipo de perceptor'; //'Receiving Type';
            TableRelation = "IND Perception Type (IRPF)"."Código";
        }
        field(13; "Clave de Percepción"; Code[10])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Perceptions Key', ESP = 'Clave de Percepción';
            Caption = 'Clave de percepción'; //'Perceptions Key';
            TableRelation = "IND Perception Keys (IRPF)"."Código";
        }
        field(14; "Importe retención"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Deduction Amount', ESP = 'Importe retención';
            Caption = 'Importe retención'; //'Deduction Amount';
        }
        field(15; "Cta. retención"; Text[20])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Deduction Acc.', ESP = 'Cta. retención';
            Caption = 'Cta. retención'; //'Deduction Acc.';
        }
        field(16; "Importe retención (DL)"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionMl = ENU = 'Deduction Amount (LCY)', ESP = 'Importe retención (DL)';
            Caption = 'Importe retención (DL)'; //'Deduction Amount (LCY)';
        }
        field(17; "C.P"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'C.P.'; //'Postal Code';
            //CaptionML = 'Postal Code', ESP = 'C.P';
            TableRelation = "Post Code";
            ValidateTableRelation = FALSE;
        }
        field(18; "Fecha exportación"; Date)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Date export', ESP = 'Fecha exportación';
            Caption = 'Fecha exportación'; //'Date export';
        }
        field(19; Exportado; Boolean)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Exported', ESP = 'Exportado';
            Caption = 'Exportado'; //'Exported';
        }
        field(20; "Nº asiento"; Integer)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Entry No.', ESP = 'Nº asiento';
            Caption = 'Nº asiento'; //'Entry No.';
        }
        field(21; "Nº archivo"; Code[20])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'File No.', ESP = 'Nº archivo';
            Caption = 'Nº archivo'; //'File No.';
        }
        field(22; "Cód. origen"; Code[10])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Origin Cod', ESP = 'Cód. origen';
            Caption = 'Cód. origen'; //'Origin Cod';
            TableRelation = "Source Code";
        }
        field(23; "Base retencion (DL)"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Deduction Base (LCY)', ESP = 'Base retencion (DL)';
            Caption = 'Base retención (DL)'; //'Deduction Base (LCY)';
        }
        field(24; "Cód. divisa"; Code[10])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Currency Code', ESP = 'Cód. divisa';
            Caption = 'Cód. divisa'; //'Currency Code';
            TableRelation = Currency;
        }
        field(25; "Importe Factura (DL)"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Invoice amount', ESP = 'Importe Factura (DL)';
            Caption = 'Importe factura (DL)'; //'Invoice amount';
        }
        field(26; "Nombre 1"; Text[50])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Name 1', ESP = 'Nombre 1';
            Caption = 'Nombre 1'; //'Name 1';
        }
        field(27; "Nombre 2/Apellidos"; Text[50])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Name 2/surname', ESP = 'Nombre 2/Apellidos';
            Caption = 'Nombre 2/apellidos'; //'Name 2/surname';
        }
        field(28; "Código provincia"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Código provincia'; //'County Code';
            //CaptionML = ENU = 'County Code', ESP = 'Código provincia';
            TableRelation = "Area";
        }
        field(29; "Año devengo"; Integer)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Acrued Year', ESP = 'Año devengo';
            Caption = 'Año devengo'; //'Acrued Year';
        }
        field(30; "Clave IRPF"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Clave IRPF'; //'IRPF Key';
            //CaptionML = ENU = 'IRPF Key', ESP = 'Clave IRPF';
            OptionMembers = " ","A","B","C","D","E","F","G","H","I","J","K","L",,,,,,"19";
            //OptionCaptionML = ENU = ',A,B,C,D,E,F,G,H,I,J,K,L,,,,,,19', ESP = ',A,B,C,D,E,F,G,H,I,J,K,L,,,,,,19';
            OptionCaption = ',A,B,C,D,E,F,G,H,I,J,K,L,,,,,,19';
            Editable = true;
        }
        field(31; "Subclave IRPF"; Option)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'IRPF Subkey', ESP = 'Subclave IRPF';
            Caption = 'Subclave IRPF'; // 'IRPF Subkey';
            OptionMembers = " ","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16";
            //OptionCaptionML = ENU = ',01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16', ESP = ' ,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16';
            OptionCaption = ',01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16';
            Editable = true;
        }
        field(32; "Tipo percepción"; Option)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Perception Type', ESP = 'Tipo percepción';
            Caption = 'Tipo percepción'; //'Perception Type';
            OptionMembers = "Dineraria","Especie","Ingreso a cuenta repercutido";
            //OptionCaptionML = ENU = 'Cash,Species,Joined account impacted', ESP = 'Dineraria,Especie,Ingreso a cuenta repercutido';
            OptionCaption = 'Dineraria,Especie,Ingreso a cuenta repercutido'; //'Cash,Species,Joined account impacted';
            Editable = false;
        }
        field(33; "Nº Proyecto"; Code[20])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Job No', ESP = 'Nº Proyecto';
            Caption = 'Nº proyecto'; //'Job No';
            TableRelation = Job;

            trigger OnValidate()
            var
                reProyecto: Record Job;
            begin
                reProyecto.RESET;
                IF reProyecto.GET("Nº Proyecto") THEN
                    "Descripción Proyecto" := reProyecto.Description
                ELSE
                    "Descripción Proyecto" := '';
            end;
        }
        field(34; "Descripción Proyecto"; Text[50])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Job Description', ESP = 'Descripción Proyecto';
            Caption = 'Descripción Proyecto'; //'Job Description';
        }
        field(35; Pendiente; Boolean)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Outstanding', ESP = 'Pendiente';
            Caption = 'Pendiente'; //'Outstanding';
            Editable = false;
        }
        field(36; "Importe Pendiente"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Outstanding Amount', ESP = 'Importe Pendiente';
            Caption = 'Importe pendiente'; //'Outstanding Amount';
        }
        field(37; "Liquidado por Movimiento"; Text[250])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Liquidated By entry', ESP = 'Liquidado por Movimiento';
            Caption = 'Liquidado por movimiento'; //'Liquidated By entry';
        }
        field(38; "Cli/Prov"; Option)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Cust/Vend', ESP = 'Cli/Prov';
            Caption = 'Cli/Prov'; //'Cust/Vend';
            OptionMembers = "Cliente","Proveedor";
            //OptionCaptionML = ENU = 'Customer,Vendor', ESP = 'Cliente,Proveedor';
            OptionCaption = 'Cliente,Proveedor'; //'Customer,Vendor';
        }
        field(39; "Tipo Retención"; Option)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Deduction Type', ESP = 'Tipo Retención';
            Caption = 'Tipo retención'; //'Deduction Type';
            OptionMembers = "Alquiler","Garantía","Profesionales","Otros";
            //OptionCaptionML = ENU = 'Rent,Guaranty,Professionals,Others', ESP = 'Alquiler,Garantía,Profesionales,Otros';
            OptionCaption = 'Alquiler","Garantía","Profesionales","Otros'; //'Rent,Guaranty,Professionals,Others';
        }
        field(40; "Importe a Liquidar"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Amount to liquidate', ESP = 'Importe a Liquidar';
            Caption = 'Importe a liquidar'; //'Amount to liquidate';

            trigger OnValidate()
            begin
                If "Importe a Liquidar" < 0 then
                    "Importe a Liquidar" := -1 * ABS("Importe a Liquidar")
                ELSE
                    "Importe a Liquidar" := ABS("Importe a Liquidar");
                IF Abs("Importe a Liquidar") > Abs("Importe Pendiente") then Error(Text001);
                "Importe a Liquidar (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Cód. divisa", "Importe a Liquidar", CurrExchRate.ExchangeRate(WORKDATE, "Cód. divisa"));
            end;
        }
        field(41; "Importe factura"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Invoice Amount', ESP = 'Importe factura';
            Caption = 'Importe factura'; //'Invoice Amount';
            Editable = false;
        }
        field(42; Revertido; Boolean)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Reversed', ESP = 'Revertido';
            Caption = 'Revertido'; //'Reversed';
            Editable = false;
        }
        field(43; "Revertido por el movimiento nº"; Integer)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Reversed by Entry No', ESP = 'Revertido por el movimiento nº';
            Caption = 'Revertido por el movimiento nº'; //'Reversed by Entry No';
            BlankZero = true;
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(44; "Nº movimiento revertido"; Integer)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Reversed by Entry No', ESP = 'Revertido por el movimiento nº';
            Caption = 'Nº mov. revertido'; //'Reversed by Entry No';
            BlankZero = true;
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(45; "Tipo Documento"; Option)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            Caption = 'Tipo documento'; //'Document Type';
            OptionMembers = " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund";
            //OptionCaptionML = ENU = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund', ESP = ',Pago,Factura,Abono,Docs. interés,Recordatorio,Reembolso';
            OptionCaption = ',Pago,Factura,Abono,Docs. interés,Recordatorio,Reembolso'; //' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
        }
        field(46; "Desde Nº Mov. contabilidad"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Desde Nº Mov. contabilidad';
        }
        field(47; "Hasta Nº Mov. contabilidad"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Hasta Nº Mov. contabilidad';
        }
        field(48; "Importe Pendiente (DL)"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Outstanding Amount (LCY)', ESP = 'Importe Pendiente (DL)';
            Caption = 'Importe pendiente (DL)'; //'Outstanding Amount (LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                IF "Importe Pendiente (DL)" < 0 THEN
                    "Importe a Liquidar (DL)" := -1 * ABS("Importe a Liquidar (DL)")
                ELSE
                    "Importe a Liquidar (DL)" := ABS("Importe a Liquidar (DL)");
                IF ABS("Importe a Liquidar (DL)") > ABS("Importe Pendiente (DL)") THEN ERROR(Text001);
                "Importe a Liquidar" := CurrExchRate.ExchangeAmtLCYToFCY(WORKDATE, "Cód. divisa", "Importe a Liquidar (DL)", CurrExchRate.ExchangeRate(WORKDATE, "Cód. divisa"));
            end;
        }
        field(49; "Importe a Liquidar (DL)"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Amount to liquidate (LCY)', ESP = 'Importe a Liquidar (DL)';
            Caption = 'Importe a liquidar (DL)'; //'Amount to liquidate (LCY)';
        }
        field(50; País; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Country/Region".Code;
        }
        field(51; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cód. dim. acceso dir. 1';
            Caption = 'Cod. Dim 1'; //'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(52; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cód. dim. acceso dir. 2';
            Caption = 'Cod. Dim 2'; //'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(53; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Shortcut Dimension 3 Code', ESP = 'Cód. dim. acceso dir. 3';
            Caption = 'Cod. Dim 3'; //'Shortcut Dimension 3 Code';
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(54; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Shortcut Dimension 4 Code', ESP = 'Cód. dim. acceso dir. 4';
            Caption = 'Cod. Dim 4'; //'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(50000; "Report Sorting 1"; Code[10])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Report Sorting 1', ESP = 'Ordenación Informes 1';
            Caption = 'Ordenación informe 1'; //'Report Sorting 1';
        }
        field(50001; "Report Sorting 2"; Code[10])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Report Sorting 2', ESP = 'Ordenación Informes 2';
            Caption = 'Ordenación informe 2'; //'Report Sorting 2';
        }
        field(50002; "Report Sorting 3"; Code[10])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Report Sorting 3', ESP = 'Ordenación Informes 3';
            Caption = 'Ordenación informe 3'; //'Report Sorting 3';
        }
        field(7043530; Factura; Option)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Invoice', ESP = 'Factura';
            Caption = 'Factura'; //'Invoice';
            OptionMembers = "Con factura","Sin factura";
            //OptionCaptionML = ENU = 'With invoice, No invoice', ESP = 'Con factura,Sin factura';
            OptionCaption = 'Con factura,Sin factura'; //'With invoice, No invoice';
        }
        field(7043531; Efecto; Boolean)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Bill', ESP = 'Efecto';
            Caption = 'Efecto'; //'Bill';
        }
        field(7043532; "Tipo Liquidacion"; Option)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Type Liquidation', ESP = 'Tipo Liquidación';
            Caption = 'Tipo liquidación'; //'Type Liquidation';
            OptionMembers = "Cliente/Proveedor","Banco","Cuenta";
            //OptionCaptionML = ENU = 'Customer/Vendor,Bank,Account', ESP = 'Cliente/Proveedor,Banco,Cuenta';
            OptionCaption = 'Cliente/Proveedor,Banco,Cuenta'; //'Customer/Vendor,Bank,Account';
        }
    }
    keys
    {
        key(PK; "Nº mov.")
        {
            Clustered = true;
        }
        key(AA; "Nº documento", "Fecha registro")
        {
        }
        key(BB; "Nº documento", "Tipo Documento", Revertido, "Fecha registro")
        {
        }
        key(CC; "Clave IRPF", "Subclave IRPF", "Cif/Nif", "Fecha registro")
        {
        }
        key(DD; "Nº Proveedor / Nº Cliente", "Clave de Percepción", "Nº documento", "Fecha registro")
        {
        }
        key(EE; "Nº Proveedor / Nº Cliente", "Clave IRPF")
        {
            SumIndexFields = "Importe retención";
        }
        key(FF; "Cli/Prov", "Nº Proveedor / Nº Cliente", "Tipo Retención", "Nº Proyecto")
        {
        }
        key(GG; "Nº asiento")
        {
            SumIndexFields = "Importe retención";
        }
        key(HH; "Desde Nº Mov. contabilidad", "Hasta Nº Mov. contabilidad")
        {
        }
        key(II; "Cli/Prov", "Nº Proveedor / Nº Cliente", "Tipo percepción", "Fecha registro")
        {
        }
        key(JJ; "Cif/Nif")
        {
        }
        key(KK; "Clave de Percepción", "Cif/Nif", "Fecha registro")
        {
        }
        key(LL; Pendiente, "Tipo Retención", "Nº Proveedor / Nº Cliente", "Cli/Prov")
        {
            SumIndexFields = "Importe retención";
        }
        key(MM; "Subclave IRPF", "Cif/Nif", "Fecha registro")
        {
        }
    }
    var
        Text001: Label 'El importe a liquidar no puede ser superior al importe pendiente';
        CurrExchRate: Record "Currency Exchange Rate";

    procedure LiquidarAbono(VAR WitholdingTaxregistersPara: Record "IND Witholding Tax registers")
    var
        WitholdingTaxRegistersLocal: Record "IND Witholding Tax registers";
        WitholdingTaxRegisters2Local: Record "IND Witholding Tax registers";
        FiltroMovsLocal: Text[250];
        SumLocal: Decimal;
        ImportePendienteLiq: Decimal;
        ImpPenFact: Decimal;
        ListaMovRetencionesLocal: page "IND Witholding tax registers";
        Text001Local: Label '¿ Confirma que desea liquidar el mov. retención %1 ?';
        Text002Local: Label 'Proceso cancelado.';
        Text003Local: Label 'El importe de los  mov. seleccionados es %1 y no se pueden superar los %2 del mov. %3';
    begin
        WitholdingTaxregistersPara.TESTFIELD("Tipo Documento", WitholdingTaxregistersPara."Tipo Documento"::"Credit Memo");
        IF NOT CONFIRM(STRSUBSTNO(Text001Local, WitholdingTaxregistersPara."Nº mov."), TRUE) THEN ERROR(Text002Local);
        WitholdingTaxRegistersLocal.RESET;
        //WitholdingTaxRegistersLocal.FILTERGROUP(2);
        WitholdingTaxRegistersLocal.SETRANGE("Nº Proveedor / Nº Cliente", WitholdingTaxregistersPara."Nº Proveedor / Nº Cliente");
        WitholdingTaxRegistersLocal.SETRANGE(Pendiente, TRUE);
        WitholdingTaxRegistersLocal.SETFILTER("Importe Pendiente", '<>%1', 0);
        WitholdingTaxRegistersLocal.SETRANGE("Liquidado por Movimiento", '');
        WitholdingTaxRegistersLocal.SETRANGE("Cli/Prov", WitholdingTaxregistersPara."Cli/Prov"::Proveedor);
        WitholdingTaxRegistersLocal.SETFILTER("Tipo Documento", '<>%1', WitholdingTaxRegistersLocal."Tipo Documento"::"Credit Memo");
        //WitholdingTaxRegistersLocal.FILTERGROUP(0);
        IF WitholdingTaxRegistersLocal.FINDFIRST THEN BEGIN
            CLEAR(ListaMovRetencionesLocal);
            ListaMovRetencionesLocal.SETTABLEVIEW(WitholdingTaxRegistersLocal);
            ListaMovRetencionesLocal.LOOKUPMODE(TRUE);
            IF (ListaMovRetencionesLocal.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                ListaMovRetencionesLocal.SetSelectionFilter(WitholdingTaxRegisters2Local);
                ;
                //IF SumLocal > WitholdingTaxregistersPara."Importe retención" THEN
                //  ERROR(Text003Local,SumLocal,WitholdingTaxregistersPara."Importe retención",WitholdingTaxregistersPara."Nº mov.");
                ImportePendienteLiq := WitholdingTaxregistersPara."Importe a Liquidar";
                //WitholdingTaxRegisters2Local.RESET;
                //WitholdingTaxRegisters2Local.SETFILTER("Nº mov.", FiltroMovsLocal);
                IF WitholdingTaxRegisters2Local.FINDFIRST THEN BEGIN
                    REPEAT
                        SumLocal := SumLocal + ABS(WitholdingTaxRegisters2Local."Importe Pendiente");
                        ImpPenFact := ABS(WitholdingTaxRegisters2Local."Importe Pendiente");
                        IF ABS(WitholdingTaxRegisters2Local."Importe Pendiente") <= ImportePendienteLiq THEN BEGIN
                            WitholdingTaxRegisters2Local.Pendiente := FALSE;
                            WitholdingTaxRegisters2Local."Importe Pendiente" := 0;
                            WitholdingTaxRegisters2Local."Importe Pendiente (DL)" := 0;
                            WitholdingTaxRegisters2Local."Liquidado por Movimiento" := FORMAT(WitholdingTaxregistersPara."Nº mov.");
                            WitholdingTaxRegisters2Local."Importe a Liquidar" := 0;
                            WitholdingTaxRegisters2Local."Importe a Liquidar (DL)" := 0;
                            WitholdingTaxRegisters2Local.MODIFY;
                        END
                        ELSE BEGIN
                            WitholdingTaxRegisters2Local.Pendiente := TRUE;
                            WitholdingTaxRegisters2Local."Importe Pendiente" := WitholdingTaxRegisters2Local."Importe Pendiente" + ImportePendienteLiq;
                            WitholdingTaxRegisters2Local."Importe Pendiente (DL)" := WitholdingTaxRegisters2Local."Importe Pendiente (DL)" + ImportePendienteLiq;
                            WitholdingTaxRegisters2Local."Liquidado por Movimiento" := FORMAT(WitholdingTaxregistersPara."Nº mov.");
                            WitholdingTaxRegisters2Local."Importe a Liquidar" := WitholdingTaxRegisters2Local."Importe a Liquidar" + ImportePendienteLiq;
                            WitholdingTaxRegisters2Local."Importe a Liquidar (DL)" := WitholdingTaxRegisters2Local."Importe a Liquidar (DL)" + ImportePendienteLiq;
                            WitholdingTaxRegisters2Local.MODIFY;
                        END;
                        ImportePendienteLiq := ImportePendienteLiq - ImpPenFact;
                    UNTIL (WitholdingTaxRegisters2Local.NEXT = 0) OR (ImportePendienteLiq <= 0);
                END;
                IF WitholdingTaxregistersPara."Liquidado por Movimiento" = '' THEN
                    WitholdingTaxregistersPara."Liquidado por Movimiento" := FiltroMovsLocal
                ELSE
                    WitholdingTaxregistersPara."Liquidado por Movimiento" := WitholdingTaxregistersPara."Liquidado por Movimiento" + '|' + FiltroMovsLocal;
                WitholdingTaxregistersPara."Importe Pendiente" := WitholdingTaxregistersPara."Importe Pendiente" - SumLocal;
                WitholdingTaxregistersPara."Importe Pendiente (DL)" := WitholdingTaxregistersPara."Importe Pendiente (DL)" - SumLocal;
                //TECNOCOM - EFS - 211112 - añado el "<" y los campos de "Importe a Liquidar"
                WitholdingTaxregistersPara."Importe a Liquidar" := WitholdingTaxregistersPara."Importe a Liquidar" - SumLocal;
                WitholdingTaxregistersPara."Importe a Liquidar (DL)" := WitholdingTaxregistersPara."Importe a Liquidar (DL)" - SumLocal;
                //TECNOCOM - EFS - 211112 - añado el "<" y los campos de "pendiente"
                IF WitholdingTaxregistersPara."Importe Pendiente" <= 0 THEN BEGIN
                    WitholdingTaxregistersPara.Pendiente := FALSE;
                    WitholdingTaxregistersPara."Importe a Liquidar" := 0;
                    WitholdingTaxregistersPara."Importe a Liquidar (DL)" := 0;
                    WitholdingTaxregistersPara."Importe Pendiente" := 0;
                    WitholdingTaxregistersPara."Importe Pendiente (DL)" := 0;
                END;
                WitholdingTaxregistersPara.MODIFY;
            END;
        END;
    end;

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
    end;

    trigger OnRename()
    begin
    end;
}
