namespace Excelia.IRPF;
using Microsoft.Finance.GeneralLedger.Account;
tableextension 86303 "G/L Account" extends "G/L Account"
{
    fields
    {
        field(86300; "Retention Account Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Vendor","Customer";
            Caption = 'Account type Deduction';
            OptionCaption = ' ,Vendor,Customer';
        }
    }
}
