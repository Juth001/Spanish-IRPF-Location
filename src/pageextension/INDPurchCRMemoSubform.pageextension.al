namespace ScriptumVita.IRPF;
pageextension 86308 "IND Purch.CRMemo.Subform" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Porc.IRPF"; "Porc.IRPF")
            {
                ApplicationArea = All;
            }
            field("Aplica Retencion"; "Aplica Retencion")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Control23)
        {
            field(BaseIRPF; BaseIRPF)
            {
                Caption = 'Base IRPF';
                ApplicationArea = All;
                Editable = false;
            }
            field(PercIRPF; PercIRPF)
            {
                Caption = '% IRPF';
                ApplicationArea = All;
                Editable = false;
            }
            field(AmountIRPF; AmountIRPF)
            {
                Caption = 'Importe IRPF';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    var
        BaseIRPF: Decimal;
        AmountIRPF: Decimal;
        PercIRPF: Decimal;
        PurchHeader: record "Purchase Header";

    trigger OnAfterGetRecord()
    var
        PurchLine: Record "Purchase Line";
        ClaveRet: Record "IND Perception Keys (IRPF)";
        Imp: Decimal;
        ImpIva: Decimal;
    begin
        PurchHeader.GET("Document Type", "Document No.");
        //291220>> cambios para calculo cuando la factura es manual y la linea de la retencion se calcula al registrar
        /*
        PurchLine.SetRange("Document No.", Rec."Document No.");
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Lín. retención", true);
        if PurchLine.FindFirst() then begin
            BaseIRPF := PurchLine.Quantity;
            PercIRPF := (-100) * PurchLine."Direct Unit Cost";
            AmountIRPF := (-1) * PurchLine.Amount;
        end;
        */
        IF ClaveRet.GET(PurchHeader."Clave Percepción") then begin
            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type", Rec."Document Type");
            PurchLine.SETRANGE("Document No.", Rec."Document No.");
            PurchLine.setrange("Aplica Retencion", true);
            PurchLine.SETRANGE("Lín. retención", FALSE);
            IF PurchLine.FIND('-') THEN
                REPEAT //Correccion importes 030221>>
                    //Correccion importes 01/02/21>>
                    //Imp += PurchLine."Line Amount";
                    Imp += PurchLine."VAT Base Amount";
                    /*
                    if PurchLine."Pmt. Discount Amount" <> 0 then
                        Imp += PurchLine."Line Amount" - PurchLine."Pmt. Discount Amount"
                    else
                        Imp += PurchLine."Line Amount";
                        */
                    //Correccion importes 01/02/21<<
                    //Correccion importes 030221<<
                    ImpIva += PurchLine."Amount Including VAT";
                UNTIL (PurchLine.NEXT = 0);
            IF ClaveRet."Tipo cálculo" = ClaveRet."Tipo cálculo"::Base THEN
                BaseIRPF := Imp
            ELSE
                BaseIRPF := ImpIva;
            PercIRPF := ClaveRet."% Retención";
            AmountIRPF := BaseIRPF * PercIRPF / 100;
        end;
    end;
}
