// namespace Excelia.IRPF;
// using Microsoft.Finance.GeneralLedger.Journal;
// using Microsoft.Sales.Customer;
// using Microsoft.Foundation.Company;
// using Microsoft.Projects.Resources.Setup;
// using Microsoft.Projects.Resources.Resource;
// using Microsoft.Sales.History;
// using Microsoft.Purchases.History;
// using Microsoft.Finance.GeneralLedger.Ledger;
// using Microsoft.Finance.Currency;
// using Microsoft.Purchases.Vendor;
// using Microsoft.Foundation.Address;
// using Microsoft.Finance.GeneralLedger.Setup;
// codeunit 86302 "SVT Journal Events"
// {
//     trigger OnRun()
//     begin
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostGenJnlLine', '', true, true)]
//     local procedure OnBeforePostGenJnlLine(VAR GenJournalLine: Record "Gen. Journal Line")
//     begin
//         if (GenJournalLine."Retention Amount" <> 0) AND (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account") then Crearmovretención(GenJournalLine);
//     end;

//     procedure Crearmovretención(LiDiario: record "Gen. Journal Line")
//     var
//         GeneralLedgerSetup: record "General Ledger Setup";
//         MovRet1: record "EXC Retention Tax registers";
//         Customer: record Customer;
//         PostCode: record "Post Code";
//         Vendor: record Vendor;
//         Clavepercepcionl1: record "EXC Perception Keys (IRPF)";
//         Currency: record Currency;
//         CurrencyExchangeRate: record "Currency Exchange Rate";
//         CurrencyCode: code[10];
//         NoMovRet1: Integer;
//     begin
//         NoMovRet1 := TraerNoMovRetencion();
//         MovRet1."Entry No." := NoMovRet1 + 1;
//         MovRet1."Nº Proveedor / Nº Cliente" := LiDiario."Customer/Vendor No.";
//         if LiDiario."Cust/Vend" = LiDiario."Cust/Vend"::Customer then begin
//             if Customer.Get(LiDiario."Customer/Vendor No.") then
//                 MovRet1.Description := Customer.Name;
//             MovRet1."CIF/NIF" := Customer."VAT Registration No.";
//             MovRet1."C.P" := Customer."Post Code";
//             PostCode.Reset();
//             PostCode.Setrange(Code, Customer."Post Code");
//             if PostCode.FindFirst() then MovRet1."Código provincia" := PostCode."County Code";
//             MovRet1."Cód. divisa" := Customer."Currency Code";
//             CurrencyCode := Customer."Currency Code";
//             clear(PostCode);
//             PostCode.Reset();
//             if PostCode.Get(Customer."Post Code", Customer.City) then MovRet1."Código provincia" := PostCode."County Code";
//         end
//         else
//             if Vendor.Get(LiDiario."Customer/Vendor No.") then begin
//                 MovRet1.Description := Vendor.Name;
//                 MovRet1."CIF/NIF" := Vendor."VAT Registration No.";
//                 MovRet1."C.P" := Vendor."Post Code";
//                 PostCode.Reset();
//                 PostCode.Setrange(Code, Vendor."Post Code");
//                 if PostCode.FindFirst() then MovRet1."Código provincia" := PostCode."County Code";
//                 MovRet1."Cód. divisa" := Vendor."Currency Code";
//                 CurrencyCode := Vendor."Currency Code";
//                 clear(PostCode);
//                 PostCode.Reset();
//                 if PostCode.Get(Vendor."Post Code", Vendor.City) then MovRet1."Código provincia" := PostCode."County Code";

