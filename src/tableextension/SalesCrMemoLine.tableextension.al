namespace Excelia.IRPF;
using Microsoft.Sales.History;
tableextension 86315 "Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(86300; "Perception Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Perception Type';
        }
        field(86301; "Perception key"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Customer));
            Caption = 'Perception key';
        }
        field(86302; "Deduction Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction Line';
        }
        field(86303; "Deduction Entry"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction Entry';
        }
        field(86304; "Retention Account"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Account';
        }
    }
}
