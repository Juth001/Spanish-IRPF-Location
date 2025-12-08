namespace ScriptumVita.IRPF;
tableextension 86300 "Customer_IRPF" extends Customer
{
    fields
    {
        field(60500; "Importe Ret. Alquileres"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("IND Witholding Tax registers"."Importe retención" WHERE("Cli/Prov" = CONST(Cliente), "Nº Proveedor / Nº Cliente" = FIELD("No."), "Tipo Retención" = CONST(Alquiler)));
            //CaptionML = ENU = 'Amount retention.Rent', ESP = 'Importe Ret. Alquileres';
            Caption = 'Importe Ret. Alquileres'; //'Amount retention.Rent';
            Editable = false;
        }
        field(60501; "Importe Ret. Garantía"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("IND Witholding Tax registers"."Importe retención" WHERE("Cli/Prov" = CONST(Cliente), "Nº Proveedor / Nº Cliente" = FIELD("No."), "Tipo Retención" = CONST(Garantía)));
            //CaptionML = ENU = 'Ret Amount. Guarantee', ESP = 'Importe Ret. Garantía';
            Caption = 'Importe Ret. Garantía'; //'Ret Amount. Guarantee';
            Editable = false;
        }
        field(60502; "Importe Ret. Profesional"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("IND Witholding Tax registers"."Importe retención" WHERE("Cli/Prov" = CONST(Cliente), "Nº Proveedor / Nº Cliente" = FIELD("No."), "Tipo Retención" = CONST(Alquiler)));
            //CaptionML = ENU = 'Amount professional retention', ESP = 'Importe Ret. Profesional';
            Caption = 'Importe Ret. Profesional'; //'Amount professional retention';
            Editable = false;
        }
        field(60503; "Importe Ret. Otros"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("IND Witholding Tax registers"."Importe retención" WHERE("Cli/Prov" = CONST(Cliente), "Nº Proveedor / Nº Cliente" = FIELD("No."), "Tipo Retención" = CONST(Otros)));
            //CaptionML = ENU = 'Amount retention others', ESP = 'Importe Ret. Otros';
            Caption = 'Importe Ret. Otros'; //'Amount retention others';
            Editable = false;
        }
        field(60504; "Tipo Percepción"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Type (IRPF)".Código;
            //CaptionML = ENU = 'Perception Type', ESP = 'Tipo Percepción';
            Caption = 'Tipo Percepción'; //'Perception Type';
        }
        field(60505; "Clave Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Keys (IRPF)"."Código" WHERE("Cli/Prov" = CONST(Cliente));
            //CaptionML = ENU = 'Key Perception', ESP = 'Clave Percepción';
            Caption = 'Clave Percepción'; //'Key Perception';
        }
    }
}
