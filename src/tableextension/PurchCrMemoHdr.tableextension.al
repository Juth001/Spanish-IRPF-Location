namespace Excelia.IRPF;
using Microsoft.Purchases.History;

tableextension 86307 "Purch. Cr.MemoHdr" extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(86300; "Perception Type"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Type Perception';
            description = 'Type of perception applied to the credit memo.';
            tooltip = 'Type of perception applied to the credit memo.';
        }
        field(86301; "Perception Key"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Vendor));
            Caption = 'Key Perception';
            description = 'Key of perception applied to the credit memo.';
            tooltip = 'Key of perception applied to the credit memo.';
        }
        field(86302; "IRPF Amount"; Decimal)
        {
            editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line".Amount WHERE("Document No." = FIELD("No."), "Apply Deduction" = const(true)));
            description = 'Total amount of the perception applied to the credit memo, excluding VAT.';
            tooltip = 'Total amount of the perception applied to the credit memo, excluding VAT.';
        }
        field(86303; "IRPF Amount inc. VAT"; Decimal)
        {
            editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line"."Amount Including VAT" WHERE("Document No." = FIELD("No."), "Apply Deduction" = const(true)));
            description = 'Total amount of the perception applied to the credit memo, including VAT.';
            tooltip = 'Total amount of the perception applied to the credit memo, including VAT.';
        }
    }
}
