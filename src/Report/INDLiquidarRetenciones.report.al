// namespace Excelia.IRPF;
// using Microsoft.Foundation.NoSeries;
// report 86302 "IND Liquidar Retenciones"
// {
//     // version INDRA
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     Caption = 'Liquidar Retenciones';
//     ProcessingOnly = true;

//     dataset
//     {
//         dataitem("Mov. retención"; "EXC Retention Tax registers")
//         {
//             trigger OnPreDataItem()
//             begin
//                 //Dataitem para liquidar retenciones sin FACTURA
//                 ConfContabilidad.Get();
//                 ConfContabilidad.Testfield("Retention Journal Template");
//                 ConfContabilidad.Testfield("Retention Aux. Batch");
//                 ConfContabilidad.Testfield("Retention Batch");
//                 clear(Seccionr);
//                 Seccionr.Reset();
//                 if Seccionr.Get(ConfContabilidad."Retention Journal Template", ConfContabilidad."Retention Batch") then begin
//                     Seccionr.Testfield("No. Series");
//                     Numdocumentov := Numseriesmgt.GetNextNo(Seccionr."No. Series", WorkDate(), false);
//                 end;
//                 LinDiario.Reset();
//                 LinDiario.Setrange("Journal Template Name", ConfContabilidad."Retention Journal Template");
//                 LinDiario.Setrange("Journal Batch Name", ConfContabilidad."Retention Batch");
//                 if LinDiario.Find('-') then LinDiario.DeleteAll();
//                 LinDiario.Reset();
//                 LinDiario.Setrange("Journal Template Name", ConfContabilidad."Retention Journal Template");
//                 LinDiario.Setrange("Journal Batch Name", ConfContabilidad."Retention Aux. Batch");
//                 if LinDiario.Find('-') then LinDiario.DeleteAll();
//                 clear(bolCabecera);
//                 clear(numLinea);
//                 Setrange(Pendiente, true);
//             end;

//             trigger OnAfterGetRecord()
//             begin
//                 if VEfecto then begin
//                     if "Mov. retención"."Cust/Vend" = "Mov. retención"."Cust/Vend"::Cliente then begin
//                         if NOT HistFactVenta.Get("Mov. retención"."Nº documento") then if HistAbonVenta.Get("Mov. retención"."Nº documento") then ERROR(TextIbdos002);
//                     end
//                     else begin
//                         if NOT HistFactCompra.Get("Mov. retención"."Nº documento") then if HistAbonCompra.Get("Mov. retención"."Nº documento") then ERROR(TextIbdos002);
//                     end;
//                 end;
//                 if "Mov. retención"."Nº documento" <> UltDoc then begin
//                     UltDoc := "Mov. retención"."Nº documento";
//                     clear(UltEfectoMismoDoc);
//                 end;
//                 if bolFactura then
//                     retencionFactura("Mov. retención")
//                 else
//                     retencionSinFactura("Mov. retención");
//             end;

//             trigger OnPostDataItem()
//             begin
//                 bolContinuar := true;
//             end;
//         }
//     }
//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group("Opciones")
//                 {
//                     field(optTipo; Tipo)
//                     {
//                         ApplicationArea = All;
//                         //Enabled = bolFacturapage;
//                         //CaptionML = ESP = 'Liquidar por';
//                         Caption = 'Liquidar por';

//                         trigger OnValidate()
//                         begin
//                             if Tipo = Tipo::"Cliente/Proveedor" then
//                                 BoolCuenta := false
//                             else
//                                 BoolCuenta := true;
//                             if NOT bolFacturapage then BoolCuenta := false;
//                         end;
//                     }
//                     field(txtCuenta; Cuenta)
//                     {
//                         ApplicationArea = All;
//                         //CaptionML = ESP = 'Cuenta';
//                         Caption = 'Cuenta';

