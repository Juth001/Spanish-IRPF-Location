namespace ScriptumVita.IRPF;
tableextension 86316 "Sales Header_IRPF" extends "Sales Header"
{
    fields
    {
        field(60502; "Tipo Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Type (IRPF)"."Código";
            //CaptionML = ENU = 'Type Perception', ESP = 'Tipo Percepcion';
            Caption = 'Tipo Percepcion'; //'Type Perception';
        }
        field(60503; "Clave Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Keys (IRPF)"."Código" WHERE("Cli/Prov" = CONST(Cliente));
            //CaptionML = ENU = 'Key Perception', ESP = 'Clave Percepción';
            Caption = 'Clave Percepción'; //'Key Perception';
        }
    }
    procedure CreaLinRetencionPedido(SalesHeader: record "Sales Header")
    var
        ClaveRet: Record "IND Perception Keys (IRPF)";
        GrContableProv: Record "Vendor Posting Group";
        NoLin: Integer;
        Imp: Decimal;
        AuxLinVenta: Record "Sales Line";
        ImpIva: Decimal;
        LVenta: Record "Sales Line";
        QuantToInvo: Decimal;
    begin
        //++ OT2-051963
        //Esta función se encargar  de generar automaticamente la línea de la retención cuando es un pedido y se factura
        // WITH LVenta DO BEGIN
        //     IF ClaveRet.GET(SalesHeader."Clave Percepción") THEN BEGIN
        //         CLEAR(LVenta);
        //         "Document Type" := SalesHeader."Document Type";
        //         VALIDATE("Document No.", SalesHeader."No.");
        //         NoLin := TraerNoLinea + 10000;
        //         VALIDATE("Line No.", NoLin);
        //         INSERT;
        //         VALIDATE("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        //         Type := Type::"G/L Account";
        //         ClaveRet.TESTFIELD("Cta. retención");
        //         VALIDATE("No.", ClaveRet."Cta. retención");
        //         VALIDATE("Tipo Percepción", SalesHeader."Tipo Percepción");
        //         VALIDATE("Clave Percepción", SalesHeader."Clave Percepción");
        //         VALIDATE("Lín. retención", TRUE);
        //         AuxLinVenta.RESET;
        //         AuxLinVenta.SETRANGE("Document Type", SalesHeader."Document Type");
        //         AuxLinVenta.SETRANGE("Document No.", SalesHeader."No.");
        //         AuxLinVenta.SETRANGE("Lín. retención", FALSE);
        //         IF AuxLinVenta.FIND('-') THEN
        //             REPEAT
        //                 CLEAR(QuantToInvo);
        //                 //TECNOCOM - TecnoRet - si hace este codigo no rellena la cantidad
        //                 IF ABS(AuxLinVenta."Quantity Shipped" - AuxLinVenta."Quantity Invoiced") <
        //                    ABS(AuxLinVenta."Qty. to Invoice")
        //                 THEN BEGIN
        //                     QuantToInvo := AuxLinVenta."Quantity Shipped" - AuxLinVenta."Quantity Invoiced";
        //                 END;
        //                 IF QuantToInvo = 0 THEN
        //                     QuantToInvo := AuxLinVenta."Qty. to Invoice";
        //                 Imp += ROUND(QuantToInvo * AuxLinVenta."Unit Price", 0.01);
        //                 ImpIva += ROUND((Imp + Imp * (AuxLinVenta."VAT %" + AuxLinVenta."EC %") / 100), 0.01);
        //             UNTIL (AuxLinVenta.NEXT = 0);
        //         IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
        //             VALIDATE(Quantity, Imp)
        //         ELSE
        //             VALIDATE(Quantity, ImpIva);
        //         VALIDATE("Unit Price", -(ClaveRet."% Retención" / 100));
        //         VALIDATE("Bill-to Customer No.", SalesHeader."Bill-to Customer No.");
        //         "Currency Code" := SalesHeader."Currency Code";
        //         VALIDATE("Job No.", '');
        //         "Outstanding Quantity" := 0;
        //         "Qty. to Ship" := 0;
        //         "Qty. Shipped Not Invoiced" := Quantity;
        //         "Quantity Shipped" := Quantity;
        //         "Quantity Invoiced" := 0;
        //         "Outstanding Qty. (Base)" := 0;
        //         "Qty. to Invoice (Base)" := "Quantity (Base)";
        //         "Qty. to Ship (Base)" := 0;
        //         "Qty. Shipped Not Invd. (Base)" := "Quantity (Base)";
        //         "Qty. Shipped (Base)" := "Quantity (Base)";
        //         "Qty. Invoiced (Base)" := 0;
        //         "Outstanding Amount" := 0;
        //         "Outstanding Amount (LCY)" := 0;
        //         MODIFY;
        //     END;
        // END;
        IF ClaveRet.GET(SalesHeader."Clave Percepción") THEN BEGIN
            CLEAR(LVenta);
            LVenta."Document Type" := SalesHeader."Document Type";
            LVenta.VALIDATE("Document No.", SalesHeader."No.");
            NoLin := LVenta.TraerNoLinea + 10000;
            LVenta.VALIDATE("Line No.", NoLin);
            LVenta.INSERT;
            LVenta.VALIDATE("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            LVenta.Type := LVenta.Type::"G/L Account";
            ClaveRet.TESTFIELD("Cta. retención");
            LVenta.VALIDATE("No.", ClaveRet."Cta. retención");
            LVenta.VALIDATE("Tipo Percepción", SalesHeader."Tipo Percepción");
            LVenta.VALIDATE("Clave Percepción", SalesHeader."Clave Percepción");
            LVenta.VALIDATE("Lín. retención", TRUE);
            AuxLinVenta.RESET;
            AuxLinVenta.SETRANGE("Document Type", SalesHeader."Document Type");
            AuxLinVenta.SETRANGE("Document No.", SalesHeader."No.");
            AuxLinVenta.SETRANGE("Lín. retención", FALSE);
            IF AuxLinVenta.FIND('-') THEN
                REPEAT
                    CLEAR(QuantToInvo);
                    //TECNOCOM - TecnoRet - si hace este codigo no rellena la cantidad
                    IF ABS(AuxLinVenta."Quantity Shipped" - AuxLinVenta."Quantity Invoiced") < ABS(AuxLinVenta."Qty. to Invoice") THEN BEGIN
                        QuantToInvo := AuxLinVenta."Quantity Shipped" - AuxLinVenta."Quantity Invoiced";
                    END;
                    IF QuantToInvo = 0 THEN QuantToInvo := AuxLinVenta."Qty. to Invoice";
                    Imp += ROUND(QuantToInvo * AuxLinVenta."Unit Price", 0.01);
                    ImpIva += ROUND((Imp + Imp * (AuxLinVenta."VAT %" + AuxLinVenta."EC %") / 100), 0.01);
                UNTIL (AuxLinVenta.NEXT = 0);
            IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
                LVenta.VALIDATE(Quantity, Imp)
            ELSE
                LVenta.VALIDATE(Quantity, ImpIva);
            LVenta.VALIDATE("Unit Price", -(ClaveRet."% Retención" / 100));
            LVenta.VALIDATE("Bill-to Customer No.", SalesHeader."Bill-to Customer No.");
            LVenta."Currency Code" := SalesHeader."Currency Code";
            LVenta.VALIDATE("Job No.", '');
            LVenta."Outstanding Quantity" := 0;
            LVenta."Qty. to Ship" := 0;
            LVenta."Qty. Shipped Not Invoiced" := LVenta.Quantity;
            LVenta."Quantity Shipped" := LVenta.Quantity;
            LVenta."Quantity Invoiced" := 0;
            LVenta."Outstanding Qty. (Base)" := 0;
            LVenta."Qty. to Invoice (Base)" := LVenta."Quantity (Base)";
            LVenta."Qty. to Ship (Base)" := 0;
            LVenta."Qty. Shipped Not Invd. (Base)" := LVenta."Quantity (Base)";
            LVenta."Qty. Shipped (Base)" := LVenta."Quantity (Base)";
            LVenta."Qty. Invoiced (Base)" := 0;
            LVenta."Outstanding Amount" := 0;
            LVenta."Outstanding Amount (LCY)" := 0;
            LVenta.MODIFY;
            //-- OT2-051963
        END;
    end;
}
