namespace ScriptumVita.IRPF;
page 86301 "IND Subform Perception Type"
{
    // version INDRA
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "IND Perception Type (IRPF)";
    //CaptionML = ENU = 'Subform Perception Type', ESP = 'Tipos de Percepción';
    Caption = 'Subform Perception Type';

    layout
    {
        area(Content)
        {
            repeater(Perception)
            {
                field("Código"; "Código")
                {
                    ApplicationArea = All;
                }
                field("Descripción"; "Descripción")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