//                         //Enabled = BoolCuenta;
//                         ;
//                         trigger OnLookup(var txt1: text): Boolean
//                         var
//                             reBanco: Record 270;
//                             frmListaBanco: Page 371;
//                             reCuenta: Record 15;
//                             frmListaCuentas: Page 18;
//                         begin
//                             if Tipo = Tipo::Banco then begin
//                                 reBanco.Reset();
//                                 clear(frmListaBanco);
//                                 frmListaBanco.SETTABLEVIEW(reBanco);
//                                 frmListaBanco.LOOKUPMODE := true;
//                                 frmListaBanco.SETRECORD(reBanco);
//                                 if frmListaBanco.RUNMODAL() = ACTION::LookupOK then begin
//                                     frmListaBanco.GETRECORD(reBanco);
//                                     Cuenta := reBanco."No.";
//                                 end
//                             end
//                             else begin
//                                 reCuenta.Reset();
//                                 clear(frmListaCuentas);
//                                 frmListaCuentas.SETTABLEVIEW(reCuenta);
//                                 frmListaCuentas.LOOKUPMODE := true;
//                                 frmListaCuentas.SETRECORD(reCuenta);
//                                 if frmListaCuentas.RUNMODAL() = ACTION::LookupOK then begin
//                                     frmListaCuentas.GETRECORD(reCuenta);
//                                     Cuenta := reCuenta."No.";
//                                 end
//                             end
//                         end;
//                     }
//                     field(chkEfecto; VEfecto)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Tipo efecto';
//                     }
//                     field(bolFactura; bolFactura)
//                     {
//                         ApplicationArea = All;
//                         //Enabled = bolFacturapage;
//                         //CaptionML = ESP = 'Tipo efecto';
//                         Caption = 'Factura';
//                     }
//                 }
//             }
//         }
//         actions
//         {
//             area(processing)
//             {
//                 action(ActionName)
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }
//     trigger OnInitReport()
//     var
//         myInt: Integer;
//     begin
//         clear(bolContinuar);
//         clear(UltEfectoMismoDoc);
//         clear(UltDoc);
//         bolFacturapage := NOT bolFactura;
//     end;

//     trigger OnPostReport()
//     var
//         myInt: Integer;
//     begin
//         Realizaragrupacionporpais();
//         if NOT NoMuestraDiario then
//             if NOT bolFactura then begin
//                 ConfContabilidad.Get();
//                 COMMIT();
//                 GenJnlLine.Reset();
//                 GenJnlTemplate.Get(ConfContabilidad."Retention Journal Template");
//                 GenJnlLine.FILTERGROUP := 2;
//                 GenJnlLine.Setrange("Journal Template Name", ConfContabilidad."Retention Journal Template");
//                 GenJnlLine.FILTERGROUP := 0;
//                 GenJnlManagement.SetName(ConfContabilidad."Retention Batch", GenJnlLine);
//                 clear(frmDiarioGen);
//                 PAGE.RUNMODAL(GenJnlTemplate."Page ID", GenJnlLine);
//             end;
//     end;

//     var
//         VEfecto: Boolean;
//         LinDiario: Record 81;
//         NLin: Integer;
//         FormCartera: Page 7000036;
//         CarteraSetupw: Record 7000016;
//         bolFactura: Boolean;
//         bolCabecera: Boolean;
//         numLinea: Integer;
//         NumDocumento: Code[20];
//         TextIbdos001: Label 'debe tener configurada una forma de pago que genere efectos.';
//         Tipo: option "Cliente/Proveedor","Banco","Cuenta";
//         Cuenta: Code[20];
//         bolContinuar: Boolean;
//         UltEfectoMismoDoc: Code[20];
//         UltDoc: Code[20];
//         TipoFactura: Boolean;
//         TextIbdos002: Label 'No se pueden liquidar mov. retención de un Abono con un efecto.';
//         HistFactVenta: Record 112;
//         HistAbonVenta: Record 114;
//         HistFactCompra: Record 122;
//         HistAbonCompra: Record 124;
//         ConfContabilidad: Record 98;
//         Seccionr: Record 232;
//         Numdocumentov: Code[20];
//         Numseriesmgt: Codeunit "No. Series";
//         bolFacturapage: Boolean;
//         BoolCuenta: Boolean;
//         NoMuestraDiario: Boolean;
//         GenJnlLine: Record 81;
//         GenJnlTemplate: Record 80;
//         GenJnlManagement: Codeunit 230;
//         frmDiarioGen: Page 7000036;

