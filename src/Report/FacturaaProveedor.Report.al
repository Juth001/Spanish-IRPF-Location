namespace ScriptumVita.IRPF;
Report 86300 "Factura a Proveedor"
{
    Caption = 'Factura a Proveedor';
    RDLCLayout = './Reports/Layout/FacturaaProveedor.rdl';
    DefaultLayout = RDLC;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = sorting("Vendor Invoice No.", "Posting Date");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Posted Purchase Invoice';

            column(TextoSII; TextoSII)
            {
            }
            column(PurchInvHeader_VendorInvoiceNo; "Purch. Inv. Header"."Vendor Invoice No.")
            {
            }
            column(PurchInvHeader_PostingDate; "Purch. Inv. Header"."Posting Date")
            {
            }
            column(PurchInvHeader_VATRegistrationNo; "Purch. Inv. Header"."VAT Registration No.")
            {
            }
            column(VATNoText; VATNoText)
            {
            }
            column(txtCIF; txtCIF)
            {
            }
            column(txtFax; txtFax)
            {
            }
            column(txtTelefono; txtTelefono)
            {
            }
            column(VendAddr5; VendAddr[5])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(VendAddr4; VendAddr[4])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(VendAddr3; VendAddr[3])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(VendAddr2; VendAddr[2])
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(VendAddr1; VendAddr[1])
            {
            }
            column(STRSUBSTNO_Text004_CopyText; StrSubstNo(Text004, CopyText))
            {
            }
            /*
            column(txtFacturacionPorDestinatario; txtFacturacionPorDestinatario)
            {
            }
            
            column(FechaVto1; FechaVto1)
            {
            }
            column(FechaVto2; FechaVto2)
            {
            }
            column(FechaVto3; FechaVto3)
            {
            }
            column(ImporteVto1; ImporteVto1)
            {
            }
            column(ImporteVto2; ImporteVto2)
            {
            }
            column(ImporteVto3; ImporteVto3)
            {
            }
            column(FormaPagoVto3; FormaPagoVto3)
            {
            }
            column(FormaPagoVto2; FormaPagoVto2)
            {
            }
            column(FormaPagoVto1; FormaPagoVto1)
            {
            }
            column(TotalFactura; TotalFactura)
            {
            }
            
            column(CuotaIVA; CuotaIVA)
            {
            }
            column(CuotaIVA1; CuotaIVA1)
            {
            }
            column(CuotaIVA2; CuotaIVA2)
            {
            }
            column(CuotaIVA3; CuotaIVA3)
            {
            }
            column(lblPorcientoIVA; lblPorcientoIVA)
            {
                AutoFormatType = 1;
            }
            column(lblPorcientoIVA1; lblPorcientoIVA1)
            {
                //DecimalPlaces = 0 : 0;
            }
            column(lblPorcientoIVA2; lblPorcientoIVA2)
            {
                //DecimalPlaces = 0 : 0;
            }
            column(lblPorcientoIVA3; lblPorcientoIVA3)
            {
                //DecimalPlaces = 0 : 0;
            }
            column(Base3; Base3)
            {
            }
            column(Base2; Base2)
            {
            }
            column(Base1; Base1)
            {
            }
            //column(Base; Format(Base, 0, '"Sales Invoice Header"."Currency Code"'))
            column(Base; Base)
            {
                AutoFormatType = 1;
            }
            
            column(PurchInvLineImporteIRPF; PurchInvLineImporteIRPF)
            {
                AutoFormatType = 1;
            }
            column(PurchInvLinePmtDiscRcdAmount; -"Purch. Inv. Line"."Pmt. Discount Amount")
            {
                AutoFormatType = 1;
            }
            */
            column(ImprimirServiciosPrestados; ImprimirServiciosPrestados)
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));

                    /*column(TextoSII; TextoSII)
                    {
                    }
                    column(PurchInvHeader_VendorInvoiceNo; "Purch. Inv. Header"."Vendor Invoice No.")
                    {
                    }
                    column(PurchInvHeader_PostingDate; "Purch. Inv. Header"."Posting Date")
                    {
                    }
                    column(PurchInvHeader_VATRegistrationNo; "Purch. Inv. Header"."VAT Registration No.")
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(txtCIF; txtCIF)
                    {
                    }
                    column(txtFax; txtFax)
                    {
                    }
                    column(txtTelefono; txtTelefono)
                    {
                    }
                    column(VendAddr5; VendAddr[5])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(VendAddr4; VendAddr[4])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(VendAddr3; VendAddr[3])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(VendAddr2; VendAddr[2])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(VendAddr1; VendAddr[1])
                    {
                    }
                    column(STRSUBSTNO_Text004_CopyText; StrSubstNo(Text004, CopyText))
                    {
                    }
                    column(txtFacturacionPorDestinatario; txtFacturacionPorDestinatario)
                    {
                    }
                    column(FechaVto1; FechaVto1)
                    {
                    }
                    column(FechaVto2; FechaVto2)
                    {
                    }
                    column(FechaVto3; FechaVto3)
                    {
                    }
                    column(ImporteVto1; ImporteVto1)
                    {
                    }
                    column(ImporteVto2; ImporteVto2)
                    {
                    }
                    column(ImporteVto3; ImporteVto3)
                    {
                    }
                    column(FormaPagoVto3; FormaPagoVto3)
                    {
                    }
                    column(FormaPagoVto2; FormaPagoVto2)
                    {
                    }
                    column(FormaPagoVto1; FormaPagoVto1)
                    {
                    }
                    column(TotalFactura; TotalFactura)
                    {
                    }
                    column(CuotaIVA; CuotaIVA)
                    {
                    }
                    column(CuotaIVA1; CuotaIVA1)
                    {
                    }
                    column(CuotaIVA2; CuotaIVA2)
                    {
                    }
                    column(CuotaIVA3; CuotaIVA3)
                    {
                    }
                    column(lblPorcientoIVA; lblPorcientoIVA)
                    {
                        AutoFormatType = 1;
                    }
                    column(lblPorcientoIVA1; lblPorcientoIVA1)
                    {
                        //DecimalPlaces = 0 : 0;
                    }
                    column(lblPorcientoIVA2; lblPorcientoIVA2)
                    {
                        //DecimalPlaces = 0 : 0;
                    }
                    column(lblPorcientoIVA3; lblPorcientoIVA3)
                    {
                        //DecimalPlaces = 0 : 0;
                    }
                    column(Base3; Base3)
                    {
                    }
                    column(Base2; Base2)
                    {
                    }
                    column(Base1; Base1)
                    {
                    }
                    column(Base; Format(Base, 0, '"Sales Invoice Header"."Currency Code"'))
                    {
                        AutoFormatType = 1;
                    }
                    column(PurchInvLineImporteIRPF; PurchInvLineImporteIRPF)
                    {
                        AutoFormatType = 1;
                    }
                    column(PurchInvLinePmtDiscRcdAmount; -"Purch. Inv. Line"."Pmt. Discount Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(ImprimirServiciosPrestados; ImprimirServiciosPrestados) { }*/
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Purch. Inv. Header";
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                        trigger OnAfterGetRecord();
                        begin
                            if Number = 1 then begin
                                if not PostedDocDim1.Find('-') then CurrReport.Break;
                            end
                            else if not Continue then CurrReport.Break;
                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 %2', PostedDocDim1."Dimension Code", PostedDocDim1."Dimension Value Code")
                                else
                                    DimText := StrSubstNo('%1, %2 %3', DimText, PostedDocDim1."Dimension Code", PostedDocDim1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until (PostedDocDim1.Next = 0);
                        end;

                        trigger OnPreDataItem();
                        begin
                            if not ShowInternalInfo then CurrReport.Break;
                        end;
                    }
                    dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Purch. Inv. Header";
                        DataItemTableView = sorting("Document No.", "Line No.");

                        column(txtServiciosPrestados; txtServiciosPrestados)
                        {
                        }
                        column(PurchInvLine_LineAmount; "Line Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(trayecto; trayecto)
                        {
                        }
                        column(plataforma_v; plataforma_v)
                        {
                        }
                        column(tractora_v; tractora_v)
                        {
                        }
                        column(n_ot; n_ot)
                        {
                        }
                        column(Origen; Origen)
                        {
                        }
                        column(Destino; Destino)
                        {
                        }
                        column(PurchInvLine_DirectUnitCost; "Direct Unit Cost")
                        {
                            AutoFormatType = 0;
                            DecimalPlaces = 4 : 4;
                        }
                        column(PurchInvLine_VATPct; "VAT %")
                        {
                        }
                        column(cantidad; cantidad)
                        {
                        }
                        column(fecha; fecha)
                        {
                        }
                        column(imprimirlin1; imprimirlin1)
                        {
                        }
                        column(imprimirlin2; imprimirlin2)
                        {
                        }
                        trigger OnAfterGetRecord();
                        begin
                            imprimirlin1 := false;
                            imprimirlin2 := false;
                            if (Type = Type::"G/L Account") and (not ShowInternalInfo) then "No." := '';
                            if VATPostingSetup.Get("Purch. Inv. Line"."VAT Bus. Posting Group", "Purch. Inv. Line"."VAT Prod. Posting Group") then begin
                                VATAmountLine.Init;
                                VATAmountLine."VAT Identifier" := "Purch. Inv. Line"."VAT Identifier";
                                VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                                VATAmountLine."Tax Group Code" := "Tax Group Code";
                                VATAmountLine."Use Tax" := "Use Tax";
                                VATAmountLine."VAT %" := VATPostingSetup."VAT %";
                                VATAmountLine."EC %" := VATPostingSetup."EC %";
                                VATAmountLine."VAT Base" := Amount;
                                VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                                VATAmountLine."Line Amount" := "Line Amount";
                                VATAmountLine."Pmt. Discount Amount" := "Pmt. Discount Amount";
                                if "Allow Invoice Disc." then VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                                VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                                VATAmountLine.SetCurrencyCode("Purch. Inv. Header"."Currency Code");
                                VATAmountLine."VAT Difference" := "VAT Difference";
                                VATAmountLine."EC Difference" := "EC Difference";
                                if "Purch. Inv. Header"."Prices Including VAT" then VATAmountLine."Prices Including VAT" := true;
                                VATAmountLine.InsertLine;
                            end;
                            KilometrosCargados := '';
                            KilometrosVacios := '';
                            if "Purch. Inv. Line".OT <> '' then begin
                                pOTL.Reset;
                                pOTL.SetRange(pOTL."Document Type", pOTL."document type"::Order);
                                pOTL.SetRange(pOTL."Document No.", "Purch. Inv. Line".OT);
                            end;
                            //MPPG
                            NumLineas += 2;
                            //++ OT2-051963
                            //with "Purch. Inv. Line" do begin
                            KilometrosCargados := '';
                            KilometrosVacios := '';
                            // CGM T15887 090306
                            //if "Purch. Inv. Line".Quantity <> 1 then
                            if "Purch. Inv. Line".Type in ["Purch. Inv. Line".Type::"G/L Account", "Purch. Inv. Line".Type::Item] then begin
                                if "Purch. Inv. Line"."No. Extracoste" = 0 then begin
                                    //Línea de Viaje
                                    //if Tabla_cabecera_alb_compra.Get("Purch. Inv. Line"."Receipt No.") then
                                    //if Tabla_lineas_alb_compra.Get("Purch. Inv. Line"."Receipt No.", "Purch. Inv. Line"."Receipt Line No.") then begin
                                    /*fecha := Format(Tabla_cabecera_alb_compra."Order Date");
                                    n_ot := Tabla_cabecera_alb_compra."Order No.";
                                    tractora_v := Tabla_cabecera_alb_compra.Tractora;
                                    plataforma_v := Tabla_cabecera_alb_compra.Plataforma;*/
                                    fecha := Format("Purch. Inv. Header"."Order Date");
                                    n_ot := "Purch. Inv. Line".OT;
                                    tractora_v := "Purch. Inv. Line".Tractora;
                                    plataforma_v := "Purch. Inv. Line".Plataforma;
                                    //trayecto := "Purch. Inv. Line".Description + ' - ' + "Purch. Inv. Line"."Description 2";
                                    trayecto := "Purch. Inv. Line".Origen + ' - ' + "Purch. Inv. Line".Destino; //JPGCAT 291220
                                    //end;
                                    if "Purch. Inv. Line".Quantity = 1 then
                                        cantidad := ''
                                    else
                                        cantidad := Format("Purch. Inv. Line".Quantity);
                                    if "Purch. Inv. Line"."Unit of Measure Code" = 'UND' then
                                        unidades := ''
                                    else
                                        unidades := Format("Purch. Inv. Line"."Unit of Measure Code");
                                end
                                else begin
                                    //Extracoste
                                    fecha := '';
                                    n_ot := '';
                                    tractora_v := '';
                                    plataforma_v := '';
                                    trayecto := "Purch. Inv. Line".Description;
                                    if "Purch. Inv. Line".Quantity = 1 then
                                        cantidad := ''
                                    else
                                        cantidad := Format("Purch. Inv. Line".Quantity);
                                    if "Purch. Inv. Line"."Unit of Measure Code" = 'UND' then
                                        unidades := ''
                                    else
                                        unidades := Format("Purch. Inv. Line"."Unit of Measure Code");
                                end;
                                if not ImprimirServiciosPrestados then NumLineas += 2;
                                if "Purch. Inv. Line".Quantity <> 1 then
                                    imprimirlin1 := true
                                else
                                    imprimirlin2 := true;
                            end;
                            //end;
                            //MPPG
                        end;

                        trigger OnPreDataItem();
                        begin
                            VATAmountLine.DeleteAll;
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do MoreLines := Next(-1) <> 0;
                            if not MoreLines then CurrReport.Break;
                            SetRange("Line No.", 0, "Line No.");
                        end;
                    }
                    dataitem("Lineas hasta fondo"; Integer)
                    {
                        DataItemTableView = sorting(Number);

                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                            trigger OnAfterGetRecord();
                            begin
                                if Number = 1 then begin
                                    if not PostedDocDim2.Find('-') then CurrReport.Break;
                                end
                                else if not Continue then CurrReport.Break;
                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', PostedDocDim2."Dimension Code", PostedDocDim2."Dimension Value Code")
                                    else
                                        DimText := StrSubstNo('%1, %2 %3', DimText, PostedDocDim2."Dimension Code", PostedDocDim2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until (PostedDocDim2.Next = 0);
                            end;

                            trigger OnPreDataItem();
                            begin
                                if not ShowInternalInfo then CurrReport.Break;
                                PostedDocDim2.SetRange("Dimension Set ID", "Purch. Inv. Line"."Dimension Set ID");
                                if NumLineas < NumLineasFondo then NumLineas += 1;
                                if NumLineas = NumLineasFondo then NumLineas += 1;
                            end;
                        }
                        trigger OnPreDataItem();
                        begin
                            SetRange(Number, NumLineas, NumLineasFondo);
                        end;
                    }
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = sorting(Number);

                        trigger OnAfterGetRecord();
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem();
                        begin
                            SetRange(Number, 1, VATAmountLine.Count);
                        end;
                    }
                    dataitem(Total; Integer)
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        trigger OnPreDataItem();
                        begin
                            if "Purch. Inv. Header"."Buy-from Vendor No." = "Purch. Inv. Header"."Pay-to Vendor No." then CurrReport.Break;
                        end;
                    }
                    dataitem(Total3; Integer)
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        trigger OnPreDataItem();
                        begin
                            if ShipToAddr[1] = '' then CurrReport.Break;
                        end;
                    }
                    dataitem(Total4; Integer)
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(txtFacturacionPorDestinatario; txtFacturacionPorDestinatario)
                        {
                        }
                        column(FechaVto1; FechaVto1)
                        {
                        }
                        column(FechaVto2; FechaVto2)
                        {
                        }
                        column(FechaVto3; FechaVto3)
                        {
                        }
                        column(ImporteVto1; ImporteVto1)
                        {
                        }
                        column(ImporteVto2; ImporteVto2)
                        {
                        }
                        column(ImporteVto3; ImporteVto3)
                        {
                        }
                        column(FormaPagoVto3; FormaPagoVto3)
                        {
                        }
                        column(FormaPagoVto2; FormaPagoVto2)
                        {
                        }
                        column(FormaPagoVto1; FormaPagoVto1)
                        {
                        }
                        column(TotalFactura; TotalFactura)
                        {
                        }
                        column(CuotaIVA; CuotaIVA)
                        {
                        }
                        column(CuotaIVA1; CuotaIVA1)
                        {
                        }
                        column(CuotaIVA2; CuotaIVA2)
                        {
                        }
                        column(CuotaIVA3; CuotaIVA3)
                        {
                        }
                        column(lblPorcientoIVA; lblPorcientoIVA)
                        {
                            AutoFormatType = 1;
                        }
                        column(lblPorcientoIVA1; lblPorcientoIVA1)
                        {
                            //DecimalPlaces = 0 : 0;
                        }
                        column(lblPorcientoIVA2; lblPorcientoIVA2)
                        {
                            //DecimalPlaces = 0 : 0;
                        }
                        column(lblPorcientoIVA3; lblPorcientoIVA3)
                        {
                            //DecimalPlaces = 0 : 0;
                        }
                        column(Base3; Base3)
                        {
                        }
                        column(Base2; Base2)
                        {
                        }
                        column(Base1; Base1)
                        {
                        }
                        //column(Base; Format(Base, 0, '"Sales Invoice Header"."Currency Code"'))
                        column(Base; Base)
                        {
                            AutoFormatType = 1;
                        }
                        column(PurchInvLineImporteIRPF; PurchInvLineImporteIRPF)
                        {
                            AutoFormatType = 1;
                        }
                        column(PurchInvLinePmtDiscRcdAmount; -PurchInvLineDPP)
                        {
                            AutoFormatType = 1;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            CalcularTotales;
                        end;
                    }
                    trigger OnPreDataItem();
                    begin
                        NumLineas := 1;
                    end;
                    //JPG
                    //trigger OnAfterGetRecord()
                    //begin
                    //    CalcularTotales;
                    //end;
                    //trigger OnPostDataItem()
                    //begin
                    //    CalcularTotales;
                    //end;
                }
                trigger OnAfterGetRecord();
                begin
                    if Number > 1 then CopyText := Text003;
                end;

                trigger OnPostDataItem();
                begin
                    if not CurrReport.Preview then PurchInvCountPrinted.Run("Purch. Inv. Header");
                end;

                trigger OnPreDataItem();
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                end;
            }
            trigger OnPostDataItem()
            begin
            end;

            trigger OnAfterGetRecord()
            begin
                //CurrReport.Language := Language.GetLanguageID("Language Code");
                CompanyInfo.Get;
                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end
                else begin
                    if ("Purch. Inv. Header"."Shortcut Dimension 1 Code" = 'PORTUGAL') then begin
                        FormatAddr.FormatAddr(CompanyAddr, CompanyInfo.pName, CompanyInfo."pName 2", '', CompanyInfo.pAddress, CompanyInfo."pAddress 2", CompanyInfo.pCity, COPYSTR(CompanyInfo."pPost Code", 1, 8), CompanyInfo.pCounty, '');
                        //FormatAddr.CompanyPT(CompanyAddr, CompanyInfo);
                        txtTelefono := CompanyInfo."pPhone No.";
                        txtFax := CompanyInfo."pFax No.";
                        txtCIF := CompanyInfo."pVAT Registration No.";
                    end
                    else begin
                        FormatAddr.Company(CompanyAddr, CompanyInfo);
                        txtTelefono := CompanyInfo."Phone No.";
                        txtFax := CompanyInfo."Fax No.";
                        txtCIF := CompanyInfo."VAT Registration No.";
                    end;
                end;
                PostedDocDim1.SetRange("Dimension Set ID", "Purch. Inv. Header"."Dimension Set ID");
                if "Order No." = '' then
                    OrderNoText := ''
                else
                    OrderNoText := FieldCaption("Order No.");
                if "Purchaser Code" = '' then begin
                    Clear(SalesPurchPerson);
                    PurchaserText := '';
                end
                else begin
                    SalesPurchPerson.Get("Purchaser Code");
                    PurchaserText := Text000
                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text006, GLSetup."LCY Code");
                end
                else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "Currency Code");
                    TotalExclVATText := StrSubstNo(Text006, "Currency Code");
                end;
                FormatAddr.PurchInvPayTo(VendAddr, "Purch. Inv. Header");
                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else
                    PaymentTerms.Get("Payment Terms Code");
                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else
                    ShipmentMethod.Get("Shipment Method Code");
                FormatAddr.PurchInvShipTo(ShipToAddr, "Purch. Inv. Header");
                if LogInteraction then if not CurrReport.Preview then SegManagement.LogDocument(14, "No.", 0, 0, Database::Vendor, "Buy-from Vendor No.", "Purchaser Code", '', "Posting Description", '');
                if not ImprimirServiciosPrestados then begin
                    //Comprobar si hay que hacerlo con el modo de Servicios Prestados
                    //Si es FPC CADSA, tiene que imprimirse con lo de los Servicios prestados
                    "Purch. Inv. Header".CalcFields("FPC Cadsa");
                    if "Purch. Inv. Header"."FPC Cadsa" and "Purch. Inv. Header"."Importado de SGL" then begin
                        ImprimirServiciosPrestados := true;
                        FechaInicialServiciosPrestados := CalcDate('<-CM>', "Purch. Inv. Header"."Posting Date");
                        FechaFinalServiciosPrestados := CalcDate('<+CM>', "Purch. Inv. Header"."Posting Date");
                    end;
                end;
                //>B47 002 00000000B47 MDS 2017.03.29
                if GuiAllowed then begin
                    //<B47 002 00000000B47 MDS 2017.03.29
                    if ImprimirServiciosPrestados then begin
                        if FechaInicialServiciosPrestados = 0D then begin
                            Error('Debe indicar el inicio del periodo de los servicios prestados');
                        end;
                        if FechaFinalServiciosPrestados = 0D then begin
                            Error('Debe indicar el fin del periodo de los servicios prestados');
                        end;
                        if FechaInicialServiciosPrestados > "Purch. Inv. Header"."Posting Date" then begin
                            Error('La fecha inicial de los servicios prestados no puede ser mayor que la fecha de registro.');
                        end;
                        if FechaFinalServiciosPrestados < "Purch. Inv. Header"."Posting Date" then begin
                            Error('La fecha final de los servicios prestados no puede ser menor que la fecha de registro.');
                        end;
                        if "Purch. Inv. Header"."Shortcut Dimension 1 Code" <> 'PORTUGAL' then
                            txtServiciosPrestados := 'SERVICIOS PRESTADOS DE TRANSPORTE DURANTE EL PERIODO  DEL ' + Format(FechaInicialServiciosPrestados) + ' AL ' + Format(FechaFinalServiciosPrestados) + ' SEGÚN DETALLE ADJUNTO.'
                        else
                            txtServiciosPrestados := 'SERVIÇOS PRESTADOS DURANTE O PERÍODO DE ' + Format(FechaInicialServiciosPrestados) + ' AL ' + Format(FechaFinalServiciosPrestados) + ' SEGUNDO DETALHE EM ANEXO.';
                    end;
                    //>MDS
                end
                else begin
                    if not ImprimirServiciosPrestados then begin
                        //Comprobar si hay que hacerlo con el modo de Servicios Prestados
                        //Si es FPC CADSA, tiene que imprimirse con lo de los Servicios prestados
                        "Purch. Inv. Header".CalcFields("FPC Cadsa");
                        if "Purch. Inv. Header"."FPC Cadsa" and "Purch. Inv. Header"."Importado de SGL" then begin
                            ImprimirServiciosPrestados := true;
                            FechaInicialServiciosPrestados := CalcDate('<-CM>', "Purch. Inv. Header"."Posting Date");
                            FechaFinalServiciosPrestados := CalcDate('<+CM>', "Purch. Inv. Header"."Posting Date");
                        end;
                    end;
                    if ImprimirServiciosPrestados then begin
                        FechaInicialServiciosPrestados := CalcDate('<-CM>', "Purch. Inv. Header"."Posting Date");
                        FechaFinalServiciosPrestados := CalcDate('<+CM>', "Purch. Inv. Header"."Posting Date");
                        if "Purch. Inv. Header"."Shortcut Dimension 1 Code" <> 'PORTUGAL' then
                            txtServiciosPrestados := 'SERVICIOS PRESTADOS DE TRANSPORTE DURANTE EL PERIODO  DEL ' + Format(FechaInicialServiciosPrestados) + ' AL ' + Format(FechaFinalServiciosPrestados) + ' SEGÚN DETALLE ADJUNTO.'
                        else
                            txtServiciosPrestados := 'SERVIÇOS PRESTADOS DURANTE O PERÍODO DE ' + Format(FechaInicialServiciosPrestados) + ' AL ' + Format(FechaFinalServiciosPrestados) + ' SEGUNDO DETALHE EM ANEXO.';
                    end;
                end;
                //<MDS
                //>B59 003 00000000B59 MDS 2017.08.03
                Clear(TextoSII);
                if EsFPC then if COMPANYNAME <> 'CGL_PORTUGAL' then TextoSII := StrSubstNo(TextSII50001, "Document Date", "Transaction Date");
                //<B59 003 00000000B59 MDS 2017.08.03
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("Fecha inicial Servicios prestados")
                {
                    Caption = 'Fecha inicial Servicios prestados';

                    field(FechaInicialServiciosPrestados; FechaInicialServiciosPrestados)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Fecha inicial Servicios prestados';
                    }
                    field(FechaFinalServiciosPrestados; FechaFinalServiciosPrestados)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Fecha final Servicios prestados';
                    }
                }
                group(Options)
                {
                    Caption = 'Options';

                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Internal Information';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction';
                    }
                    field(ImprimirServiciosPrestados; ImprimirServiciosPrestados)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Imprimir servicios prestados';
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnOpenPage()
        var
            //COL-154++
            DocumentType: Enum "Interaction Log Entry Document Type";
        //COL-154--
        begin
            //COL-154++
            // LogInteraction := SegManagement.FindInteractTmplCode(14) <> '';
            LogInteraction := SegManagement.FindInteractionTemplateCode(DocumentType::"Purch. Inv.") <> '';
            //COL-154--
            //RequestRequestOptionsPage.LogInteraction.ENABLED(LogInteraction); 
            //RequestRequestOptionsPage.fmeServiciosprestados.VISIBLE(ImprimirServiciosPrestados);
        end;
    }
    trigger OnInitReport()
    begin
        GLSetup.Get;
    end;

    trigger OnPreReport()
    begin
        NumLineasFondo := 31;
    end;

    var
        Text000: label 'Purchaser';
        Text001: label 'Total %1';
        Text002: label 'Total %1 Incl. VAT';
        Text003: label 'COPIA';
        Text004: label 'Factura - Compra %1';
        Text005: label 'Page %1';
        Text006: label 'Total %1 Excl. VAT';
        trayecto: Text[250];
        Tabla_cabecera_alb_compra: Record "Purch. Rcpt. Header";
        Tabla_lineas_alb_compra: Record "Purch. Rcpt. Line";
        pOTL: Record "Purchase Line";
        n_ot: Code[20];
        fecha: Text[30];
        unidades: Text[30];
        cantidad: Text[30];
        tractora_v: Text[30];
        plataforma_v: Text[30];
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        VATAmountLine: Record "VAT Amount Line" temporary;
        PostedDocDim1: Record "Dimension Set Entry";
        PostedDocDim2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        //++ COL-667
        //Language: Record Language;
        //-- COL-667
        PurchInvCountPrinted: Codeunit "Purch. Inv.-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        VendAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        PurchaserText: Text[30];
        VATNoText: Text[30];
        ReferenceText: Text[30];
        OrderNoText: Text[30];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[10];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        VATPostingSetup: Record "VAT Posting Setup";
        LogInteraction: Boolean;
        TextoIRPF: Text[30];
        KilometrosCargados: Text[30];
        KilometrosVacios: Text[30];
        NumLineasFondo: Integer;
        NumLineas: Integer;
        "----": Integer;
        Base: Decimal;
        PorcientoIVA: Decimal;
        CuotaIVA: Decimal;
        Base1: Decimal;
        PorcientoIVA1: Decimal;
        CuotaIVA1: Decimal;
        Base2: Decimal;
        PorcientoIVA2: Decimal;
        CuotaIVA2: Decimal;
        Base3: Decimal;
        PorcientoIVA3: Decimal;
        CuotaIVA3: Decimal;
        TotalFactura: Decimal;
        lblExento: Code[10];
        lblPorcientoIVA1: Text[30];
        lblPorcientoIVA2: Text[30];
        lblPorcientoIVA3: Text[30];
        lblPorcientoIVA: Text[30];
        FormaPagoVto1: Text[30];
        FormaPagoVto2: Text[30];
        FormaPagoVto3: Text[30];
        ImporteVto1: Decimal;
        ImporteVto2: Decimal;
        ImporteVto3: Integer;
        FechaVto1: Date;
        FechaVto2: Date;
        FechaVto3: Date;
        txtServiciosPrestados: Text[250];
        ImprimirServiciosPrestados: Boolean;
        FechaInicialServiciosPrestados: Date;
        FechaFinalServiciosPrestados: Date;
        txtFacturacionPorDestinatario: Text[30];
        txtTelefono: Text[30];
        txtFax: Text[30];
        txtCIF: Text[30];
        "--B59--": Integer;
        TextoSII: Text[1024];
        TextSII50000: label 'Issued in Zaragoza to %1, with transaction date %2.';
        TextSII50001: label 'Emitido en Zaragoza a %1, con fecha de operación %2.';
        PurchInvLineImporteIRPF: Decimal;
        PurchInvLineDPP: Decimal;
        imprimirlin1: Boolean;
        imprimirlin2: Boolean;

    procedure CalcularTotales()
    var
        Contador: Integer;
        MovProv: Record "Vendor Ledger Entry";
        FormasPago: Record "Payment Method";
        PurchLine: Record "Purch. Inv. Line";
    begin
        //Inicializo ya que si hay tres tipos de IVA pasa por este evento tres veces
        Base := 0;
        CuotaIVA := 0;
        Base1 := 0;
        Base2 := 0;
        Base3 := 0;
        CuotaIVA1 := 0;
        CuotaIVA2 := 0;
        CuotaIVA3 := 0;
        PorcientoIVA1 := 0;
        PorcientoIVA2 := 0;
        PorcientoIVA3 := 0;
        PurchInvLineImporteIRPF := 0;
        PurchInvLineDPP := 0;
        if VATAmountLine.FindSet then begin
            Contador := 1;
            repeat //Busco primero en cualquiera de las tres cajas si existe ya el IVA que me estan pasando. Si no existe hago el proceso
                //normal
                if (PorcientoIVA1 = VATAmountLine."VAT %") and (PorcientoIVA1 <> 0) then begin
                    //Se lo sumo al IVA1
                    Base1 += VATAmountLine."VAT Base";
                    CuotaIVA1 += VATAmountLine."VAT Amount";
                end
                else if (PorcientoIVA2 = VATAmountLine."VAT %") and (PorcientoIVA2 <> 0) then begin
                    //Se lo sumo al IVA2
                    Base2 += VATAmountLine."VAT Base";
                    CuotaIVA2 += VATAmountLine."VAT Amount";
                end
                else if (PorcientoIVA3 = VATAmountLine."VAT %") and (PorcientoIVA3 <> 0) then begin
                    //Se lo sumo al IVA3
                    Base3 += VATAmountLine."VAT Base";
                    CuotaIVA3 += VATAmountLine."VAT Amount";
                end
                else begin
                    //Caso general
                    if Contador = 1 then begin
                        Base1 := VATAmountLine."VAT Base";
                        PorcientoIVA1 := VATAmountLine."VAT %";
                        CuotaIVA1 := VATAmountLine."VAT Amount";
                        //Para deducir de la base los importes de las retenciones (NO SUJETO)
                        if (VATAmountLine."VAT Calculation Type" = VATAmountLine."vat calculation type"::"No taxable VAT") and (VATAmountLine."VAT Identifier" = 'NO SUJETO') and (PorcientoIVA1 = 0) then begin
                            Base1 := 0;
                        end;
                    end;
                    if Contador = 2 then begin
                        Base2 := VATAmountLine."VAT Base";
                        PorcientoIVA2 := VATAmountLine."VAT %";
                        CuotaIVA2 := VATAmountLine."VAT Amount";
                        //Para deducir de la base los importes de las retenciones (NO SUJETO)
                        if (VATAmountLine."VAT Calculation Type" = VATAmountLine."vat calculation type"::"No taxable VAT") and (VATAmountLine."VAT Identifier" = 'NO SUJETO') and (PorcientoIVA2 = 0) then begin
                            Base2 := 0;
                        end;
                    end;
                    if Contador = 3 then begin
                        Base3 := VATAmountLine."VAT Base";
                        PorcientoIVA3 := VATAmountLine."VAT %";
                        CuotaIVA3 := VATAmountLine."VAT Amount";
                        //Para deducir de la base los importes de las retenciones (NO SUJETO)
                        if (VATAmountLine."VAT Calculation Type" = VATAmountLine."vat calculation type"::"No taxable VAT") and (VATAmountLine."VAT Identifier" = 'NO SUJETO') and (PorcientoIVA3 = 0) then begin
                            Base3 := 0;
                        end;
                    end;
                    Contador += 1;
                end;
                PurchInvLineDPP += VATAmountLine."Invoice Discount Amount";
            until VATAmountLine.Next = 0
        end;
        Base := Base1 + Base2 + Base3;
        CuotaIVA := CuotaIVA1 + CuotaIVA2 + CuotaIVA3;
        //Control de impresion solo del total cuando haya un solo tipo de IVA
        if ((CuotaIVA1 = CuotaIVA) and (Base1 = Base)) or ((CuotaIVA2 = CuotaIVA) and (Base2 = Base)) or ((CuotaIVA3 = CuotaIVA) and (Base3 = Base)) then begin
            //QUE NO SE IMPRIMAN LOS DESGLOSES Y APAREZCA EL TIPO DE IVA UNICO
            Base1 := 0;
            Base2 := 0;
            Base3 := 0;
            if PorcientoIVA1 <> 0 then begin
                PorcientoIVA := PorcientoIVA1;
            end;
            if PorcientoIVA2 <> 0 then begin
                PorcientoIVA := PorcientoIVA2;
            end;
            if PorcientoIVA3 <> 0 then begin
                PorcientoIVA := PorcientoIVA3;
            end;
            PorcientoIVA1 := 0;
            PorcientoIVA2 := 0;
            PorcientoIVA3 := 0;
            CuotaIVA1 := 0;
            CuotaIVA2 := 0;
            CuotaIVA3 := 0;
            //INI ALC que aunque haya un solo tipo de IVA aparezca por lo menos una linea de desglose
            Base1 := Base;
            CuotaIVA1 := CuotaIVA;
            PorcientoIVA1 := PorcientoIVA;
            //FIN ALC que aunque haya un solo tipo de IVA aparezca por lo menos una linea de desglose
        end
        else begin
            PorcientoIVA := 0;
        end;
        if PorcientoIVA1 = 0 then
            lblPorcientoIVA1 := ''
        else
            lblPorcientoIVA1 := Format(PorcientoIVA1);
        if PorcientoIVA2 = 0 then
            lblPorcientoIVA2 := ''
        else
            lblPorcientoIVA2 := Format(PorcientoIVA2);
        if PorcientoIVA3 = 0 then
            lblPorcientoIVA3 := ''
        else
            lblPorcientoIVA3 := Format(PorcientoIVA3);
        if PorcientoIVA = 0 then
            lblPorcientoIVA := ''
        else
            lblPorcientoIVA := Format(PorcientoIVA);
        TotalFactura := Base + CuotaIVA;
        //Calculo de los vencimientos
        //Buscar de los movimientos de proveedor. Si hay algun Efecto, todo son efectos. Si n el movimiento de cliente
        FormaPagoVto1 := '';
        FechaVto1 := 0D;
        ImporteVto1 := 0;
        FormaPagoVto2 := '';
        FechaVto2 := 0D;
        ImporteVto2 := 0;
        FormaPagoVto3 := '';
        FechaVto3 := 0D;
        ImporteVto3 := 0;
        MovProv.Reset;
        MovProv.SetRange("Posting Date", "Purch. Inv. Header"."Posting Date");
        MovProv.SetRange("Document No.", "Purch. Inv. Header"."No.");
        MovProv.SetRange("Document Type", MovProv."document type"::Bill);
        if MovProv.FindSet then begin
        end
        else begin
            MovProv.SetRange("Document Type", MovProv."document type"::Invoice);
        end;
        if MovProv.FindSet then begin
            Contador := 1;
            repeat
                MovProv.CalcFields(Amount);
                if Contador = 1 then begin
                    if FormasPago.Get(MovProv."Payment Method Code") then FormaPagoVto1 := FormasPago.Description;
                    FechaVto1 := MovProv."Due Date";
                    ImporteVto1 := -MovProv.Amount;
                end;
                if Contador = 2 then begin
                    if FormasPago.Get(MovProv."Payment Method Code") then FormaPagoVto2 := FormasPago.Description;
                    FechaVto2 := MovProv."Due Date";
                    ImporteVto2 := -MovProv.Amount;
                end;
                if Contador = 3 then begin
                    if FormasPago.Get(MovProv."Payment Method Code") then FormaPagoVto3 := FormasPago.Description;
                    FechaVto3 := MovProv."Due Date";
                    ImporteVto3 := -MovProv.Amount;
                end;
                Contador += 1;
            until MovProv.Next = 0;
        end;
        if "Purch. Inv. Header"."Shortcut Dimension 1 Code" <> 'PORTUGAL' then
            txtFacturacionPorDestinatario := 'Facturación por destinatario'
        else
            txtFacturacionPorDestinatario := 'Facturaçao pelo destinatario';
        PurchLine.Reset();
        PurchLine.SetRange("Document No.", "Purch. Inv. Header"."No.");
        PurchLine.SetRange("Lín. retención", true);
        if PurchLine.FindFirst() then
            repeat
                PurchInvLineImporteIRPF += PurchLine.Amount;
            until PurchLine.next = 0;
        PurchInvLineImporteIRPF := (-1) * PurchInvLineImporteIRPF;
    end;
}