//             end;
//         MovRet1."Fecha registro" := LiDiario."Posting Date";
//         MovRet1."Nº documento" := LiDiario."Document No.";
//         MovRet1."Tipo Documento" := LiDiario."Document Type".AsInteger();
//         MovRet1."Importe factura iva incl." := LiDiario."VAT Amount";
//         MovRet1."Importe factura" := LiDiario."Invoice Amount";
//         MovRet1."Base retención" := LiDiario."Retention Base";
//         MovRet1."% retención" := LiDiario."Retention %";
//         MovRet1."Tipo de Perceptor" := LiDiario."Perception Type";
//         MovRet1."Clave de Percepción" := LiDiario."Perception Key";
//         MovRet1.Validate("Nº Proyecto", LiDiario."Job No.");
//         MovRet1."Nº asiento" := 0;
//         MovRet1."Cód. origen" := LiDiario."Source Code";
//         MovRet1."Año devengo" := DATE2DMY(MovRet1."Fecha registro", 3);
//         Clavepercepcionl1.Reset();
//         if Clavepercepcionl1.Get(LiDiario."Perception Key") then begin
//             MovRet1."Cta. retención" := Clavepercepcionl1."Retention Acc.""";
//             MovRet1."Clave IRPF" := Clavepercepcionl1."IRPF Key";
//             MovRet1."Subclave IRPF" := Clavepercepcionl1."IRPF SubKey";
//             MovRet1."Tipo percepción" := Clavepercepcionl1."Perception Type";
//             MovRet1."Cust/Vend" := Clavepercepcionl1."Cust/Vend";
//             MovRet1."Tipo Retención" := Clavepercepcionl1."Deduction Type";
//         end;
//         MovRet1."Importe retención" := CurrencyExchangeRate.ExchangeAmtLCYToFCY(WorkDate(), MovRet1."Cód. divisa", LiDiario."Importe retención", CurrencyExchangeRate.ExchangeRate(WorkDate, MovRet1."Cód. divisa"));
//         if Currency.Get(CurrencyCode) then MovRet1."Importe retención" := round(MovRet1."Importe retención", Currency."Amount Rounding Precision");
//         GeneralLedgerSetup.Get();
//         MovRet1."Base retencion (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Base retención", CurrencyExchangeRate.ExchangeRate(WorkDate, MovRet1."Cód. divisa"));
//         MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//         MovRet1."Importe retención (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe retención", CurrencyExchangeRate.ExchangeRate(WorkDate, MovRet1."Cód. divisa"));
//         MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//         MovRet1."Importe Factura (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", CurrencyExchangeRate.ExchangeRate(WorkDate, MovRet1."Cód. divisa"));
//         MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//         MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//         MovRet1."Importe Pendiente (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe Pendiente", CurrencyExchangeRate.ExchangeRate(WorkDate, MovRet1."Cód. divisa"));
//         MovRet1."Importe Pendiente (DL)" := round(MovRet1."Importe Pendiente (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//         MovRet1.Pendiente := true;
//         MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//         MovRet1."Importe a Liquidar (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe a Liquidar", CurrencyExchangeRate.ExchangeRate(WorkDate, MovRet1."Cód. divisa"));
//         MovRet1."Importe a Liquidar (DL)" := round(MovRet1."Importe a Liquidar (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//         MovRet1."Shortcut Dimension 1 Code" := LiDiario."Shortcut Dimension 1 Code";
//         MovRet1."Shortcut Dimension 2 Code" := LiDiario."Shortcut Dimension 2 Code";
//         MovRet1.Insert();
//     end;

//     procedure TraerNoMovRetencion(): integer
//     var
//         MovRet: record "EXC Retention Tax registers";
//     begin
//         MovRet.LockTable();
//         MovRet.Reset();
//         if MovRet.Find('+') then
//             exit(MovRet."Entry No.")
//         else
//             exit(0);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInsertGlobalGLEntry', '', false, false)]
//     local procedure ActualizarCampoNoAsiento(var GLEntry: Record "G/L Entry")
//     begin
//         if (GLEntry."Document Type" IN [GLEntry."Document Type"::Invoice, GLEntry."Document Type"::"Credit Memo", GLEntry."Document Type"::" "]) AND (GLEntry.Reversed = false) then //++ OT2-051963
//             ActualizaAsientoRetención(GLEntry."Document No.", GLEntry."Transaction No.", GLEntry."Document Type".AsInteger(), //-- OT2-051963
//   GLEntry."Posting Date");
//     end;

//     procedure ActualizaAsientoRetención(AuxNumDocumento: Code[20]; AuxNumAsiento: Integer; AuxTipo: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo","Reminder","Refund"; AuxFecha: Date)
//     var
//         AuxMovRetención: record "EXC Retention Tax registers";
//         AuxMovConta: record "G/L Entry";
//         NumInicial: Integer;
//         NumFinal: integer;
//     begin
//         clear(NumInicial);
//         clear(NumFinal);
//         AuxMovConta.Reset();
//         AuxMovConta.Setcurrentkey("Document No.", "Posting Date");
//         AuxMovConta.SETFILTER("Document No.", AuxNumDocumento);
//         AuxMovConta.Setrange("Posting Date", AuxFecha);
//         if AuxMovConta.FindFIRST() then begin
//             NumInicial := AuxMovConta."Entry No.";
//             if AuxMovConta.FindLast() then NumFinal := AuxMovConta."Entry No.";
//         end;
//         AuxMovRetención.Reset();
//         AuxMovRetención.Setcurrentkey("Nº documento", "Tipo Documento", Revertido, "Fecha registro");
//         AuxMovRetención.SETFILTER("Nº documento", AuxNumDocumento);
//         AuxMovRetención.Setrange("Tipo Documento", AuxTipo);
//         AuxMovRetención.Setrange(Revertido, false);
//         AuxMovRetención.Setrange("Fecha registro", AuxFecha);
//         AuxMovRetención.Setrange("Nº asiento", 0);
//         if AuxMovRetención.Findset() then
//             repeat
//                 AuxMovRetención."Nº asiento" := AuxNumAsiento;
//                 AuxMovRetención."Desde Nº Mov. contabilidad" := NumInicial;
//                 AuxMovRetención."Hasta Nº Mov. contabilidad" := NumFinal;
//                 AuxMovRetención.Modify();
//             until AuxMovRetención.Next() = 0;
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
//     local procedure OnAfterInitGLEntryIRPF(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
//     var
//         Auxliqretencionl: record "EXC Aux. liq mov. retención";
//         GlobalRETGLEntry: record "G/L Entry";
//         GlobalRETGenJnlLine: record "Gen. Journal Line";
//     begin
//         if (GenJournalLine."Liq. retención") AND (GLEntry."Source Type" = GLEntry."Source Type"::" ") then begin
//             clear(Auxliqretencionl);
//             Auxliqretencionl.Reset();
//             Auxliqretencionl.Setrange("Journal Template Name", GenJournalLine."Journal Template Name");
//             Auxliqretencionl.Setrange("Journal Batch Name", GenJournalLine."Journal Batch Name");
//             Auxliqretencionl.Setrange("Line No.", GenJournalLine."Line No.");
//             if Auxliqretencionl.FindFirst() then
//                 repeat
//                     GlobalRETGLEntry := GLEntry;
//                     GlobalRETGenJnlLine := GenJournalLine;