//     procedure UltLinea();
//     begin
//         NLin := 0;
//         LinDiario.LockTable();
//         LinDiario.Reset();
//         LinDiario.Setrange("Journal Template Name", ConfContabilidad."Retention Journal Template");
//         LinDiario.Setrange("Journal Batch Name", ConfContabilidad."Retention Aux. Batch");
//         if LinDiario.Find('+') then NLin := LinDiario."Line No.";
//     end;

//     procedure FormaPago(): Code[10];
//     VAR
//         FPago: Record 289;
//     begin
//         FPago.Reset();
//         FPago.Setrange("Create Bills", true);
//         if FPago.Find('-') then
//             exit(FPago.Code)
//         else
//             ERROR(TextIbdos001);
//     end;

//     procedure CreateInvoice(pBolFactura: Boolean);
//     begin
//         bolFactura := pBolFactura;
//     end;

//     procedure CreaFacturaVT(pReRetencion: Record "EXC Retention Tax registers");
//     VAR
//         reFacVTCb: Record 36;
//         reFacVTLin: Record 37;
//     begin
//         //Cabecera
//         if NOT bolCabecera then begin
//             reFacVTCb.Reset();
//             reFacVTCb.INIT();
//             reFacVTCb."Document Type" := reFacVTCb."Document Type"::Invoice;
//             reFacVTCb."No." := '';
//             reFacVTCb.Insert(true);
//             reFacVTCb.Validate("Sell-to Customer No.", pReRetencion."Nº Proveedor / Nº Cliente");
//             reFacVTCb."Type Perception" := pReRetencion."Tipo de Perceptor";
//             reFacVTCb."Key Perception" := pReRetencion."Clave de Percepción";
//             reFacVTCb.Validate("Shortcut Dimension 2 Code", "Mov. retención"."Nº Proyecto");
//             reFacVTCb.Modify();
//             bolCabecera := true;
//             NumDocumento := reFacVTCb."No.";
//         end;
//         //Lineas
//         reFacVTLin.Reset();
//         reFacVTLin.INIT();
//         reFacVTLin."Document Type" := reFacVTLin."Document Type"::Invoice;
//         reFacVTLin."Document No." := NumDocumento;
//         numLinea += 10000;
//         reFacVTLin."Line No." := numLinea;
//         reFacVTLin.Insert(true);
//         reFacVTLin.Type := reFacVTLin.Type::"G/L Account";
//         reFacVTLin.Validate("No.", pReRetencion."Cta. retención");
//         reFacVTLin.Validate(Quantity, 1);
//         reFacVTLin.Validate("Unit Price", pReRetencion."Importe a Liquidar");
//         reFacVTLin."Perception Type" := pReRetencion."Tipo de Perceptor";
//         reFacVTLin."Perception Key" := pReRetencion."Clave de Percepción";
//         reFacVTLin."Deduction Line" := true;
//         reFacVTLin."Deduction Entry" := pReRetencion."Entry No.";
//         reFacVTLin.Modify();
//     end;

