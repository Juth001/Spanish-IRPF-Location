namespace Excelia.IRPF;

page 86301 "EXC Subform Perception Type"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "EXC Perception Type";
    Caption = 'Subform Perception Type';

    layout
    {
        area(Content)
        {
            repeater(Perception)
            {
                field("Código"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Descripción"; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