//                     LiqRetencion(Auxliqretencionl."Document No.", Auxliqretencionl."Deduction Entry", Auxliqretencionl."Amount to Apply", GlobalRETGenJnlLine, GlobalRETGLEntry);
//                     Auxliqretencionl.Delete();
//                 until Auxliqretencionl.Next() = 0;
//         end;

//     end;

//     procedure LiqRetencion(VAR Ndocuemnto: Code[20]; NumMov: Integer; Importep: Decimal; GlobalRETGenJnlLine: record "Gen. Journal Line"; GlobalRETGLEntry: record "G/L Entry")
//     var
//         HistFactCompra: Record "Purch. Inv. Header";
//         HistAbonCompra: Record "Purch. Cr. Memo Hdr.";
//         HistFactVenta: Record "Sales Invoice Header";
//         HistAbonVenta: Record "Sales Cr.Memo Header";
//         MovRetencion2: record "EXC Retention Tax registers";
//         MovRetencion3: record "EXC Retention Tax registers";
//         MovRetencion4: record "EXC Retention Tax registers";
//         CurrExchRate: record "Currency Exchange Rate";
//         VNumMovReten: integer;
//         LastDocNo: code[20];
//         Abono: Boolean;
//     begin
//         LastDocNo := GlobalRETGLEntry."Document No.";
//         MovRetencion2.LockTable();
//         MovRetencion2.Reset();
//         if MovRetencion2.Find('+') then
//             VNumMovReten := MovRetencion2."Entry No." + 1;

//         MovRetencion3.Reset();
//         MovRetencion3.Setrange(MovRetencion3."Nº documento", Ndocuemnto);
//         if NumMov <> 0 then MovRetencion3.Setrange("Entry No.", NumMov);
//         if MovRetencion3.Find('-') then begin
//             if MovRetencion3."Cust/Vend" = MovRetencion3."Cust/Vend"::Cliente then begin
//                 if NOT HistFactVenta.Get(Ndocuemnto) then if HistAbonVenta.Get(Ndocuemnto) then Abono := true;
//             end
//             else
//                 if NOT HistFactCompra.Get(Ndocuemnto) then if HistAbonCompra.Get(Ndocuemnto) then Abono := true;

//             if MovRetencion3."Importe Pendiente" < 0 then
//                 MovRetencion3."Importe Pendiente (DL)" := MovRetencion3."Importe Pendiente (DL)" + ABS(Importep)
//             else
//                 MovRetencion3."Importe Pendiente (DL)" := MovRetencion3."Importe Pendiente (DL)" - ABS(Importep);
//             if MovRetencion3."Importe Pendiente (DL)" = 0 then begin
//                 MovRetencion3.Pendiente := false;
//                 MovRetencion3."Importe Pendiente" := 0;
//             end
//             else
//                 MovRetencion3."Importe Pendiente" := CurrExchRate.ExchangeAmtLCYToFCY(WorkDate, MovRetencion3."Cód. divisa", MovRetencion3."Importe Pendiente (DL)", CurrExchRate.ExchangeRate(WorkDate, MovRetencion3."Cód. divisa"));