//     procedure CreaFacturaCP(pReRetencion: Record "EXC Retention Tax registers");
//     VAR
//         reFacCPCb: Record 38;
//         reFacCPLin: Record 39;
//     begin
//         //Cabecera
//         if NOT bolCabecera then begin
//             reFacCPCb.Reset();
//             reFacCPCb.INIT();
//             reFacCPCb."Document Type" := reFacCPCb."Document Type"::Invoice;
//             reFacCPCb."No." := '';
//             reFacCPCb.Insert(true);
//             reFacCPCb.Validate("Buy-from Vendor No.", pReRetencion."Nº Proveedor / Nº Cliente");
//             reFacCPCb.Validate("Currency Code", pReRetencion."Cód. divisa");
//             reFacCPCb."Perception Type" := pReRetencion."Tipo de Perceptor";
//             reFacCPCb."Perception Key" := pReRetencion."Clave de Percepción";
//             reFacCPCb."Vendor Invoice No." := pReRetencion."Nº documento";
//             reFacCPCb.Validate("Shortcut Dimension 2 Code", "Mov. retención"."Nº Proyecto");
//             reFacCPCb.Modify();
//             bolCabecera := true;
//             NumDocumento := reFacCPCb."No.";
//         end;
//         reFacCPLin.Reset();
//         reFacCPLin.INIT();
//         reFacCPLin."Document Type" := reFacCPLin."Document Type"::Invoice;
//         reFacCPLin."Document No." := NumDocumento;
//         numLinea += 10000;
//         reFacCPLin."Line No." := numLinea;
//         reFacCPLin.Insert(true);
//         reFacCPLin.Type := reFacCPLin.Type::"G/L Account";
//         reFacCPLin.Validate("No.", pReRetencion."Cta. retención");
//         reFacCPLin.Validate(Quantity, 1);
//         reFacCPLin.Validate("Direct Unit Cost", -pReRetencion."Importe a Liquidar");
//         reFacCPLin."Perception Type" := pReRetencion."Tipo de Perceptor";
//         reFacCPLin."Perception key" := pReRetencion."Clave de Percepción";
//         reFacCPLin."Retention Line" := true;
//         reFacCPLin.Validate("Retention Entry", pReRetencion."Entry No.");
//         reFacCPLin.Validate("Shortcut Dimension 2 Code", "Mov. retención"."Nº Proyecto");
//         reFacCPLin.Modify();
//     end;

//     procedure retencionFactura(pReRetencion: Record "EXC Retention Tax registers");
//     begin
//         if pReRetencion."Cust/Vend" = pReRetencion."Cust/Vend"::Cliente then
//             CreaFacturaVT(pReRetencion)
//         else
//             CreaFacturaCP(pReRetencion);
//     end;

