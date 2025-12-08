namespace ScriptumVita.IRPF;
tableextension 86301 "General Ledger Setup_IRPF" extends "General Ledger Setup"
{
    fields
    {
        field(60500; "Tipo perceptor liq."; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Type (IRPF)"."Código";
            //CaptionML = ESP = 'Tipo perceptor liq.', ENU = 'Type beneficiary liq.';
            Caption = 'Tipo perceptor liq.';
        }
        field(60501; "Clave percepción liq."; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Keys (IRPF)"."Código";
            //CaptionML = ENU = 'Key perception liq.', ESP = 'Clave percepción liq.';
            Caption = 'Clave percepción liq.'; //'Key perception liq.';
        }
        field(60502; "Libro retenciones"; code[10])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Deduction Template', ESP = 'Libro retenciones';
            Caption = 'Libro retenciones'; //'Deduction Template';
            TableRelation = "Gen. Journal Template".Name;
        }
        field(60503; "Sección retenciones"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Libro retenciones"));
            //CaptionML = ENU = 'Deductions Batch', ESP = 'Sección retenciones';
            Caption = 'Sección retenciones'; //'Deductions Batch';
        }
        field(60504; "Sección auxiliar retenciones"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Libro retenciones"));
            //CaptionML = ENU = 'Auxiliar Deductions Batch', ESP = 'Sección auxiliar retenciones';
            Caption = 'Sección auxiliar retenciones'; //'Auxiliar Deductions Batch';
        }
    }
}
