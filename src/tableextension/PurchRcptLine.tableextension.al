namespace Excelia.IRPF;
using Microsoft.Purchases.History;

tableextension 86312 "Purch. Rcpt Line" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(86300; "Deduction Entry"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction Entry';
        }
        field(86301; "Perception Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Perception Type';
        }
        field(86302; "Perception key"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Vendor));
            Caption = 'Perception key';
        }
        field(86303; "Deduction Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction Line';
        }
        field(86304; "Retention Account"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Account';
        }
    }
}
