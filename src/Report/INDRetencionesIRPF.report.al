namespace Excelia.IRPF;
report 86306 "IND Retenciones IRPF"
{
    // version INDRA
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Reports/Layout/INDRA Retenciones IRPF.rdlc';
    Caption = 'Retenciones IRPF';

    dataset
    {
        dataitem("Witholding Tax registers"; "EXC Retention Tax registers")
        {
            RequestFilterFields = "Clave de Percepción", "Clave IRPF", "Subclave IRPF", "CIF/NIF", "Fecha registro";

            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; 1)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Witholding_Tax_registers__GETFILTERS; "Witholding Tax registers".GETFILTERS)
            {
            }
            column(Witholding_Tax_registers__Witholding_Tax_registers___Clave_IRPF_; "Witholding Tax registers"."Clave IRPF")
            {
            }
            column(Witholding_Tax_registers__Subclave_IRPF_; "Subclave IRPF")
            {
            }
            column(Witholding_Tax_registers__Cif_Nif_; "CIF/NIF")
            {
            }
            column(Witholding_Tax_registers__N__documento_; "Nº documento")
            {
            }
            column(Witholding_Tax_registers__N__Proveedor___N__Cliente_; "Nº Proveedor / Nº Cliente")
            {
            }
            column(ProvT_Name; ProvT.Name)
            {
            }
            column(Witholding_Tax_registers__Cif_Nif__Control1000000003; "CIF/NIF")
            {
            }
            column(Witholding_Tax_registers__Fecha_registro_; "Fecha registro")
            {
            }
            column(Witholding_Tax_registers__Base_retencion__DL__; "Base retencion (DL)")
            {
            }
            column(Witholding_Tax_registers____retención_; "% retención")
            {
            }
            column(Witholding_Tax_registers__Importe_retención__DL__; "Importe retención (DL)")
            {
            }
            column(TotalFor___FIELDCAPTION__Cif_Nif__; TotalFor + FIELDCAPTION("CIF/NIF"))
            {
            }
            column(Witholding_Tax_registers__Cif_Nif__Control1100292012; "CIF/NIF")
            {
            }
            column(Witholding_Tax_registers__Base_retencion__DL___Control1100292014; "Base retencion (DL)")
            {
            }
            column(Witholding_Tax_registers__Importe_retención__DL___Control1100292016; "Importe retención (DL)")
            {
            }
            column(Mostrartotporclave; Mostrartotporclave)
            {
            }
            column(Mostrartotporsubclave; Mostrartotporsubclave)
            {
            }
            column(Mostrartotporcif; Mostrartotporcif)
            {
            }
            column(TotalFor___FIELDCAPTION__Subclave_IRPF__; TotalFor + FIELDCAPTION("Subclave IRPF"))
            {
            }
            column(Witholding_Tax_registers__Base_retencion__DL___Control1100292021; "Base retencion (DL)")
            {
            }
            column(Witholding_Tax_registers__Importe_retención__DL___Control1100292022; "Importe retención (DL)")
            {
            }
            column(Witholding_Tax_registers__Witholding_Tax_registers___Subclave_IRPF_; "Witholding Tax registers"."Subclave IRPF")
            {
            }
            column(Mostrartotporclave_3; Mostrartotporclave_3)
            {
            }
            column(Mostrartotporsubclave_3; Mostrartotporsubclave_3)
            {
            }
            column(Mostrartotporcif_3; Mostrartotporcif_3)
            {
            }
            column(Witholding_Tax_registers__Clave_IRPF_; "Clave IRPF")
            {
            }
            column(ContLineas; ContLineas)
            {
            }
            column(ContProvs; ContProvs)
            {
            }
            column(TotalFor___FIELDCAPTION__Clave_IRPF__; TotalFor + FIELDCAPTION("Clave IRPF"))
            {
            }
            column(Cantidad_Retenciones__; 'Cantidad Retenciones:')
            {
            }
            column(Cantidad_Perceptores__; 'Cantidad Perceptores:')
            {
            }
            column(Witholding_Tax_registers__Base_retencion__DL___Control1000000014; "Base retencion (DL)")
            {
            }
            column(Totalagrupadoimporteretencion; Totalagrupadoimporteretencion)
            {
            }
            column(Mostrartotporcif_2; Mostrartotporcif_2)
            {
            }
            column(Mostrartotporsubclave_2; Mostrartotporsubclave_2)
            {
            }
            column(Mostrartotporclave_2; Mostrartotporclave_2)
            {
            }
            column(TOTAL_; 'TOTAL')
            {
            }
            column(Cantidad_Retenciones___Control1000000017; 'Cantidad Retenciones:')
            {
            }
            column(Cantidad_Perceptores___Control1000000018; 'Cantidad Perceptores:')
            {
            }
            column(ContLineasTotal; ContLineasTotal)
            {
            }
            column(ContProvsTotal; ContProvsTotal)
            {
            }
            column(Witholding_Tax_registers__Base_retencion__DL___Control1000000021; "Base retencion (DL)")
            {
            }
            column(Totalimporteretencion; Totalimporteretencion)
            {
            }
            column(Deductions_IRPFCaption; Deductions_IRPFCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Deduction_Amount__LCY_Caption; Deduction_Amount__LCY_CaptionLbl)
            {
            }
            column(DeductionCaption; DeductionCaptionLbl)
            {
            }
            column(Deduction_Base__LCY_Caption; Deduction_Base__LCY_CaptionLbl)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(VAT_Registration_No_Caption; VAT_Registration_No_CaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(Vendor_No_Caption; Vendor_No_CaptionLbl)
            {
            }
            column(Invoice_No_Caption; Invoice_No_CaptionLbl)
            {
            }
            column(Key_IRPFCaption; Key_IRPFCaptionLbl)
            {
            }
            column(Witholding_Tax_registers__Subclave_IRPF_Caption; FIELDCAPTION("Subclave IRPF"))
            {
            }
            column(Witholding_Tax_registers__Cif_Nif_Caption; FIELDCAPTION("CIF/NIF"))
            {
            }
            column(Invoice_No_Caption_Control1100292027; Invoice_No_Caption_Control1100292027Lbl)
            {
            }
            column(Vendor_No_Caption_Control1100292028; Vendor_No_Caption_Control1100292028Lbl)
            {
            }
            column(NameCaption_Control1100292029; NameCaption_Control1100292029Lbl)
            {
            }
            column(VAT_Registration_No_Caption_Control1100292030; VAT_Registration_No_Caption_Control1100292030Lbl)
            {
            }
            column(Posting_DateCaption_Control1100292031; Posting_DateCaption_Control1100292031Lbl)
            {
            }
            column(Deduction_Base__LCY_Caption_Control1100292032; Deduction_Base__LCY_Caption_Control1100292032Lbl)
            {
            }
            column(DeductionCaption_Control1100292033; DeductionCaption_Control1100292033Lbl)
            {
            }
            column(Deduction_Amount__LCY_Caption_Control1100292034; Deduction_Amount__LCY_Caption_Control1100292034Lbl)
            {
            }
            column(Witholding_Tax_registers_N__mov_; "Entry No.")
            {
            }
            column(Clave_IRPF; "Witholding Tax registers"."Report Sorting 1")
            {
            }
            column(Subclave_IRPF; "Witholding Tax registers"."Report Sorting 2")
            {
            }
            column(Cif_Nif; "Witholding Tax registers"."Report Sorting 3")
            {
            }
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                if Mostrartotporclave then begin
                    Setcurrentkey("Clave IRPF", "Subclave IRPF", "CIF/NIF", "Fecha registro")
                end
                else begin
                    if Mostrartotporsubclave then
                        Setcurrentkey("Subclave IRPF", "CIF/NIF", "Fecha registro")
                    else begin
                        if Mostrartotporcif then
                            Setcurrentkey("CIF/NIF")
                        else
                            Setcurrentkey("Clave IRPF", "Subclave IRPF", "CIF/NIF", "Fecha registro")
                    end;
                end;
                if SoloPendiente then Setrange(Pendiente, true);
                //Damos valor a los nuevos campos para agrupar el informe
                MovReten.Reset();
                MovReten.COPYFILTERS("Witholding Tax registers");
                if MovReten.FindFIRST() then
                    repeat
                        if Mostrartotporclave then
                            MovReten."Report Sorting 1" := FORMAT(MovReten."Clave IRPF")
                        else
                            MovReten."Report Sorting 1" := '';
                        if Mostrartotporsubclave then
                            MovReten."Report Sorting 2" := FORMAT(MovReten."Subclave IRPF")
                        else
                            MovReten."Report Sorting 2" := '';
                        if Mostrartotporcif then
                            MovReten."Report Sorting 3" := FORMAT(MovReten."CIF/NIF")
                        else
                            MovReten."Report Sorting 3" := '';
                        MovReten.Modify();
                    until MovReten.Next() = 0;
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                if NOT ProvT.Get("Witholding Tax registers"."Nº Proveedor / Nº Cliente") then begin
                    ProvT.INIT();
                end;
                //Control Subtotales
                if Mostrartotporclave then begin
                    if "Clave IRPF" <> ClaveActual then begin
                        ContLineas := 0;
                        ContProvs := 0;
                        CifNifAnt := 'XXInitValueXX';
                    end;
                end;
                CifActual := "Witholding Tax registers"."CIF/NIF";
                SubClaveActual := "Witholding Tax registers"."Subclave IRPF";
                ClaveActual := "Witholding Tax registers"."Clave IRPF";
                //Contamos los registros.
                ContLineas := ContLineas + 1;
                ContLineasTotal := ContLineasTotal + 1;
                if CifNifAnt <> "CIF/NIF" then begin
                    ContProvs := ContProvs + 1;
                    //ContProvsTotal := ContProvsTotal + 1;
                end;
                CifNifAnt := "CIF/NIF";
                //Control total CIF
                TempCifs.Reset();
                if NOT TempCifs.Get("CIF/NIF") then begin
                    TempCifs."No." := "CIF/NIF";
                    TempCifs.Insert();
                    ContProvsTotal += 1;
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filtros)
                {
                    field("Muestra totales por clave"; Mostrartotporclave)
                    {
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            Mostrartotporclave_1 := Mostrartotporclave;
                            Mostrartotporclave_2 := Mostrartotporclave;
                            Mostrartotporclave_3 := Mostrartotporclave;
                        end;
                    }
                    field("Muestra totales por subclave"; Mostrartotporsubclave)
                    {
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            Mostrartotporsubclave_1 := Mostrartotporsubclave;
                            Mostrartotporsubclave_2 := Mostrartotporsubclave;
                            Mostrartotporsubclave_3 := Mostrartotporsubclave;
                        end;
                    }
                    field("Muestra totales por CIF"; Mostrartotporcif)
                    {
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            Mostrartotporcif_1 := Mostrartotporcif;
                            Mostrartotporcif_2 := Mostrartotporcif;
                            Mostrartotporcif_3 := Mostrartotporcif;
                        end;
                    }
                    field("Incluir solo lo pendiente"; SoloPendiente)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            SoloPendiente := true;
        end;
    }
    VAR
        TotalFor: Label 'Total para ';
        ProvT: Record 23;
        ContLineas: Integer;
        ContLineasTotal: Integer;
        ContProvs: Integer;
        ContProvsTotal: Integer;
        CifNifAnt: Text[20];
        Importeretencion: Decimal;
        Totalagrupadoimporteretencion: Decimal;
        Totalimporteretencion: Decimal;
        Mostrartotporclave: Boolean;
        Mostrartotporsubclave: Boolean;
        Mostrartotporcif: Boolean;
        Mostrartotporclave_1: Boolean;
        Mostrartotporsubclave_1: Boolean;
        Mostrartotporcif_1: Boolean;
        Mostrartotporclave_2: Boolean;
        Mostrartotporsubclave_2: Boolean;
        Mostrartotporcif_2: Boolean;
        Mostrartotporclave_3: Boolean;
        Mostrartotporsubclave_3: Boolean;
        Mostrartotporcif_3: Boolean;
        Deductions_IRPFCaptionLbl: Label 'Retenciones IRPF';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Deduction_Amount__LCY_CaptionLbl: Label 'Importe retención (DL)';
        DeductionCaptionLbl: Label '% retención';
        Deduction_Base__LCY_CaptionLbl: Label 'Base retención (DL)';
        Posting_DateCaptionLbl: Label 'Fecha registro';
        VAT_Registration_No_CaptionLbl: Label 'CIF/NIF';
        NameCaptionLbl: Label 'Nombre';
        Vendor_No_CaptionLbl: Label 'Nº proveedor';
        Invoice_No_CaptionLbl: Label 'Nº factura';
        Key_IRPFCaptionLbl: Label 'Clave IRPF';
        Invoice_No_Caption_Control1100292027Lbl: Label 'Nº factura';
        Vendor_No_Caption_Control1100292028Lbl: Label 'Nº proveedor';
        NameCaption_Control1100292029Lbl: Label 'Nombre';
        VAT_Registration_No_Caption_Control1100292030Lbl: Label 'CIF/NIF';
        Posting_DateCaption_Control1100292031Lbl: Label 'Fecha registro';
        Deduction_Base__LCY_Caption_Control1100292032Lbl: Label 'Base retención (DL)';
        DeductionCaption_Control1100292033Lbl: Label '% retención';
        Deduction_Amount__LCY_Caption_Control1100292034Lbl: Label 'Importe retención (DL)';
        MovReten: Record "EXC Retention Tax registers";
        CifActual: Text[20];
        SubClaveActual: option " ","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16";
        ClaveActual: option " ","A","B","C","D","E","F","G","H","I","J","K","L",,,,,,"19";
        TempCifs: Record 23 TEMPORARY;
        SoloPendiente: Boolean;
}
