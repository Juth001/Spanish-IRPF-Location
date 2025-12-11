namespace Excelia.IRPF;
using Microsoft.Finance.Currency;
using Microsoft.Inventory.Intrastat;
using Microsoft.Projects.Project.Job;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.Address;
using Microsoft.Sales.Customer;
table 86303 "EXC Retention Tax registers"
{
    DataClassification = CustomerContent;
    Caption = 'Retention Tax registers';
    LookupPageId = "EXC Retention Tax Registers";
    DrillDownPageId = "EXC Retention Tax Registers";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
            Description = 'Número de asiento de retención en el libro diario.';
            ToolTip = 'Muestra el número de asiento de retención en el libro diario.';
        }
        field(2; "Nº Proveedor / Nº Cliente"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nº proveedor / Nº cliente';
            //TODO: TableRelation = if ("Cust/Vend" = const(Customer)) Customer."No." else if ("Cust/Vend" = const(Vendor)) Vendor.No;
        }
        field(3; Description; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
            Description = 'Descripción del cliente o proveedor.';
            ToolTip = 'Muestra la descripción del cliente o proveedor.';
        }
        field(4; "CIF/NIF"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CIF/NIF';
            Description = 'CIF o NIF del cliente o proveedor.';
            ToolTip = 'Muestra el CIF o NIF del cliente o proveedor.';
        }
        field(5; "Fecha emisión documento"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha emisión documento';
            Description = 'Fecha de emisión del documento.';
            ToolTip = 'Muestra la fecha de emisión del documento.';
        }
        field(6; "Fecha registro"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha registro';
            Description = 'Fecha de registro del asiento de retención.';
            ToolTip = 'Muestra la fecha de registro del asiento de retención.';
        }
        field(7; "Nº documento"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nº documento';
            Description = 'Número del documento asociado a la retención.';
            ToolTip = 'Muestra el número del documento asociado a la retención.';
        }
        field(9; "Importe factura iva incl."; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Importe factura IVA incl.';
            Description = 'Importe total de la factura, incluyendo IVA.';
            ToolTip = 'Muestra el importe total de la factura, incluyendo IVA.';
        }
        field(10; "Base retención"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Base retención';
            Description = 'Base sobre la cual se calcula la retención.';
            ToolTip = 'Muestra la base sobre la cual se calcula la retención.';
        }
        field(11; "% retención"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '% retención';
            Description = 'Porcentaje aplicado para calcular la retención.';
            ToolTip = 'Muestra el porcentaje aplicado para calcular la retención.';
        }
        field(12; "Tipo de Perceptor"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Tipo de perceptor';
            Description = 'Tipo de perceptor asociado a este registro de retención.';
            ToolTip = 'Muestra el tipo de perceptor asociado a este registro de retención.';
            TableRelation = "EXC Perception Type".Code;
        }
        field(13; "Clave de Percepción"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Clave de percepción';
            Description = 'Clave de percepción asociada a este registro de retención.';
            ToolTip = 'Muestra la clave de percepción asociada a este registro de retención.';
            TableRelation = "EXC Perception Keys".Code;
        }
        field(14; "Importe retención"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Importe retención';
            Description = 'Importe de la retención aplicada.';
            ToolTip = 'Muestra el importe de la retención aplicada.';
        }
        field(15; "Cta. retención"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cta. retención';
            Description = 'Cuenta contable asociada a la retención.';
            ToolTip = 'Muestra la cuenta contable asociada a la retención.';
        }
        field(16; "Importe retención (DL)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Importe retención (DL)';
            Description = 'Importe de la retención en moneda local.';
            ToolTip = 'Muestra el importe de la retención en moneda local.';
        }
        field(17; "C.P"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'C.P.';
            Description = 'Código postal asociado al cliente o proveedor.';
            ToolTip = 'Muestra el código postal asociado al cliente o proveedor.';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(18; "Fecha exportación"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha exportación';
            Description = 'Fecha en la que se exportó el registro de retención.';
            ToolTip = 'Muestra la fecha en la que se exportó el registro de retención.';
        }
        field(19; Exportado; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Exportado';
            Description = 'Indica si el registro de retención ha sido exportado.';
            ToolTip = 'Indica si el registro de retención ha sido exportado.';
        }
        field(20; "Nº asiento"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
            Description = 'Número de asiento contable asociado a la retención.';
            ToolTip = 'Muestra el número de asiento contable asociado a la retención.';
        }
        field(21; "Nº archivo"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'File No.';
            Description = 'Número de archivo asociado a la retención.';
            ToolTip = 'Muestra el número de archivo asociado a la retención.';
        }
        field(22; "Cód. origen"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Cód. origen';
            Description = 'Código de origen del registro de retención.';
            ToolTip = 'Muestra el código de origen del registro de retención.';
            TableRelation = "Source Code";
        }
        field(23; "Base retencion (DL)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Base (LCY)';
            Description = 'Base de retención en moneda local.';
            ToolTip = 'Muestra la base de retención en moneda local.';
        }
        field(24; "Cód. divisa"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Currency Code';
            Description = 'Código de divisa utilizado en el registro de retención.';
            ToolTip = 'Muestra el código de divisa utilizado en el registro de retención.';
            TableRelation = Currency;
        }
        field(25; "Importe Factura (DL)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice amount (LCY)';
            Description = 'Importe de la factura en moneda local.';
            ToolTip = 'Muestra el importe de la factura en moneda local.';
        }
        field(26; "Nombre 1"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Name 1';
            Description = 'Primer nombre del cliente o proveedor.';
            ToolTip = 'Muestra el primer nombre del cliente o proveedor.';
        }
        field(27; "Nombre 2/Apellidos"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Name 2/surname';
            Description = 'Segundo nombre o apellidos del cliente o proveedor.';
            ToolTip = 'Muestra el segundo nombre o apellidos del cliente o proveedor.';
        }
        field(28; "Código provincia"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Código provincia';
            Description = 'Código de la provincia asociada al cliente o proveedor.';
            ToolTip = 'Muestra el código de la provincia asociada al cliente o proveedor.';
            TableRelation = "Area";
        }
        field(29; "Año devengo"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Acrued Year';
            Description = 'Año en el que se devengó la retención.';
            ToolTip = 'Muestra el año en el que se devengó la retención.';
        }
        field(30; "Clave IRPF"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Clave IRPF';
            Description = 'Clave de IRPF asociada a la retención.';
            ToolTip = 'Muestra la clave de IRPF asociada a la retención.';
            OptionMembers = " ","A","B","C","D","E","F","G","H","I","J","K","L",,,,,,"19";
            OptionCaption = ',A,B,C,D,E,F,G,H,I,J,K,L,,,,,,19';
            Editable = true;
        }
        field(31; "Subclave IRPF"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Subclave IRPF'; // 'IRPF Subkey';
            OptionMembers = " ","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16";
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
                reProyecto.Reset();
                if reProyecto.Get("Nº Proyecto") then
                    "Descripción Proyecto" := reProyecto.Description
                else
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
        field(38; "Cust/Vend"; Option)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Cust/Vend', ESP = 'Cli/Prov';
            Caption = 'Cli/Prov'; //'Cust/Vend';
            OptionMembers = "Customer","Vendor";
            //OptionCaptionML = ENU = 'Customer,Vendor', ESP = 'Cliente,Proveedor';
            OptionCaption = 'Customer,Vendor';
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
                if "Importe a Liquidar" < 0 then
                    "Importe a Liquidar" := -1 * ABS("Importe a Liquidar")
                else
                    "Importe a Liquidar" := ABS("Importe a Liquidar");
                if Abs("Importe a Liquidar") > Abs("Importe Pendiente") then Error(Text001);
                "Importe a Liquidar (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, "Cód. divisa", "Importe a Liquidar", CurrExchRate.ExchangeRate(WorkDate, "Cód. divisa"));
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
                if "Importe Pendiente (DL)" < 0 then
                    "Importe a Liquidar (DL)" := -1 * ABS("Importe a Liquidar (DL)")
                else
                    "Importe a Liquidar (DL)" := ABS("Importe a Liquidar (DL)");
                if ABS("Importe a Liquidar (DL)") > ABS("Importe Pendiente (DL)") then ERROR(Text001);
                "Importe a Liquidar" := CurrExchRate.ExchangeAmtLCYToFCY(WorkDate, "Cód. divisa", "Importe a Liquidar (DL)", CurrExchRate.ExchangeRate(WorkDate, "Cód. divisa"));
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
            Caption = 'Ordenación informe 1';
        }
        field(50001; "Report Sorting 2"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Ordenación informe 2';
        }
        field(50002; "Report Sorting 3"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Ordenación informe 3';
        }
        field(7043530; Factura; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Factura';
            OptionMembers = "Con factura","Sin factura";
            OptionCaption = 'Con factura,Sin factura';
        }
        field(7043531; Efecto; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Efecto';
        }
        field(7043532; "Tipo Liquidacion"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Tipo liquidación';
            OptionMembers = "Cliente/Proveedor","Banco","Cuenta";
            OptionCaption = 'Cliente/Proveedor,Banco,Cuenta';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(AA; "Nº documento", "Fecha registro")
        {
        }
        key(BB; "Nº documento", "Tipo Documento", Revertido, "Fecha registro")
        {
        }
        key(CC; "Clave IRPF", "Subclave IRPF", "CIF/NIF", "Fecha registro")
        {
        }
        key(DD; "Nº Proveedor / Nº Cliente", "Clave de Percepción", "Nº documento", "Fecha registro")
        {
        }
        key(EE; "Nº Proveedor / Nº Cliente", "Clave IRPF")
        {
            SumIndexFields = "Importe retención";
        }
        key(FF; "Cust/Vend", "Nº Proveedor / Nº Cliente", "Tipo Retención", "Nº Proyecto")
        {
        }
        key(GG; "Nº asiento")
        {
            SumIndexFields = "Importe retención";
        }
        key(HH; "Desde Nº Mov. contabilidad", "Hasta Nº Mov. contabilidad")
        {
        }
        key(II; "Cust/Vend", "Nº Proveedor / Nº Cliente", "Tipo percepción", "Fecha registro")
        {
        }
        key(JJ; "CIF/NIF")
        {
        }
        key(KK; "Clave de Percepción", "CIF/NIF", "Fecha registro")
        {
        }
        key(LL; Pendiente, "Tipo Retención", "Nº Proveedor / Nº Cliente", "Cust/Vend")
        {
            SumIndexFields = "Importe retención";
        }
        key(MM; "Subclave IRPF", "CIF/NIF", "Fecha registro")
        {
        }
    }
    var

        CurrExchRate: Record "Currency Exchange Rate";
        Text001: Label 'El importe a liquidar no puede ser superior al importe pendiente';

    procedure LiquidarAbono(VAR WitholdingTaxregistersPara: Record "EXC Retention Tax registers")
    var
        WitholdingTaxRegistersLocal: Record "EXC Retention Tax registers";
        WitholdingTaxRegisters2Local: Record "EXC Retention Tax registers";
        ListaMovRetencionesLocal: page "EXC Retention Tax Registers";
        Text001Local: Label '¿ Confirma que desea liquidar el mov. retención %1 ?';
        Text002Local: Label 'Proceso cancelado.';
        FiltroMovsLocal: Text[250];
        SumLocal: Decimal;
        ImportePendienteLiq: Decimal;
        ImpPenFact: Decimal;
    begin
        WitholdingTaxregistersPara.Testfield("Tipo Documento", WitholdingTaxregistersPara."Tipo Documento"::"Credit Memo");
        if NOT CONFIRM(STRSUBSTNO(Text001Local, WitholdingTaxregistersPara."Entry No."), true) then ERROR(Text002Local);
        WitholdingTaxRegistersLocal.Reset();
        WitholdingTaxRegistersLocal.Setrange("Nº Proveedor / Nº Cliente", WitholdingTaxregistersPara."Nº Proveedor / Nº Cliente");
        WitholdingTaxRegistersLocal.Setrange(Pendiente, true);
        WitholdingTaxRegistersLocal.SETFILTER("Importe Pendiente", '<>%1', 0);
        WitholdingTaxRegistersLocal.Setrange("Liquidado por Movimiento", '');
        WitholdingTaxRegistersLocal.Setrange("Cust/Vend", WitholdingTaxregistersPara."Cust/Vend"::Vendor);
        WitholdingTaxRegistersLocal.SETFILTER("Tipo Documento", '<>%1', WitholdingTaxRegistersLocal."Tipo Documento"::"Credit Memo");
        if WitholdingTaxRegistersLocal.FindFIRST() then begin
            clear(ListaMovRetencionesLocal);
            ListaMovRetencionesLocal.SETTABLEVIEW(WitholdingTaxRegistersLocal);
            ListaMovRetencionesLocal.LOOKUPMODE(true);
            if (ListaMovRetencionesLocal.RUNMODAL() = ACTION::LookupOK) then begin
                ListaMovRetencionesLocal.SetSelectionFilter(WitholdingTaxRegisters2Local);
                ImportePendienteLiq := WitholdingTaxregistersPara."Importe a Liquidar";

                if WitholdingTaxRegisters2Local.FindFIRST() then
                    repeat
                        SumLocal := SumLocal + ABS(WitholdingTaxRegisters2Local."Importe Pendiente");
                        ImpPenFact := ABS(WitholdingTaxRegisters2Local."Importe Pendiente");
                        if ABS(WitholdingTaxRegisters2Local."Importe Pendiente") <= ImportePendienteLiq then begin
                            WitholdingTaxRegisters2Local.Pendiente := false;
                            WitholdingTaxRegisters2Local."Importe Pendiente" := 0;
                            WitholdingTaxRegisters2Local."Importe Pendiente (DL)" := 0;
                            WitholdingTaxRegisters2Local."Liquidado por Movimiento" := FORMAT(WitholdingTaxregistersPara."Entry No.");
                            WitholdingTaxRegisters2Local."Importe a Liquidar" := 0;
                            WitholdingTaxRegisters2Local."Importe a Liquidar (DL)" := 0;
                            WitholdingTaxRegisters2Local.Modify();
                        end
                        else begin
                            WitholdingTaxRegisters2Local.Pendiente := true;
                            WitholdingTaxRegisters2Local."Importe Pendiente" := WitholdingTaxRegisters2Local."Importe Pendiente" + ImportePendienteLiq;
                            WitholdingTaxRegisters2Local."Importe Pendiente (DL)" := WitholdingTaxRegisters2Local."Importe Pendiente (DL)" + ImportePendienteLiq;
                            WitholdingTaxRegisters2Local."Liquidado por Movimiento" := FORMAT(WitholdingTaxregistersPara."Entry No.");
                            WitholdingTaxRegisters2Local."Importe a Liquidar" := WitholdingTaxRegisters2Local."Importe a Liquidar" + ImportePendienteLiq;
                            WitholdingTaxRegisters2Local."Importe a Liquidar (DL)" := WitholdingTaxRegisters2Local."Importe a Liquidar (DL)" + ImportePendienteLiq;
                            WitholdingTaxRegisters2Local.Modify();
                        end;
                        ImportePendienteLiq := ImportePendienteLiq - ImpPenFact;
                    until (WitholdingTaxRegisters2Local.Next() = 0) OR (ImportePendienteLiq <= 0);
            end;
            if WitholdingTaxregistersPara."Liquidado por Movimiento" = '' then
                WitholdingTaxregistersPara."Liquidado por Movimiento" := FiltroMovsLocal
            else
                WitholdingTaxregistersPara."Liquidado por Movimiento" := WitholdingTaxregistersPara."Liquidado por Movimiento" + '|' + FiltroMovsLocal;
            WitholdingTaxregistersPara."Importe Pendiente" := WitholdingTaxregistersPara."Importe Pendiente" - SumLocal;
            WitholdingTaxregistersPara."Importe Pendiente (DL)" := WitholdingTaxregistersPara."Importe Pendiente (DL)" - SumLocal;
            WitholdingTaxregistersPara."Importe a Liquidar" := WitholdingTaxregistersPara."Importe a Liquidar" - SumLocal;
            WitholdingTaxregistersPara."Importe a Liquidar (DL)" := WitholdingTaxregistersPara."Importe a Liquidar (DL)" - SumLocal;
            if WitholdingTaxregistersPara."Importe Pendiente" <= 0 then begin
                WitholdingTaxregistersPara.Pendiente := false;
                WitholdingTaxregistersPara."Importe a Liquidar" := 0;
                WitholdingTaxregistersPara."Importe a Liquidar (DL)" := 0;
                WitholdingTaxregistersPara."Importe Pendiente" := 0;
                WitholdingTaxregistersPara."Importe Pendiente (DL)" := 0;
            end;
            WitholdingTaxregistersPara.Modify();
        end;
    end;


}