//             MovRetencion3."Importe a Liquidar" := MovRetencion3."Importe Pendiente";
//             MovRetencion3."Importe a Liquidar (DL)" := MovRetencion3."Importe Pendiente (DL)";
//             //++OT2-004391 - 12.09.12 - MBG
//             MovRetencion3."Liquidado por Movimiento" := FORMAT(VNumMovReten);
//             MovRetencion3.Modify();
//             //--OT2-004391 - 12.09.12 - MBG
//             MovRetencion4.Reset();
//             MovRetencion4 := MovRetencion3;
//             //TECNOCOM - EFS - 201112 - Llevo el Nº de documento con el que se haya registrado el asiento contable
//             MovRetencion4."Nº documento" := LastDocNo;
//             MovRetencion4."Entry No." := VNumMovReten;
//             MovRetencion4."Tipo Documento" := MovRetencion4."Tipo Documento"::" ";
//             MovRetencion4.Description := 'Liq. Retención ' + MovRetencion3."Nº documento";
//             MovRetencion4."Fecha registro" := GlobalRETGLEntry."Posting Date";
//             MovRetencion4."Importe factura iva incl." := 0;
//             MovRetencion4."Base retención" := 0;
//             MovRetencion4."% retención" := 0;
//             MovRetencion4."Nº asiento" := 0;
//             MovRetencion4.Revertido := false;
//             MovRetencion4."Revertido por el movimiento nº" := 0;
//             MovRetencion4."Nº movimiento revertido" := 0;
//             if Abono then begin
//                 if MovRetencion3."Cust/Vend" = MovRetencion3."Cust/Vend"::Cliente then
//                     MovRetencion4."Importe retención (DL)" := ABS(Importep)
//                 else
//                     MovRetencion4."Importe retención (DL)" := -ABS(Importep);
//             end
//             else
//                 if MovRetencion3."Cust/Vend" = MovRetencion3."Cust/Vend"::Cliente then
//                     MovRetencion4."Importe retención (DL)" := -ABS(Importep)
//                 else
//                     MovRetencion4."Importe retención (DL)" := ABS(Importep);

//             MovRetencion4."Cód. divisa" := MovRetencion3."Cód. divisa";
//             MovRetencion4."Importe retención" := CurrExchRate.ExchangeAmtLCYToFCY(WorkDate(), MovRetencion4."Cód. divisa", MovRetencion4."Importe retención (DL)", CurrExchRate.ExchangeRate(WorkDate, MovRetencion4."Cód. divisa"));
//             MovRetencion4."Importe Pendiente" := 0;
//             MovRetencion4."Importe Pendiente (DL)" := 0;
//             MovRetencion4."Liquidado por Movimiento" := FORMAT(MovRetencion3."Entry No.");
//             MovRetencion4."Importe a Liquidar" := 0;
//             MovRetencion4."Importe a Liquidar (DL)" := 0;
//             MovRetencion4.Pendiente := false;
//             MovRetencion4.Factura := GlobalRETGenJnlLine.Invoice;
//             MovRetencion4.Efecto := GlobalRETGenJnlLine.Bill;
//             MovRetencion4."Tipo Liquidacion" := GlobalRETGenJnlLine."Tipo Liquidacion";
//             MovRetencion4."Liquidado por Movimiento" := FORMAT(MovRetencion3."Entry No.");
//             MovRetencion4."Shortcut Dimension 1 Code" := MovRetencion3."Shortcut Dimension 1 Code";
//             MovRetencion4."Shortcut Dimension 2 Code" := MovRetencion3."Shortcut Dimension 2 Code";
//             MovRetencion4."Shortcut Dimension 3 Code" := MovRetencion3."Shortcut Dimension 3 Code";
//             MovRetencion4."Shortcut Dimension 4 Code" := MovRetencion3."Shortcut Dimension 4 Code";
//             MovRetencion4.Insert();
//         end;
//     end;

