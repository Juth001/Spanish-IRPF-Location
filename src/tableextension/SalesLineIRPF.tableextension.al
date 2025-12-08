namespace ScriptumVita.IRPF;
tableextension 86319 "Sales Line_IRPF" extends "Sales Line"
{
    fields
    {
        field(60500; "Tipo Percepción"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Type (IRPF)"."Código";
            //CaptionML = ENU = 'Perception Type', ESP = 'Tipo Percepción';
            Caption = 'Tipo Percepción'; //'Perception Type';
        }
        field(60501; "Clave Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Keys (IRPF)"."Código" WHERE("Cli/Prov" = CONST(Cliente));
            //CaptionML = ENU = 'Perception key', ESP = 'Clave Percepción';
            Caption = 'Clave Percepción'; //'Perception key';
        }
        field(60502; "Lín. retención"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            //CaptionML = ENU = 'Deduction Line', ESP = 'Lín. retención';
            Caption = 'Lín. retención'; //'Deduction Line';
        }
        field(60503; "Mov. retención"; Integer)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Deduction Entry', ESP = 'Mov. retención';
            Caption = 'Mov. retención'; //'Deduction Entry';
        }
        field(60504; "Cuenta de Retención"; Boolean)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Retention Account', ESP = 'Cuenta de Retención';
            Caption = 'Cuenta de Retención'; //'Retention Account';
            Editable = false;
        }
    }
    procedure CrearLinRetencion(LVenta: record "Sales Line")
    var
        ClaveRet: Record "IND Perception Keys (IRPF)";
        GrContableProv: Record "Vendor Posting Group";
        NoLin: Integer;
        Imp: Decimal;
        AuxLinVenta: Record "Sales Line";
        ImpIva: Decimal;
        Ventana: Dialog;
        SeleccionRet: Integer;
        LinRetencion: Integer;
    begin
        //Esta función se encargar  de generar automaticamente la línea de la retención.
        SalesHeader2.GET("Document Type", "Document No.");
        // WITH LVenta DO BEGIN
        //     GetSalesHeader;
        //     //Cogemos el registro de la clave de retención.
        //     IF ClaveRet.GET(SalesHeader2."Clave Percepción") THEN BEGIN
        //         CLEAR(SeleccionRet);
        //         CLEAR(LinRetencion);
        //         //Compruebo si ya hay alguna línea de retención
        //         AuxLinVenta.RESET;
        //         AuxLinVenta.SETRANGE("Document Type", SalesHeader2."Document Type");
        //         AuxLinVenta.SETRANGE("Document No.", SalesHeader2."No.");
        //         AuxLinVenta.SETRANGE("Lín. retención", TRUE);
        //         IF AuxLinVenta.FINDLAST THEN BEGIN
        //             SeleccionRet := STRMENU(TextRet0001, 2);
        //             LinRetencion := AuxLinVenta."Line No.";
        //         END;
        //         CLEAR(LVenta);
        //         INIT;
        //         "Document Type" := SalesHeader2."Document Type";
        //         VALIDATE("Document No.", SalesHeader2."No.");
        //         NoLin := TraerNoLinea + 10000;
        //         VALIDATE("Line No.", NoLin);
        //         VALIDATE("Sell-to Customer No.", SalesHeader2."Sell-to Customer No.");
        //         Type := Type::"G/L Account";
        //         ClaveRet.TESTFIELD("Cta. retención");
        //         VALIDATE("No.", ClaveRet."Cta. retención");
        //         IF SeleccionRet = 1 THEN BEGIN
        //             AuxLinVenta.RESET;
        //             AuxLinVenta.SETRANGE("Document Type", SalesHeader2."Document Type");
        //             AuxLinVenta.SETRANGE("Document No.", SalesHeader2."No.");
        //             AuxLinVenta.SETRANGE("Lín. retención", FALSE);
        //             IF AuxLinVenta.FIND('-') THEN
        //                 REPEAT
        //                     Imp += AuxLinVenta."Line Amount";
        //                     ImpIva += AuxLinVenta."Amount Including VAT";
        //                 UNTIL (AuxLinVenta.NEXT = 0);
        //         END
        //         ELSE BEGIN
        //             //La retencion se aplica a las líneas a partir de la £ltima línea de retencion
        //             AuxLinVenta.RESET;
        //             AuxLinVenta.SETRANGE("Document Type", SalesHeader2."Document Type");
        //             AuxLinVenta.SETRANGE("Document No.", SalesHeader2."No.");
        //             AuxLinVenta.SETFILTER("Line No.", '>%1', LinRetencion);
        //             IF AuxLinVenta.FINDSET THEN
        //                 REPEAT
        //                     Imp += AuxLinVenta."Line Amount";
        //                     ImpIva += AuxLinVenta."Amount Including VAT";
        //                 UNTIL AuxLinVenta.NEXT = 0;
        //         END;
        //         IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
        //             VALIDATE(Quantity, Imp)
        //         ELSE
        //             VALIDATE(Quantity, ImpIva);
        //         VALIDATE("Unit Price", -ClaveRet."% Retención" / 100);
        //         VALIDATE(LVenta."Bill-to Customer No.", SalesHeader2."Bill-to Customer No.");
        //         VALIDATE("Tipo Percepción", SalesHeader2."Tipo Percepción");
        //         VALIDATE("Clave Percepción", SalesHeader2."Clave Percepción");
        //         VALIDATE("Lín. retención", TRUE);
        //         "Currency Code" := SalesHeader2."Currency Code";
        //         VALIDATE("Job No.", '');
        //         INSERT;
        //     END;
        // END;
        GetSalesHeader;
        //Cogemos el registro de la clave de retención.
        IF ClaveRet.GET(SalesHeader2."Clave Percepción") THEN BEGIN
            CLEAR(SeleccionRet);
            CLEAR(LinRetencion);
            //Compruebo si ya hay alguna línea de retención
            AuxLinVenta.RESET;
            AuxLinVenta.SETRANGE("Document Type", SalesHeader2."Document Type");
            AuxLinVenta.SETRANGE("Document No.", SalesHeader2."No.");
            AuxLinVenta.SETRANGE("Lín. retención", TRUE);
            IF AuxLinVenta.FINDLAST THEN BEGIN
                SeleccionRet := STRMENU(TextRet0001, 2);
                LinRetencion := AuxLinVenta."Line No.";
            END;
            CLEAR(LVenta);
            LVenta.INIT;
            LVenta."Document Type" := SalesHeader2."Document Type";
            LVenta.VALIDATE("Document No.", SalesHeader2."No.");
            NoLin := TraerNoLinea + 10000;
            LVenta.VALIDATE("Line No.", NoLin);
            LVenta.VALIDATE("Sell-to Customer No.", SalesHeader2."Sell-to Customer No.");
            LVenta.Type := LVenta.Type::"G/L Account";
            ClaveRet.TESTFIELD("Cta. retención");
            LVenta.VALIDATE("No.", ClaveRet."Cta. retención");
            IF SeleccionRet = 1 THEN BEGIN
                AuxLinVenta.RESET;
                AuxLinVenta.SETRANGE("Document Type", SalesHeader2."Document Type");
                AuxLinVenta.SETRANGE("Document No.", SalesHeader2."No.");
                AuxLinVenta.SETRANGE("Lín. retención", FALSE);
                IF AuxLinVenta.FIND('-') THEN
                    REPEAT
                        Imp += AuxLinVenta."Line Amount";
                        ImpIva += AuxLinVenta."Amount Including VAT";
                    UNTIL (AuxLinVenta.NEXT = 0);
            END
            ELSE BEGIN
                //La retencion se aplica a las líneas a partir de la £ltima línea de retencion
                AuxLinVenta.RESET;
                AuxLinVenta.SETRANGE("Document Type", SalesHeader2."Document Type");
                AuxLinVenta.SETRANGE("Document No.", SalesHeader2."No.");
                AuxLinVenta.SETFILTER("Line No.", '>%1', LinRetencion);
                IF AuxLinVenta.FINDSET THEN
                    REPEAT
                        Imp += AuxLinVenta."Line Amount";
                        ImpIva += AuxLinVenta."Amount Including VAT";
                    UNTIL AuxLinVenta.NEXT = 0;
            END;
            IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
                LVenta.VALIDATE(Quantity, Imp)
            ELSE
                LVenta.VALIDATE(Quantity, ImpIva);
            LVenta.VALIDATE("Unit Price", -ClaveRet."% Retención" / 100);
            LVenta.VALIDATE(LVenta."Bill-to Customer No.", SalesHeader2."Bill-to Customer No.");
            LVenta.VALIDATE("Tipo Percepción", SalesHeader2."Tipo Percepción");
            LVenta.VALIDATE("Clave Percepción", SalesHeader2."Clave Percepción");
            LVenta.VALIDATE("Lín. retención", TRUE);
            LVenta."Currency Code" := SalesHeader2."Currency Code";
            LVenta.VALIDATE("Job No.", '');
            LVenta.INSERT;
        END;
    END;

    procedure TraerNoLinea(): integer
    var
        AuxLinVenta: record "Sales Line";
        SalesHeader: record "Sales Header";
    begin
        //GetSalesHeader;
        SalesHeader2.GET("Document Type", "Document No.");
        AuxLinVenta.RESET;
        AuxLinVenta.SETRANGE("Document Type", SalesHeader2."Document Type");
        AuxLinVenta.SETRANGE("Document No.", SalesHeader2."No.");
        IF AuxLinVenta.FINDLAST THEN
            EXIT(AuxLinVenta."Line No.")
        ELSE
            EXIT(0);
    end;

    procedure CrearLinRetencion2(LVenta: record "Sales Line"; ImpRetenInterface: Decimal)
    var
        ClaveRet: Record "IND Perception Keys (IRPF)";
        GrContableProv: Record "Vendor Posting Group";
        NoLin: Integer;
        Imp: Decimal;
        AuxLinVenta: Record "Sales Line";
        ImpIva: Decimal;
        Ventana: Dialog;
        SeleccionRet: Integer;
        LinRetencion: Integer;
    begin
        //Esta función se encargar  de generar automaticamente la línea de la retención.
        // WITH LVenta DO BEGIN
        //     GetSalesHeader2;
        //     //Cogemos el registro de la clave de retención.
        //     IF ClaveRet.GET(SalesHeader2."Clave Percepción") THEN BEGIN
        //         CLEAR(SeleccionRet);
        //         CLEAR(LinRetencion);
        //         //Compruebo si ya hay alguna línea de retención
        //         AuxLinVenta.RESET;
        //         AuxLinVenta.SETRANGE("Document Type", SalesHeader2."Document Type");
        //         AuxLinVenta.SETRANGE("Document No.", SalesHeader2."No.");
        //         AuxLinVenta.SETRANGE("Lín. retención", TRUE);
        //         IF AuxLinVenta.FINDLAST THEN BEGIN
        //             SeleccionRet := STRMENU(TextRet0001, 2);
        //             LinRetencion := AuxLinVenta."Line No.";
        //         END;
        //         CLEAR(LVenta);
        //         INIT;
        //         "Document Type" := SalesHeader2."Document Type";
        //         VALIDATE("Document No.", SalesHeader2."No.");
        //         NoLin := TraerNoLinea + 10000;
        //         VALIDATE("Line No.", NoLin);
        //         VALIDATE("Sell-to Customer No.", SalesHeader2."Sell-to Customer No.");
        //         Type := Type::"G/L Account";
        //         ClaveRet.TESTFIELD("Cta. retención");
        //         VALIDATE("No.", ClaveRet."Cta. retención");
        //         /*
        //         IF SeleccionRet = 1 THEN BEGIN
        //           AuxLinVenta.RESET;
        //           AuxLinVenta.SETRANGE("Document Type", SalesHeader."Document Type");
        //           AuxLinVenta.SETRANGE("Document No.",SalesHeader."No.");
        //           AuxLinVenta.SETRANGE("Lín. retención", FALSE);
        //           IF AuxLinVenta.FIND('-') THEN REPEAT
        //             Imp += AuxLinVenta."Line Amount";
        //             ImpIva += AuxLinVenta."Amount Including VAT";
        //           UNTIL (AuxLinVenta.NEXT = 0);
        //         END
        //         ELSE BEGIN
        //           //La retencion se aplica a las líneas a partir de la £ltima línea de retencion
        //           AuxLinVenta.RESET;
        //           AuxLinVenta.SETRANGE("Document Type",SalesHeader."Document Type");
        //           AuxLinVenta.SETRANGE("Document No.",SalesHeader."No.");
        //           AuxLinVenta.SETFILTER("Line No.", '>%1', LinRetencion);
        //           IF AuxLinVenta.FINDSET THEN REPEAT
        //             Imp += AuxLinVenta."Line Amount";
        //             ImpIva += AuxLinVenta."Amount Including VAT";
        //           UNTIL AuxLinVenta.NEXT = 0;
        //         END;
        //         IF ClaveRet."Tipo c lculo" = ClaveRet."Tipo c lculo"::Base THEN
        //           VALIDATE(Quantity, Imp)
        //         ELSE
        //           VALIDATE(Quantity, ImpIva);
        //         */
        //         VALIDATE(Quantity, ImpRetenInterface / (-ClaveRet."% Retención" / 100));
        //         VALIDATE("Unit Price", -ClaveRet."% Retención" / 100);
        //         VALIDATE(LVenta."Bill-to Customer No.", SalesHeader2."Bill-to Customer No.");
        //         VALIDATE("Tipo Percepción", SalesHeader2."Tipo Percepción");
        //         VALIDATE("Clave Percepción", SalesHeader2."Clave Percepción");
        //         VALIDATE("Lín. retención", TRUE);
        //         "Currency Code" := SalesHeader2."Currency Code";
        //         VALIDATE("Job No.", '');
        //         INSERT;
        //     END;
        // end;
        GetSalesHeader2;
        //Cogemos el registro de la clave de retención.
        IF ClaveRet.GET(SalesHeader2."Clave Percepción") THEN BEGIN
            CLEAR(SeleccionRet);
            CLEAR(LinRetencion);
            //Compruebo si ya hay alguna línea de retención
            AuxLinVenta.RESET;
            AuxLinVenta.SETRANGE("Document Type", SalesHeader2."Document Type");
            AuxLinVenta.SETRANGE("Document No.", SalesHeader2."No.");
            AuxLinVenta.SETRANGE("Lín. retención", TRUE);
            IF AuxLinVenta.FINDLAST THEN BEGIN
                SeleccionRet := STRMENU(TextRet0001, 2);
                LinRetencion := AuxLinVenta."Line No.";
            END;
            CLEAR(LVenta);
            LVenta.INIT;
            LVenta."Document Type" := SalesHeader2."Document Type";
            LVenta.VALIDATE("Document No.", SalesHeader2."No.");
            NoLin := TraerNoLinea + 10000;
            LVenta.VALIDATE("Line No.", NoLin);
            LVenta.VALIDATE("Sell-to Customer No.", SalesHeader2."Sell-to Customer No.");
            LVenta.Type := LVenta.Type::"G/L Account";
            ClaveRet.TESTFIELD("Cta. retención");
            LVenta.VALIDATE("No.", ClaveRet."Cta. retención");
            /*
            IF SeleccionRet = 1 THEN BEGIN
              AuxLinVenta.RESET;
              AuxLinVenta.SETRANGE("Document Type", SalesHeader."Document Type");
              AuxLinVenta.SETRANGE("Document No.",SalesHeader."No.");
              AuxLinVenta.SETRANGE("Lín. retención", FALSE);
              IF AuxLinVenta.FIND('-') THEN REPEAT
                Imp += AuxLinVenta."Line Amount";
                ImpIva += AuxLinVenta."Amount Including VAT";
              UNTIL (AuxLinVenta.NEXT = 0);
            END
            ELSE BEGIN
              //La retencion se aplica a las líneas a partir de la £ltima línea de retencion
              AuxLinVenta.RESET;
              AuxLinVenta.SETRANGE("Document Type",SalesHeader."Document Type");
              AuxLinVenta.SETRANGE("Document No.",SalesHeader."No.");
              AuxLinVenta.SETFILTER("Line No.", '>%1', LinRetencion);
              IF AuxLinVenta.FINDSET THEN REPEAT
                Imp += AuxLinVenta."Line Amount";
                ImpIva += AuxLinVenta."Amount Including VAT";
              UNTIL AuxLinVenta.NEXT = 0;
            END;

            IF ClaveRet."Tipo c lculo" = ClaveRet."Tipo c lculo"::Base THEN
              VALIDATE(Quantity, Imp)
            ELSE
              VALIDATE(Quantity, ImpIva);
            */
            LVenta.VALIDATE(Quantity, ImpRetenInterface / (-ClaveRet."% Retención" / 100));
            LVenta.VALIDATE("Unit Price", -ClaveRet."% Retención" / 100);
            LVenta.VALIDATE(LVenta."Bill-to Customer No.", SalesHeader2."Bill-to Customer No.");
            LVenta.VALIDATE("Tipo Percepción", SalesHeader2."Tipo Percepción");
            LVenta.VALIDATE("Clave Percepción", SalesHeader2."Clave Percepción");
            LVenta.VALIDATE("Lín. retención", TRUE);
            LVenta."Currency Code" := SalesHeader2."Currency Code";
            LVenta.VALIDATE("Job No.", '');
            LVenta.INSERT;
        END;
    end;

    var
        TextRet0001: Label 'Aplicar a todas las líneas,Aplicar desde la última línea de retención';
        SalesHeader2: record "Sales Header";
        Currency2: record Currency;

    procedure GetSalesHeader2()
    begin
        TESTFIELD("Document No.");
        IF ("Document Type" <> SalesHeader2."Document Type") OR ("Document No." <> SalesHeader2."No.") THEN BEGIN
            SalesHeader2.GET("Document Type", "Document No.");
            IF SalesHeader2."Currency Code" = '' THEN
                Currency2.InitRoundingPrecision
            ELSE BEGIN
                SalesHeader2.TESTFIELD("Currency Factor");
                Currency2.GET(SalesHeader2."Currency Code");
                Currency2.TESTFIELD("Amount Rounding Precision");
            END;
        END;
    end;
}
