namespace ScriptumVita.IRPF;
pageextension 86300 "Business Manager Role Center" extends "Business Manager Role Center"
{
    actions
    {
        //++ OT2-058558
        //addafter(SetupAndExtensions)
        addafter(Action41)
        //-- OT2-058558
        {
            group(IRPF)
            {
                Caption = 'IRPF';
                image = Journals;

                action(PerceptionType)
                {
                    ApplicationArea = All;
                    Caption = 'Tipo percepción'; //'Perception Type';
                    RunObject = page "IND Subform Perception Type";
                }
                action(PerceptionKeys)
                {
                    ApplicationArea = All;
                    Caption = 'Clave percepción'; //'Perception Keys';
                    RunObject = page "IND Subform Perception Keys";
                }
                action(GeneralLedgSetup)
                {
                    ApplicationArea = All;
                    Caption = 'Conf. diario general'; //'General Ledger Setup';
                    RunObject = Page "General Ledger Setup";
                }
                action(WitholdingJournal)
                {
                    ApplicationArea = All;
                    Caption = 'Diario retenciones';
                    RunObject = Page "IND Witholding Journal";
                }
                action(WitholdingTaxRegisters)
                {
                    ApplicationArea = All;
                    Caption = 'Movimientos de retención';
                    RunObject = Page "IND Witholding tax registers";
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
                    RunObject = report "IND Liquidar Retenciones";
                }
                action(ProvDecAnualReten)
                {
                    ApplicationArea = All;
                    Caption = 'Prov. - Dec. Anual Reten.';
                    RunObject = report "IND Prov - Dec. Anual_Reten";
                }
                action(INDClientDecAnualReten)
                {
                    ApplicationArea = All;
                    Caption = 'Cliente - Dec. Anual Reten.';
                    RunObject = report "IND Client- Dec. Anual_Reten";
                }
                /*
                    action(Modelo111)
                    {
                        ApplicationArea = All;
                        Caption = 'Modelo 111';
                        RunObject = report "IND Modelo 111";
                    }
                    action(Modelo190)
                    {
                        ApplicationArea = All;
                        Caption = 'Modelo 190';
                        RunObject = report "IND Modelo 190";
                    }*/
            }
        }
    }
}