//     procedure CrearmovretenciónIRPF(NoMov1: Integer; NoProv1: Code[20]; Descrip1: Text[50]; CifNif1: Text[20]; FEmiDoc1: Date; FReg1: Date; NoDoc1: Code[20]; ImpFactura1: Decimal; BaseRet1: Decimal; "%Ret1": Decimal; TipoPer1: Code[10]; ClavePer1: Code[10]; ImpRet1: Decimal; ImpFacSinIva: Decimal; CP1: Code[10]; CodOrigen1: Code[10]; CodDivisa1: Code[10]; AuxTipo: option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund)
//     var
//         MovRet1: Record "EXC Retention Tax registers";
//         Regdivisa1: Record Currency;
//         Confrecursos1: Record "Resources Setup";
//         Clavepercepcionl1: Record "EXC Perception Keys (IRPF)";
//         CPl1: Record "Post Code";
//         Proveedorl1: Record Vendor;
//         Recursol1: Record Resource;
//         Hisfaccompral: Record "Purch. Inv. Header";
//         Hisabonocompral: Record "Purch. Cr. Memo Hdr.";
//         FactCompra: Record "Purch. Inv. Header";
//         AbonoCompra: Record "Purch. Cr. Memo Hdr.";
//         SalesInvoiceHeaderLocal: Record "Sales Invoice Header";
//         SalesCrMemoHeaderLocal: Record "Sales Cr.Memo Header";
//         GLSetup: record "General Ledger Setup";
//         CurrExchRate: record "Currency Exchange Rate";
//         NextTransactionNo: integer;
//         Proyecto: code[20];
//     begin
//         Confrecursos1.Get();
//         MovRet1."Entry No." := NoMov1 + 1;
//         MovRet1."Nº Proveedor / Nº Cliente" := NoProv1;
//         MovRet1.Description := Descrip1;
//         MovRet1."CIF/NIF" := CifNif1;
//         MovRet1."Fecha emisión documento" := FEmiDoc1;
//         MovRet1."Fecha registro" := FReg1;
//         MovRet1."Nº documento" := NoDoc1;
//         MovRet1."Tipo Documento" := AuxTipo;
//         MovRet1."Importe factura iva incl." := ImpFactura1;
//         MovRet1."Importe factura" := ImpFacSinIva;
//         MovRet1."Base retención" := ABS(BaseRet1);
//         MovRet1."% retención" := "%Ret1";
//         MovRet1."Tipo de Perceptor" := TipoPer1;
//         MovRet1."Clave de Percepción" := ClavePer1;
//         MovRet1."C.P" := CP1;
//         MovRet1."Cód. divisa" := CodDivisa1;
//         MovRet1.Pendiente := true;
//         MovRet1.Validate("Nº Proyecto", Proyecto);
//         MovRet1."Nº asiento" := NextTransactionNo;
//         MovRet1."Cód. origen" := CodOrigen1;
//         Proveedorl1.Reset();
//         Recursol1.Reset();
//         if Proveedorl1.Get(NoProv1) then begin
//             MovRet1."Nombre 1" := Proveedorl1.Name;
//             MovRet1."Nombre 2/Apellidos" := Proveedorl1."Name 2";
//         end
//         else if Recursol1.Get(NoProv1) then begin
//             MovRet1."Nombre 1" := Recursol1.Name;
//             MovRet1."Nombre 2/Apellidos" := Recursol1."Name 2";
//         end;
//         CPl1.Reset();
//         if CPl1.Get(CP1, Proveedorl1.City) then begin
//             MovRet1."C.P" := CP1;
//             //MovRet1."Código provincia" := CPl1.County;
//             MovRet1."Código provincia" := CPl1."County Code";
//         end;
//         MovRet1."Año devengo" := DATE2DMY(MovRet1."Fecha registro", 3);
//         Clavepercepcionl1.Reset;
//         if Clavepercepcionl1.Get(ClavePer1) then begin
//             MovRet1."Clave de Percepción" := ClavePer1;
//             MovRet1."Cta. retención" := Clavepercepcionl1."Retention Acc.""";
//             MovRet1."Clave IRPF" := Clavepercepcionl1."IRPF Key";
//             MovRet1."Subclave IRPF" := Clavepercepcionl1."IRPF SubKey";
//             MovRet1."Tipo percepción" := Clavepercepcionl1."Perception Type";
//             MovRet1."Cust/Vend" := Clavepercepcionl1."Cust/Vend";
//             MovRet1."Tipo Retención" := Clavepercepcionl1."Deduction Type";
//         end;
//         MovRet1."Importe retención" := ImpRet1;
//         if Regdivisa1.Get(CodDivisa1) then MovRet1."Importe retención" := round(MovRet1."Importe retención", Regdivisa1."Amount Rounding Precision");
//         //++MBG TEMPORAL
//         if AuxTipo = AuxTipo::Invoice then begin
//             //--MBG TEMPORAL
//             if Clavepercepcionl1."Cust/Vend" = Clavepercepcionl1."Cust/Vend"::Proveedor then begin
//                 GLSetup.Get;
//                 FactCompra.Reset;
//                 FactCompra.Get(NoDoc1);
//                 MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, MovRet1."Cód. divisa", MovRet1."Base retención", FactCompra."Currency Factor");
//                 MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
//                 MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, MovRet1."Cód. divisa", MovRet1."Importe retención", FactCompra."Currency Factor");
//                 MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
//                 MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", FactCompra."Currency Factor");
//                 MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
//                 MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//                 MovRet1.Pendiente := true;
//                 MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//                 MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
//                 MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
//                 //++MBG TEMPORAL
//                 //TECNOCOM TecnoRet - EFS - 070912
//                 MovRet1."Shortcut Dimension 1 Code" := FactCompra."Shortcut Dimension 1 Code";
//                 MovRet1."Shortcut Dimension 2 Code" := FactCompra."Shortcut Dimension 2 Code";
//                 //FIN TECNOCOM TecnoRet - EFS - 070912
//                 //TECNOCOM - GFM - 151216 - OT2-032966
//                 /*clear(PurchInvLineLocal);
//                     PurchInvLineLocal.Reset;
//                     PurchInvLineLocal.Setrange("Document No.", NoDoc1);
//                     PurchInvLineLocal.Setrange(Type, PurchInvLineLocal.Type::"G/L Account");
//                     if PurchInvLineLocal.FindFIRST then begin
//                         MovRet1."Ref. Catastral" := PurchInvLineLocal."Ref. Catastral";
//                     end;*/
//                 //FIN TECNOCOM - GFM - 151216 - OT2-032966
//             end
//             else begin
//                 GLSetup.Get;
//                 SalesInvoiceHeaderLocal.Reset;
//                 SalesInvoiceHeaderLocal.Get(NoDoc1);
//                 MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, MovRet1."Cód. divisa", MovRet1."Base retención", SalesInvoiceHeaderLocal."Currency Factor");
//                 MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
//                 MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, MovRet1."Cód. divisa", MovRet1."Importe retención", SalesInvoiceHeaderLocal."Currency Factor");
//                 MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
//                 MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", SalesInvoiceHeaderLocal."Currency Factor");
//                 MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
//                 MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//                 MovRet1.Pendiente := true;
//                 MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//                 MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
//                 MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
//                 MovRet1."Shortcut Dimension 1 Code" := SalesInvoiceHeaderLocal."Shortcut Dimension 1 Code";
//                 MovRet1."Shortcut Dimension 2 Code" := SalesInvoiceHeaderLocal."Shortcut Dimension 2 Code";
//             end;
//         end
//         else begin
//             if AuxTipo = AuxTipo::"Credit Memo" then begin
//                 if Clavepercepcionl1."Cust/Vend" = Clavepercepcionl1."Cust/Vend"::Proveedor then begin
//                     GLSetup.Get;
//                     AbonoCompra.Reset;
//                     AbonoCompra.Get(NoDoc1);
//                     MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, MovRet1."Cód. divisa", MovRet1."Base retención", AbonoCompra."Currency Factor");
//                     MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
//                     MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, MovRet1."Cód. divisa", MovRet1."Importe retención", AbonoCompra."Currency Factor");
//                     MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
//                     MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", AbonoCompra."Currency Factor");
//                     MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
//                     MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//                     MovRet1.Pendiente := true;
//                     MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//                     MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
//                     MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
//                     //TECNOCOM TecnoRet - EFS - 070912
//                     MovRet1."Shortcut Dimension 1 Code" := AbonoCompra."Shortcut Dimension 1 Code";
//                     MovRet1."Shortcut Dimension 2 Code" := AbonoCompra."Shortcut Dimension 2 Code";
//                     //FIN TECNOCOM TecnoRet - EFS - 070912
//                     //TECNOCOM - GFM - 151216 - OT2-032966
//                     /*clear(PurchCrMemoLineLocal);
//                         PurchCrMemoLineLocal.Reset;
//                         PurchCrMemoLineLocal.Setrange("Document No.", NoDoc1);
//                         PurchCrMemoLineLocal.Setrange(Type, PurchCrMemoLineLocal.Type::"G/L Account");
//                         if PurchCrMemoLineLocal.FindFIRST then begin
//                             MovRet1."Ref. Catastral" := PurchCrMemoLineLocal."Ref. Catastral";
//                         end;*/
//                     //FIN TECNOCOM - GFM - 151216 - OT2-032966
//                 end
//                 else begin
//                     GLSetup.Get;
//                     SalesCrMemoHeaderLocal.Reset;
//                     SalesCrMemoHeaderLocal.Get(NoDoc1);
//                     MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, MovRet1."Cód. divisa", MovRet1."Base retención", SalesCrMemoHeaderLocal."Currency Factor");
//                     MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
//                     MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, MovRet1."Cód. divisa", MovRet1."Importe retención", SalesCrMemoHeaderLocal."Currency Factor");
//                     MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
//                     MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", SalesCrMemoHeaderLocal."Currency Factor");
//                     MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
//                     MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//                     MovRet1.Pendiente := true;
//                     MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//                     MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
//                     MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
//                     MovRet1."Shortcut Dimension 1 Code" := SalesCrMemoHeaderLocal."Shortcut Dimension 1 Code";
//                     MovRet1."Shortcut Dimension 2 Code" := SalesCrMemoHeaderLocal."Shortcut Dimension 2 Code";
//                 end;
//             end;
//         end;
//         if AuxTipo = AuxTipo::"Credit Memo" then begin
//             MovRet1."Base retencion (DL)" := -MovRet1."Base retencion (DL)";
//             MovRet1."Base retención" := -MovRet1."Base retención";
//         end;
//         //--MBG TEMPORAL
//         clear(Hisfaccompral);
//         Hisfaccompral.Reset;
//         if Hisfaccompral.Get(NoDoc1) then begin
//             MovRet1.País := Hisfaccompral."Buy-from Country/Region Code";
//             //TECNOCOM DSL - Insertamos el código Inmueble en el movimiento de retención
//             //Falta Subir Desarrollo AMS
//             /*PuchInvLineLocal.Reset;
//                       PuchInvLineLocal.Setrange("Document No.", NoDoc1);
//                       if PuchInvLineLocal.Findset then
//                           repeat
//                               if PuchInvLineLocal."Ref. Catastral" <> '' then
//                                   "Cod Inmueble" := PuchInvLineLocal."Ref. Catastral";
//                           until PuchInvLineLocal.Next = 0;*/
//             //FIN TECNOCOM DSL
//         end
//         else begin
//             clear(Hisabonocompral);
//             Hisabonocompral.Reset;
//             if Hisabonocompral.Get(NoDoc1) then MovRet1.País := Hisabonocompral."Buy-from Country/Region Code";
//         end;
//         clear(SalesInvoiceHeaderLocal);
//         SalesInvoiceHeaderLocal.Reset;
//         if SalesInvoiceHeaderLocal.Get(NoDoc1) then // TEC1 (15/04/14) (Est  asignando el Código Cliente en lugar de Código País)
//             //País:= SalesInvoiceHeaderLocal."Sell-to Customer No."
//             MovRet1.País := SalesInvoiceHeaderLocal."Sell-to Country/Region Code"
//         // TEC1 (15/04/14) (Est  asignando el Código Cliente en lugar de Código País)
//         else begin
//             clear(SalesCrMemoHeaderLocal);
//             SalesCrMemoHeaderLocal.Reset;
//             if SalesCrMemoHeaderLocal.Get(NoDoc1) then // TEC1 (15/04/14) (Est  asignando el Código Cliente en lugar de Código País)
//                 //País:= SalesCrMemoHeaderLocal."Sell-to Customer No.";
//                 MovRet1.País := SalesCrMemoHeaderLocal."Sell-to Country/Region Code";
//             // TEC1 (15/04/14) (Est  asignando el Código Cliente en lugar de Código País)
//         end;
//         MovRet1.Insert;
//         // end;
//         //-- OT2-051963
//     end;

