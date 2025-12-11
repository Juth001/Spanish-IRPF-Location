
namespace Excelia.IRPF;
using Microsoft.Sales.Customer;

tableextension 86300 "EXC Customer" extends Customer
{
    fields
    {
        field(86300; "Amount retention.Rent"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("EXC Retention Tax registers"."Importe retención" WHERE("Cust/Vend" = const(Customer), "Nº Proveedor / Nº Cliente" = FIELD("No."), "Tipo Retención" = const(Alquiler)));
            Caption = 'Amount retention.Rent';
            Editable = false;
        }
        field(86301; "Ret Amount. Guarantee"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("EXC Retention Tax registers"."Importe retención" WHERE("Cust/Vend" = const(Customer), "Nº Proveedor / Nº Cliente" = FIELD("No."), "Tipo Retención" = const(Garantía)));
            Caption = 'Ret Amount. Guarantee';
            Editable = false;
        }
        field(86302; "Amount professional retention"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("EXC Retention Tax registers"."Importe retención" WHERE("Cust/Vend" = const(Customer), "Nº Proveedor / Nº Cliente" = FIELD("No."), "Tipo Retención" = const(Alquiler)));
            Caption = 'Amount professional retention';
            Editable = false;
        }
        field(86303; "Amount retention others"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("EXC Retention Tax registers"."Importe retención" WHERE("Cust/Vend" = const(Customer), "Nº Proveedor / Nº Cliente" = FIELD("No."), "Tipo Retención" = const(Otros)));
            Caption = 'Amount retention others';
            Editable = false;
        }
        field(86304; "Perception Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Perception Type';
        }
        field(86305; "Key Perception"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Customer));
            Caption = 'Key Perception';
        }
    }
}
