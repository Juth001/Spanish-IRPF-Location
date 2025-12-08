namespace ScriptumVita.IRPF;
tableextension 86309 "Purch. InvHeader_IRPF" extends "Purch. Inv. Header"
{
    fields
    {
        field(60500; "Tipo Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Type (IRPF)"."Código";
            //CaptionML = ENU = 'Type Perception', ESP = 'Tipo Percepcion';
            Caption = 'Tipo Percepcion'; //'Type Perception';
        }
        field(60501; "Clave Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Keys (IRPF)"."Código" WHERE("Cli/Prov" = CONST(Proveedor));
            //Caption = 'Key Perception', ESP = 'Clave Percepción';
            Caption = 'Clave Percepción'; //'Key Perception';
        }
        field(60502; "Importe IRPF"; Decimal)
        {
            editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line".Amount WHERE("Document No." = FIELD("No."), "Aplica Retencion" = const(true)));
        }
        field(60503; "Importe IVA incl.IRPF"; Decimal)
        {
            editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line"."Amount Including VAT" WHERE("Document No." = FIELD("No."), "Aplica Retencion" = const(true)));
        }
    }
}
