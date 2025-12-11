namespace Excelia.IRPF;
using Microsoft.Purchases.Vendor;

tableextension 86322 "EXC Vendor" extends Vendor
{
    fields
    {
        field(86300; "Amount retention.Rent"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("EXC Retention Tax registers"."Importe retención" WHERE("Cust/Vend" = const(Vendor), "Nº Proveedor / Nº Cliente" = FIELD("No."), "Tipo Retención" = const(Alquiler)));
            Caption = 'Amount retention.Rent';
            Editable = false;
        }
        field(86301; "Ret Amount. Guarantee"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("EXC Retention Tax registers"."Importe retención" WHERE("Cust/Vend" = const(Vendor), "Nº Proveedor / Nº Cliente" = FIELD("No."), "Tipo Retención" = const(Garantía)));
            Caption = 'Ret Amount. Guarantee';
            Editable = false;
        }
        field(86302; "Amount Professional Retention"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("EXC Retention Tax registers"."Importe retención" WHERE("Cust/Vend" = const(Vendor), "Nº Proveedor / Nº Cliente" = FIELD("No."), "Tipo Retención" = const(Profesionales)));
            Caption = 'Amount professional retention';
            Editable = false;
        }
        field(86303; "Amount retention others"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("EXC Retention Tax registers"."Importe retención" WHERE("Cust/Vend" = const(Vendor), "Nº Proveedor / Nº Cliente" = FIELD("No."), "Tipo Retención" = const(Otros)));
            Caption = 'Amount retention others';
            Editable = false;
        }
        field(86304; "Perception Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Perception Type';
        }
        field(86305; "Perception Key"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Vendor));
            Caption = 'Perception Key';
        }
    }
}
