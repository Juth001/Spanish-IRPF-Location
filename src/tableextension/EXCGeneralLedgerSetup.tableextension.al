namespace Excelia.IRPF;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GeneralLedger.Journal;

tableextension 86301 "EXC General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(86300; "Type beneficiary liq."; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Type beneficiary liq.';
        }
        field(86301; "Key perception liq."; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code;
            Caption = 'Key perception liq.';
        }
        field(86302; "Retention Journal Template"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Journal Template';
            TableRelation = "Gen. Journal Template".Name;
        }
        field(86303; "Retention Batch"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name WHERE("journal template name" = FIELD("Retention Journal Template"));
            Caption = 'Retention Batch';
        }
        field(86304; "Retention Aux. Batch"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name WHERE("journal template name" = FIELD("Retention Journal Template"));
            Caption = 'Retention Aux. Batch';
        }
    }
}