//     procedure CrearRetencionIRPF(Tipo: option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,Bill; Num: Code[20]; Imp: Decimal; SourcCode: Code[10]; Tipopercep: Code[10]; Clavepercep: Code[10]; BaseRet: Decimal; Proy: Code[20]; Desc: Text[50]; DocDate: Date; PostDate: Date; ImpFactura: Decimal; CP: Code[20]; CurrencyCode: Code[10]; PorcRet: Decimal; ProvCLi: Code[20]; CifNif: Text[20]; ImpFacturaSinIva: Decimal)
//     var
//         InfoEmp1: Record "Company Information";
//         ConfConta: Record "General Ledger Setup";
//         FacCompra1: Record "Purch. Inv. Header";
//         LinFacCompra1: Record "Purch. Inv. Line";
//         AboCompra1: Record "Purch. Cr. Memo Hdr.";
//         LinAboCompra1: Record "Purch. Cr. Memo Line";
//         GLSetup: record "General Ledger Setup";
//         NoMovRet1: Integer;
//         Proyecto: code[20];
//         NMovRentencion: integer;
//     begin
//         //CrearRetencion
//         //Evaluamos si la línea proviene de una factura o directamente de un diario.
//         CASE Tipo OF //Diario.
//             Tipo::" ":
//                 begin
//                     //Tenemos que evaluar si la línea es de liquidación de la cuenta o si es una nómina.
//                     ConfConta.Get();
//                     InfoEmp1.Get();
//                     if (Tipopercep = GLSetup."Tipo perceptor liq.") then begin
//                         if (Tipopercep <> ConfConta."Tipo perceptor liq.") then begin
//                             NoMovRet1 := TraerNoMovRetencion;
//                             Proyecto := Proy;
//                             if Imp < 0 then
//                                 CrearmovretenciónIRPF(NoMovRet1, ProvCLi, Desc, CifNif, DocDate, PostDate, Num, ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, CP, SourcCode, CurrencyCode, Tipo::" ")
//                             else
//                                 CrearmovretenciónIRPF(NoMovRet1, ProvCLi, Desc, CifNif, DocDate, PostDate, Num, ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, CP, SourcCode, CurrencyCode, Tipo::" ")
//                         end;
//                     end;
//                 end;
//             //Factura
//             Tipo::Invoice:
//                 begin
//                     //Traemos el documento.
//                     if FacCompra1.Get(Num) then begin
//                         FacCompra1.CALCFIELDS("Amount Including VAT", Amount);
//                         LinFacCompra1.Reset;
//                         LinFacCompra1.Setrange("Document No.", FacCompra1."No.");
//                         LinFacCompra1.Setrange("Lín. retención", true);
//                         if LinFacCompra1.Find('-') then begin
//                             NoMovRet1 := TraerNoMovRetencion;
//                             Proyecto := LinFacCompra1."Job No.";
//                             CrearmovretenciónIRPF(NoMovRet1, FacCompra1."Pay-to Vendor No.", FacCompra1."Pay-to Name", FacCompra1."VAT Registration No.", FacCompra1."Document Date", FacCompra1."Posting Date", FacCompra1."No.", ImpFacturaSinIva, -BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, FacCompra1."Pay-to Post Code", SourcCode, FacCompra1."Currency Code", Tipo::Invoice);
//                             //TECNOCOM - EFS - 070912
//                             NMovRentencion := UltMovRetención;
//                             PasarDimensionesRet(LinFacCompra1."Document No.", LinFacCompra1."Line No.", NMovRentencion, true, false);
//                             //FIN TECNOCOM - EFS - 070912
//                         end;
//                     end;
//                 end;
//             //Abono
//             Tipo::"Credit Memo":
//                 begin
//                     //Traemos el documento.
//                     if AboCompra1.Get(Num) then begin
//                         AboCompra1.CALCFIELDS("Amount Including VAT", Amount);
//                         LinAboCompra1.Reset;
//                         LinAboCompra1.Setrange("Document No.", AboCompra1."No.");
//                         LinAboCompra1.Setrange("Lín. retención", true);
//                         if LinAboCompra1.Find('-') then begin
//                             NoMovRet1 := TraerNoMovRetencion;
//                             Proyecto := LinAboCompra1."Job No.";
//                             CrearmovretenciónIRPF(NoMovRet1, AboCompra1."Pay-to Vendor No.", AboCompra1."Pay-to Name", AboCompra1."VAT Registration No.", AboCompra1."Document Date", AboCompra1."Posting Date", //AboCompra1."No.",AboCompra1."Amount Including VAT",BaseRet,PorcRet,Tipopercep,Clavepercep,
//                             AboCompra1."No.", -ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, //-Imp,AboCompra1.Amount,AboCompra1."Pay-to Post Code",SourcCode,AboCompra1."Currency Code",
//                             -Imp, -ImpFactura, AboCompra1."Pay-to Post Code", SourcCode, AboCompra1."Currency Code", Tipo::"Credit Memo");
//                             //TECNOCOM - EFS - 070912
//                             NMovRentencion := UltMovRetención;
//                             PasarDimensionesRet(LinAboCompra1."Document No.", LinAboCompra1."Line No.", NMovRentencion, false, false);
//                             //FIN TECNOCOM - EFS - 070912
//                         end;
//                     end;
//                 end;
//         end;
//     end;