//     procedure retencionSinFactura(pReRetencion: Record "EXC Retention Tax registers");
//     begin
//         UltLinea();
//         if pReRetencion."Cust/Vend" = pReRetencion."Cust/Vend"::Proveedor then
//             TipoFactura := DevuelveTipoDoc(pReRetencion."Nº documento", true)
//         else
//             TipoFactura := DevuelveTipoDoc(pReRetencion."Nº documento", false);
//         NLin := NLin + 10000;
//         LinDiario.INIT();
//         LinDiario."Journal Template Name" := ConfContabilidad."Retention Journal Template";
//         LinDiario."Journal Batch Name" := ConfContabilidad."Retention Aux. Batch";
//         LinDiario."Line No." := NLin;
//         LinDiario."Posting Date" := WorkDate();
//         CASE Tipo OF
//             Tipo::"Cliente/Proveedor":
//                 begin
//                     if pReRetencion."Cust/Vend" = pReRetencion."Cust/Vend"::Cliente then LinDiario."Account Type" := LinDiario."Account Type"::Customer;
//                     if pReRetencion."Cust/Vend" = pReRetencion."Cust/Vend"::Proveedor then LinDiario."Account Type" := LinDiario."Account Type"::Vendor;
//                     LinDiario.Validate("Account No.", pReRetencion."Nº Proveedor / Nº Cliente");
//                     LinDiario.Validate("Shortcut Dimension 2 Code", "Mov. retención"."Nº Proyecto");
//                 end;
//             Tipo::Banco:
//                 begin
//                     LinDiario."Account Type" := LinDiario."Account Type"::"Bank Account";
//                     LinDiario.Validate("Account No.", Cuenta);
//                 end;
//             Tipo::Cuenta:
//                 begin
//                     LinDiario."Account Type" := LinDiario."Account Type"::"G/L Account";
//                     LinDiario.Validate("Account No.", Cuenta);
//                 end
//         end;
//         if VEfecto then LinDiario."Document Type" := LinDiario."Document Type"::Bill;
//         LinDiario."Document No." := pReRetencion."Nº documento";
//         if VEfecto then begin
//             if UltEfectoMismoDoc <> '' then begin
//                 UltEfectoMismoDoc := INCSTR(UltEfectoMismoDoc);
//                 LinDiario."Bill No." := UltEfectoMismoDoc;
//             end
//             else
//                 LinDiario."Bill No." := BuscaUltimoEfecto(pReRetencion."Nº documento", pReRetencion."Cust/Vend", pReRetencion."Nº Proveedor / Nº Cliente");
//             LinDiario.Validate("Payment Method Code", FormaPago());
//         end;
//         if pReRetencion."Cust/Vend" = pReRetencion."Cust/Vend"::Proveedor then begin
//             if TipoFactura then
//                 LinDiario.Validate("Credit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"))
//             else
//                 LinDiario.Validate("Debit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"));
//         end
//         else begin
//             if TipoFactura then
//                 LinDiario.Validate("Debit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"))
//             else
//                 LinDiario.Validate("Credit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"))
//         end;
//         LinDiario.Validate(LinDiario."VAT Posting", 0);
//         LinDiario.Validate("Gen. Bus. Posting Group", '');
//         LinDiario.Validate("Gen. Prod. Posting Group", '');
//         LinDiario."Perception Type" := pReRetencion."Tipo de Perceptor";
//         LinDiario."Perception Key" := pReRetencion."Clave de Percepción";
//         LinDiario."Country/Region Code" := pReRetencion.País;
//         //traspaso las 4 dimensiones
//         LinDiario.Validate("Shortcut Dimension 1 Code", pReRetencion."Shortcut Dimension 1 Code");
//         LinDiario.Validate("Shortcut Dimension 2 Code", pReRetencion."Shortcut Dimension 2 Code");
//         //traspaso las 4 dimensiones
//         //-001
//         //LinDiario."Exported to Payment File" := true;
//         LinDiario."Exported to Payment File" := false; //Al generar el diario, obliga a que sea false
//         //+001
//         LinDiario.Insert();
//         // 2º línea.
//         NLin := NLin + 10000;
//         LinDiario.INIT();
//         LinDiario."Journal Template Name" := ConfContabilidad."Retention Journal Template";
//         LinDiario."Journal Batch Name" := ConfContabilidad."Retention Aux. Batch";
//         LinDiario."Line No." := NLin;
//         //LinDiario.Insert(true);
//         LinDiario."Account Type" := LinDiario."Account Type"::"G/L Account";
//         LinDiario.Validate("Account No.", pReRetencion."Cta. retención");
//         LinDiario."Posting Date" := WorkDate();
//         LinDiario."Document No." := pReRetencion."Nº documento";
//         //LinDiario.Validate("Currency Code", "Mov. retención"."Cód. divisa");
//         if pReRetencion."Cust/Vend" = pReRetencion."Cust/Vend"::Proveedor then begin
//             if TipoFactura then
//                 LinDiario.Validate("Debit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"))
//             else
//                 LinDiario.Validate("Credit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"));
//         end
//         else begin
//             if TipoFactura then
//                 LinDiario.Validate("Credit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"))
//             else
//                 LinDiario.Validate("Debit Amount", ABS(pReRetencion."Importe a Liquidar (DL)"))
//         end;
//         LinDiario.Validate("VAT Posting", 0);
//         LinDiario.Validate("Gen. Posting Type", 0);
//         LinDiario.Validate("Gen. Bus. Posting Group", '');
//         LinDiario.Validate("Gen. Prod. Posting Group", '');
//         LinDiario."Retention Document No." := pReRetencion."Nº documento";
//         LinDiario."Liq. Retention" := true;
//         LinDiario."Perception Type" := pReRetencion."Tipo de Perceptor";
//         LinDiario."Perception Key" := pReRetencion."Clave de Percepción";
//         LinDiario.Validate("Retention Entry", pReRetencion."Entry No.");
//         //TecnoRet1
//         LinDiario.Invoice := LinDiario.Invoice::"Sin factura";
//         LinDiario.Bill := VEfecto;
//         LinDiario."Settlement type" := Tipo;
//         //FIN TecnoRet1
//         LinDiario."Country/Region Code" := pReRetencion.País;
//         //TecnoRet3
//         LinDiario."Nº mov. retención" := pReRetencion."Entry No.";
//         //FIN TecnoRet3
//         //traspaso las 4 dimensiones
//         LinDiario.Validate("Shortcut Dimension 1 Code", pReRetencion."Shortcut Dimension 1 Code");
//         LinDiario.Validate("Shortcut Dimension 2 Code", pReRetencion."Shortcut Dimension 2 Code");
//         //traspaso las 4 dimensiones
//         //-001
//         //LinDiario."Exported to Payment File" := true;
//         LinDiario."Exported to Payment File" := false; //Al generar el diario, obliga a que sea false
//         //+001
//         LinDiario.Insert();
//     end;

