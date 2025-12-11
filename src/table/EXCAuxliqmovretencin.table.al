namespace Excelia.IRPF;
using Microsoft.Finance.GeneralLedger.Journal;

table 86300 "EXC Aux. liq mov. retención"
{
    fields
    {
        field(86300; "Journal Template Name"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Template Name';
            Editable = false;
            TableRelation = "Gen. Journal Template";
        }
        field(86301; "Journal Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Batch Name';
            Editable = false;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Batch Name"));
        }
        field(86302; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
            Editable = false;
        }
        field(86303; "Deduction Entry"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction Entry';
            Editable = false;
        }
        field(86304; "Amount to Apply"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount to Apply';
        }
        field(86305; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(86306; "User Id."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'User Id.';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.", "Deduction Entry")
        {
            Clustered = true;
        }
    }
}
