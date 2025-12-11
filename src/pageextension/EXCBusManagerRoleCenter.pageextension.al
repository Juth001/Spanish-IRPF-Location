namespace Excelia.IRPF;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.RoleCenters;

pageextension 86300 "EXC Bus. Manager Role Center" extends "Business Manager Role Center"
{
    actions
    {
        addafter(Action41)

        {
            group(IRPF)
            {
                Caption = 'IRPF';
                image = Journals;

                action(PerceptionType)
                {
                    ApplicationArea = All;
                    Caption = 'Tipo percepción';
                    RunObject = page "EXC Subform Perception Type";
                }
                action(PerceptionKeys)
                {
                    ApplicationArea = All;
                    Caption = 'Clave percepción';
                    RunObject = page "EXC Subform Perception Keys";
                }
                action(GeneralLedgSetup)
                {
                    ApplicationArea = All;
                    Caption = 'Conf. diario general';
                    RunObject = Page "General Ledger Setup";
                }
                action(WitholdingJournal)
                {
                    ApplicationArea = All;
                    Caption = 'Diario retenciones';
                    RunObject = Page "EXC Retention Journal";
                }
                action(WitholdingTaxRegisters)
                {
                    ApplicationArea = All;
                    Caption = 'Movimientos de retención';
                    RunObject = Page "EXC Retention Tax Registers";
                }
                action(RetencionesIRPF)
                {
                    ApplicationArea = All;
                    Caption = 'Retenciones IRPF';
                    RunObject = report "IND Retenciones IRPF";
                }
                action(GenerateWithholding)
                {
                    ApplicationArea = All;
                    Caption = 'Liquidar Retenciones';
                    //TODO: RunObject = report "IND Liquidar Retenciones";
                }
                action(ProvDecAnualReten)
                {
                    ApplicationArea = All;
                    Caption = 'Prov. - Dec. Anual Reten.';
                    RunObject = report "SVT Prov - Dec. Anual_Reten";
                }
                action(INDClientDecAnualReten)
                {
                    ApplicationArea = All;
                    Caption = 'Cliente - Dec. Anual Reten.';
                    RunObject = report "EXC Client- Dec. Anual_Reten";
                }
            }
        }
    }
}