//     procedure DevuelveDocumento(VAR pChDocumento: Code[20]);
//     begin
//         pChDocumento := NumDocumento;
//     end;

//     procedure Continuar(VAR pBolContinuar: Boolean);
//     begin
//         pBolContinuar := bolContinuar;
//     end;

//     procedure BuscaUltimoEfecto(NumDoc: Code[20]; TipoMov: option "Cliente","Proveedor"; CLiProv: Code[20]) NumEfecto: Code[20];
//     VAR
//         MovCliente: Record 21;
//         MovProveedor: Record 25;
//     begin
//         NumEfecto := '1';
//         if TipoMov = TipoMov::Cliente then begin
//             MovCliente.Reset();
//             MovCliente.Setcurrentkey("Document No.", "Document Type", "Customer No.");
//             MovCliente.Setrange("Document No.", NumDoc);
//             MovCliente.Setrange("Document Type", MovProveedor."Document Type"::Bill);
//             MovCliente.Setrange("Customer No.", CLiProv);
//             if MovCliente.Find('+') then NumEfecto := INCSTR(MovCliente."Bill No.");
//         end
//         else begin
//             MovProveedor.Reset();
//             MovProveedor.Setcurrentkey("Vendor No.", "Document No.");
//             MovProveedor.Setrange("Vendor No.", CLiProv);
//             MovProveedor.Setrange("Document No.", NumDoc);
//             MovProveedor.Setrange("Document Type", MovProveedor."Document Type"::Bill);
//             if MovProveedor.Find('+') then NumEfecto := INCSTR(MovProveedor."Bill No.");
//         end;
//         UltEfectoMismoDoc := NumEfecto;
//     end;

//     procedure DevuelveTipoDoc(NumDoc: Code[20]; Compra: Boolean) Factura: Boolean;
//     VAR
//         HistFactCompra: Record 122;
//         HistAbonCompra: Record 124;
//         HistFactVenta: Record 112;
//         HistAbonVenta: Record 114;
//     begin
//         if Compra then begin
//             if HistFactCompra.Get(NumDoc) then
//                 Factura := true
//             else if HistAbonCompra.Get(NumDoc) then Factura := false;
//         end
//         else begin
//             if HistFactVenta.Get(NumDoc) then
//                 Factura := true
//             else if HistAbonVenta.Get(NumDoc) then Factura := false;
//         end;
//     end;

