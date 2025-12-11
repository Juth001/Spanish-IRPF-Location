namespace Excelia.IRPF;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.RoleCenters;

pageextension 86314 "EXC Order Proc. Role Center" extends "Order Processor Role Center"
{
    actions
    {
        addafter("Posted Documents")
        {
            group(IRPF)
            {
                Caption = 'IRPF';
                image = Journals;

                action(PerceptionType)
                {
                    ApplicationArea = All;
                    Caption = 'Perception Type';
                    RunObject = page "EXC Subform Perception Type";
                }
                action(PerceptionKeys)
                {
                    ApplicationArea = All;
                    Caption = 'Perception Keys';
                    RunObject = page "EXC Subform Perception Keys";
                }
                action(GeneralLedgSetup)
                {
                    ApplicationArea = All;
                    Caption = 'General Ledger Setup';
                    RunObject = Page "General Ledger Setup";
                }
                action(RetentionJournal)
                {
                    ApplicationArea = All;
                    Caption = 'Retention Journal';
                    RunObject = Page "EXC Retention Journal";
                }
                action(RetentionTaxRegisters)
                {
                    ApplicationArea = All;
                    Caption = 'Retention Tax Registers';
                    RunObject = Page "EXC Retention Tax Registers";
                }
                action(IRPFRetentions)
                {
                    ApplicationArea = All;
                    Caption = 'IRPF Retentions';
                    RunObject = report "IND Retenciones IRPF";
                }
                action(GenerateRetentions)
                {
                    ApplicationArea = All;
                    Caption = 'Generate Retentions';
                    //TODO: RunObject = report "IND Liquidar Retenciones";
                }
                action(ProvDecAnualReten)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor - IRPF Annual Dec.';
                    RunObject = report "SVT Prov - Dec. Anual_Reten";
                }
                action(ClientDecAnualReten)
                {
                    ApplicationArea = All;
                    Caption = 'Customer - IRPF Annual Dec.';
                    RunObject = report "EXC Client- Dec. Anual_Reten";
                }
            }
        }
    }
}