//     procedure UltMovRetención(): Integer;
//     VAR
//         AuxMovRetención: Record "EXC Retention Tax registers";
//         RVendor: Record vendor;
//         RCustomer: Record customer;
//     begin
//         AuxMovRetención.Reset;
//         if AuxMovRetención.FindLast then exit(AuxMovRetención."Entry No.");
//     end;

//     procedure PasarDimensionesRet(Ndoc: Code[20]; Nlinea: Integer; UltimoMovRet: Integer; Factura: Boolean; Venta: Boolean);
//     VAR
//         HistFactLinCompra: Record "Purch. Inv. Line";
//         HistFactLinVenta: Record "Sales Invoice Line";
//         HistAbonoLinCompra: Record "Purch. Cr. Memo Line";
//         HistAbonoLinVenta: Record "Sales Cr.Memo Line";
//         RcdMovRet: Record "EXC Retention Tax registers";
//     begin
//         RcdMovRet.Get(UltimoMovRet);
//         if Factura then begin
//             if Venta then begin
//                 HistFactLinVenta.Get(Ndoc, Nlinea);
//                 RcdMovRet."Shortcut Dimension 1 Code" := HistFactLinVenta."Shortcut Dimension 1 Code";
//                 RcdMovRet."Shortcut Dimension 2 Code" := HistFactLinVenta."Shortcut Dimension 2 Code";
//             end
//             else begin
//                 HistFactLinCompra.Get(Ndoc, Nlinea);
//                 RcdMovRet."Shortcut Dimension 1 Code" := HistFactLinCompra."Shortcut Dimension 1 Code";
//                 RcdMovRet."Shortcut Dimension 2 Code" := HistFactLinCompra."Shortcut Dimension 2 Code";
//             end;
//         end
//         else begin
//             if Venta then begin
//                 HistAbonoLinVenta.Get(Ndoc, Nlinea);
//                 RcdMovRet."Shortcut Dimension 1 Code" := HistAbonoLinVenta."Shortcut Dimension 1 Code";
//                 RcdMovRet."Shortcut Dimension 2 Code" := HistAbonoLinVenta."Shortcut Dimension 2 Code";
//             end
//             else begin
//                 HistAbonoLinCompra.Get(Ndoc, Nlinea);
//                 RcdMovRet."Shortcut Dimension 1 Code" := HistAbonoLinCompra."Shortcut Dimension 1 Code";
//                 RcdMovRet."Shortcut Dimension 2 Code" := HistAbonoLinCompra."Shortcut Dimension 2 Code";
//             end;
//         end;
//         RcdMovRet.Modify;
//     end;
//     //Codeunit 12 FIN
// }
