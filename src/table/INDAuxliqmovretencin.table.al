namespace ScriptumVita.IRPF;
table 86300 "IND Aux. liq mov. retención"
{
    // version INDRA
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Journal Template Name', ESP = 'Nombre libro diario';
            Caption = 'Nombre libro diario'; //'Journal Template Name';
            Editable = false;
            TableRelation = "Gen. Journal Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Journal Batch Name', ESP = 'Nombre sección diario';
            Caption = 'Nombre sección diario'; //'Journal Batch Name';
            Editable = false;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Batch Name"));
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Line No.', ESP = 'Nº línea';
            Caption = 'Nº línea'; //'Line No.';
            Editable = false;
        }
        field(4; "Mov.retención"; Integer)
        {
            DataClassification = CustomerContent;
            //CaptionML = ESP = 'Mov.retención';
            Caption = 'Mov.retención';
            Editable = false;
        }
        field(5; "Importe a liquidar"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Importe a liquidar';
        }
        field(6; "Nº documento"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nº documento'; //'Document No.';
        }
        field(7; "Id.usuario"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Id. usuario'; //'User Id.';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.", "Mov.retención")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
    end;

    trigger OnRename()
    begin
    end;
}