//     procedure Realizaragrupacionporpais();
//     VAR
//         Companyinfol: Record 79;
//         Lindiariol: Record 81;
//         Imporespañal: Decimal;
//         Imporespañaliql: Decimal;
//         Imporotrosl: Decimal;
//         Imporotrosliql: Decimal;
//         Lindiarioinsertl: Record 81;
//         Liqretencionl: Record "EXC Aux. liq mov. retención";
//         Numlineal: Integer;
//         Text001l: Label 'Liquidación retención %1';
//         Text002l: Label 'Liquidación retención países extranjeros.';
//     begin
//         clear(Liqretencionl);
//         Liqretencionl.Reset();
//         Liqretencionl.Setrange("User Id.", USERID);
//         Liqretencionl.DeleteAll();
//         Imporespañal := 0;
//         Imporespañaliql := 0;
//         Imporotrosl := 0;
//         Imporotrosliql := 0;
//         Numlineal := 10000;
//         Companyinfol.Get();
//         Lindiariol.Reset();
//         Lindiariol.Setrange("Journal Template Name", ConfContabilidad."Retention Journal Template");
//         Lindiariol.Setrange("Journal Batch Name", ConfContabilidad."Retention Aux. Batch");
//         Lindiariol.Setrange("Country/Region Code", Companyinfol."Country/Region Code");
//         Lindiariol.SETFILTER("Retention Entry", '<>%1', 0);
//         if Lindiariol.Find('-') then begin
//             repeat
//                 Imporespañal += Lindiariol.Amount;
//                 Liqretencionl."Journal Template Name" := ConfContabilidad."Retention Journal Template";
//                 Liqretencionl."Journal Batch Name" := ConfContabilidad."Retention Batch";
//                 Liqretencionl."Line No." := Numlineal;
//                 Liqretencionl."Deduction Entry" := Lindiariol."Retention Entry";
//                 Liqretencionl."Amount to Apply" := Lindiariol.Amount;
//                 Liqretencionl."Document No." := Lindiariol."Document No.";
//                 Liqretencionl."User Id." := USERID;
//                 if Liqretencionl.Insert() then;
//             until Lindiariol.Next() = 0;
//             Lindiarioinsertl.INIT();
//             Lindiarioinsertl.COPY(Lindiariol);
//             Lindiarioinsertl."Journal Batch Name" := ConfContabilidad."Retention Batch";
//             Lindiarioinsertl."Line No." := Numlineal;
//             Lindiarioinsertl.Insert(true);
//             Numlineal += 10000;
//             Lindiarioinsertl.Validate(Amount, Imporespañal);
//             Lindiarioinsertl."Document No." := Numdocumentov;
//             Lindiarioinsertl.Description := STRSUBSTNO(Text001l, Lindiarioinsertl."Country/Region Code");
//             //-001
//             Lindiarioinsertl."Exported to Payment File" := false;
//             Lindiarioinsertl.Modify(false);
//             //Lindiarioinsertl.Modify(true);
//             //+001
//         end;
//         Lindiariol.Setrange("Retention Entry");
//         Lindiariol.Setrange("Retention Entry", 0);
//         if Lindiariol.Find('-') then begin
//             repeat
//                 Imporespañaliql += Lindiariol.Amount;
//             until Lindiariol.Next() = 0;
//             Lindiarioinsertl.INIT();
//             Lindiarioinsertl.COPY(Lindiariol);
//             Lindiarioinsertl."Journal Batch Name" := ConfContabilidad."Retention Batch";
//             Lindiarioinsertl."Line No." := Numlineal;
//             Lindiarioinsertl.Insert(true);
//             Numlineal += 10000;
//             Lindiarioinsertl.Validate(Amount, Imporespañaliql);
//             Lindiarioinsertl."Document No." := Numdocumentov;
//             Lindiarioinsertl.Description := STRSUBSTNO(Text001l, Lindiarioinsertl."Country/Region Code");
//             //4 DIM
//             Lindiarioinsertl.Validate("Shortcut Dimension 1 Code", Lindiariol."Shortcut Dimension 1 Code");
//             Lindiarioinsertl.Validate("Shortcut Dimension 2 Code", Lindiariol."Shortcut Dimension 2 Code");
//             //4 DIM
//             //-001
//             Lindiarioinsertl."Exported to Payment File" := false;
//             Lindiarioinsertl.Modify(false);
//             //Lindiarioinsertl.Modify(true);
//             //+001
//         end;
//         Lindiariol.Setrange("Country/Region Code");
//         Lindiariol.SETFILTER("Country/Region Code", '<>%1', Companyinfol."Country/Region Code");
//         Lindiariol.Setrange("Retention Entry");
//         Lindiariol.SETFILTER("Retention Entry", '<>%1', 0);
//         if Lindiariol.Find('-') then begin
//             repeat
//                 Liqretencionl."Journal Template Name" := ConfContabilidad."Retention Journal Template";
//                 Liqretencionl."Journal Batch Name" := ConfContabilidad."Retention Batch";
//                 Liqretencionl."Line No." := Numlineal;
//                 Liqretencionl."Deduction Entry" := Lindiariol."Retention Entry";
//                 Liqretencionl."Amount to Apply" := Lindiariol.Amount;
//                 Liqretencionl."Document No." := Lindiariol."Document No.";
//                 Liqretencionl."User Id." := USERID;
//                 if Liqretencionl.Insert() then;
//                 Imporotrosl += Lindiariol.Amount;
//             until Lindiariol.Next() = 0;
//             Lindiarioinsertl.INIT();
//             Lindiarioinsertl.COPY(Lindiariol);
//             Lindiarioinsertl."Journal Batch Name" := ConfContabilidad."Retention Batch";
//             Lindiarioinsertl."Line No." := Numlineal;
//             Lindiarioinsertl.Insert(true);
//             Numlineal += 10000;
//             Lindiarioinsertl.Validate(Amount, Imporotrosl);
//             Lindiarioinsertl."Document No." := Numdocumentov;
//             Lindiarioinsertl.Description := STRSUBSTNO(Text002l);
//             //4 DIM
//             Lindiarioinsertl.Validate("Shortcut Dimension 1 Code", Lindiariol."Shortcut Dimension 1 Code");
//             Lindiarioinsertl.Validate("Shortcut Dimension 2 Code", Lindiariol."Shortcut Dimension 2 Code");
//             //4 DIM
//             //-001
//             Lindiarioinsertl."Exported to Payment File" := false;
//             Lindiarioinsertl.Modify(false);
//             //Lindiarioinsertl.Modify(true);
//             //+001
//         end;
//         Lindiariol.Setrange("Retention Entry");
//         Lindiariol.Setrange("Retention Entry", 0);
//         if Lindiariol.Find('-') then begin
//             repeat
//                 Imporotrosliql += Lindiariol.Amount;
//             until Lindiariol.Next() = 0;
//             Lindiarioinsertl.INIT();
//             Lindiarioinsertl.COPY(Lindiariol);
//             Lindiarioinsertl."Journal Batch Name" := ConfContabilidad."Retention Batch";
//             Lindiarioinsertl."Line No." := Numlineal;
//             Lindiarioinsertl.Insert(true);
//             Numlineal += 10000;
//             Lindiarioinsertl.Validate(Amount, Imporotrosliql);
//             Lindiarioinsertl."Document No." := Numdocumentov;
//             Lindiarioinsertl.Description := STRSUBSTNO(Text002l);
//             //4 DIM
//             Lindiarioinsertl.Validate("Shortcut Dimension 1 Code", Lindiariol."Shortcut Dimension 1 Code");
//             Lindiarioinsertl.Validate("Shortcut Dimension 2 Code", Lindiariol."Shortcut Dimension 2 Code");
//             //4 DIM
//             //-001
//             Lindiarioinsertl."Exported to Payment File" := false;
//             Lindiarioinsertl.Modify(false);
//             //Lindiarioinsertl.Modify(true);
//             //+001
//         end;
//         Lindiariol.Reset();
//         Lindiariol.Setrange("Journal Template Name", ConfContabilidad."Retention Journal Template");
//         Lindiariol.Setrange("Journal Batch Name", ConfContabilidad."Retention Aux. Batch");
//         if Lindiariol.FindFIRST() then Lindiariol.DeleteAll(true);
//     end;

//     procedure MostrarDiario(boolMuestra: Boolean);
//     begin
//         NoMuestraDiario := boolMuestra;
//     end;
// }
