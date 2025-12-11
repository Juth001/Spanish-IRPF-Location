namespace Excelia.IRPF;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Foundation.Reporting;
using Microsoft.Finance.Currency;

page 86302 "EXC Retention Journal"
{
    AutoSplitKey = true;
    Caption = 'Witholding Journal';
    DataCaptionFields = "Journal Batch Name";
    SourceTable = "Gen. Journal Line";
    UsageCategory = Lists;
    ApplicationArea = All;
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean;
                begin
                    CurrPage.SaveRecord();
                    GenJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate();
                begin
                    GenJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali();
                end;
            }
            repeater(Control1)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill No."; Rec."Bill No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate();
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnValidate();
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;

                    //TODO: Revisar si se deja o no el c¢digo comentado
                    // trigger OnAssistEdit();
                    // begin
                    //     ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date");
                    //     if ChangeExchangeRate.RUNMODAL() = ACTION::OK then Validate("Currency Factor", ChangeExchangeRate.GetParameter());
                    //     clear(ChangeExchangeRate);
                    // end;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Perception Type"; Rec."Perception Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Perception Key"; Rec."Perception Key")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Retention Base"; Rec."Retention Base")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Retention Amount"; Rec."Retention Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Retention %"; Rec."Retention %")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnValidate();
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    end;
                }
                field("Bal. Gen. Posting Type"; Rec."Bal. Gen. Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bal. Gen. Bus. Posting Group"; Rec."Bal. Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bal. Gen. Prod. Posting Group"; Rec."Bal. Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Applies-to Bill No."; Rec."Applies-to Bill No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bank Payment Type"; Rec."Bank Payment Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Recipient Bank Account"; Rec."Recipient Bank Account")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Direct Debit Mandate ID"; Rec."Direct Debit Mandate ID")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Control30)
            {
                fixed(Control1901776101)
                {
                    group("Account Name")
                    {
                        Caption = 'Account Name';

                        field(AccName; AccName)
                        {
                            ApplicationArea = Basic, Suite;
                            Editable = false;
                        }
                    }
                    group("Bal. Account Name")
                    {
                        Caption = 'Bal. Account Name';

                        field(BalAccName; BalAccName)
                        {
                            ApplicationArea = Basic, Suite;

                        }
                    }
                    group(Saldo)
                    {

                        Caption = 'Balance';

                        //TODO: Revisar si se deja o no el c¢digo comentado
                        // field(Balance; Balance + "Balance (LCY)" - xRec."Balance (LCY)")
                        // {
                        //     ApplicationArea = All;
                        //     AutoFormatType = 1;
                        //     Caption = 'Balance';
                        //     Editable = false;
                        //     ToolTip = 'Specifies the balance on the journal line.';
                        //     Visible = BalanceVisible;
                        // }
                    }
                    group("Saldo total")
                    {
                        Caption = 'Total Balance';

                        //TODO: Revisar si se deja o no el c¢digo comentado
                        // field(TotalBalance; TotalBalance + "Balance (LCY)" - xRec."Balance (LCY)")
                        // {
                        //     ApplicationArea = All;
                        //     AutoFormatType = 1;
                        //     Caption = 'Saldo total';
                        //     Editable = false;
                        //     ToolTip = 'Especifica la suma de saldos. '; 
                        //     Visible = TotalBalanceVisible;
                        // }
                    }
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("&Línea")
            {
                //CaptionML = ENU = '&Line',
                //            ESP = '&Línea';
                Caption = '&Línea'; //'&Line';
                Image = Line;

                action(Dimensions)
                {
                    ApplicationArea = Basic, Suite;
                    //CaptionML = ENU = 'Dimensions',
                    //            ESP = 'Dimensiones';
                    Caption = 'Dimensiones'; //'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';
                    //ToolTipML = ENU = 'View or edit dimensions, such as area, project, or department, that you can assign to journal lines to distribute costs and analyze transaction history.',
                    //            ESP = 'Permite ver o editar dimensiones, como el área, el proyecto o el departamento, que pueden asignarse a líneas de diario para distribuir costes y analizar el historial de transacciones.';
                    ToolTip = 'Permite ver o editar dimensiones, como el área, el proyecto o el departamento, que pueden asignarse a líneas de diario para distribuir costes y analizar el historial de transacciones.'; //'View or edit dimensions, such as area, project, or department, that you can assign to journal lines to distribute costs and analyze transaction history.';

                    trigger OnAction();
                    begin
                        //TODO: ShowDimensions;
                    end;
                }
            }
            group("&Cuenta")
            {
                //CaptionML = ENU = 'A&ccount',
                //            ESP = '&Cuenta';
                Caption = '&Cuenta'; //'A&ccount';
                Image = ChartOfAccounts;

                action(Card)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ficha'; //'Card';
                    //            ESP = 'Ficha';
                    Image = EditLines;
                    RunObject = Codeunit "Gen. Jnl.-Show Card";
                    ShortCutKey = 'Shift+F7';
                    //ToolTipML = ENU = 'View or change detailed information about the record that is being processed on the document or journal line.',
                    //            ESP = 'Permite ver o cambiar la información detallada sobre el registro que se está procesando en el documento o la línea del diario.';
                    ToolTip = 'Permite ver o cambiar la información detallada sobre el registro que se está procesando en el documento o la línea del diario.'; //'View or change detailed information about the record that is being processed on the document or journal line.';
                }
                action(LedgerEntries)
                {
                    ApplicationArea = Basic, Suite;
                    //CaptionML = ENU = 'Ledger E&ntries',
                    //            ESP = '&Movimientos';
                    Caption = '&Movimientos'; //'Ledger E&ntries';
                    RunObject = Codeunit "Gen. Jnl.-Show Entries";
                    ShortCutKey = 'Ctrl+F7';
                    //ToolTipML = ENU = 'View the history of transactions that have been posted for the selected record.',
                    //            ESP = 'Permite ver el historial de transacciones que se han registrado para el registro seleccionado.';
                    ToolTip = 'Permite ver el historial de transacciones que se han registrado para el registro seleccionado.'; //'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
        area(processing)
        {
            action("&Liquidar movs.")
            {
                ApplicationArea = Basic, Suite;
                //CaptionML = ENU = '&Apply Entries',
                //            ESP = '&Liquidar movs.';
                Caption = '&Liquidar movs.'; //'&Apply Entries';
                Ellipsis = true;
                Image = ApplyEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Codeunit "Gen. Jnl.-Apply";
                ShortCutKey = 'Shift+F11';
                //ToolTipML = ENU = 'Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.',
                //            ESP = 'Permite seleccionar uno o varios movimientos contables que desea liquidar en este registro para que los documentos registrados relacionados se cierren como pagados o reembolsados.';
                ToolTip = 'Permite seleccionar uno o varios movimientos contables que desea liquidar en este registro para que los documentos registrados relacionados se cierren como pagados o reembolsados.'; //'Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.';
            }
            group("&Registro")
            {
                //CaptionML = ENU = 'P&osting',
                //            ESP = '&Registro';
                Caption = '&Registro'; //'P&osting';
                Image = Post;

                action(Reconcile)
                {
                    ApplicationArea = Basic, Suite;
                    //CaptionML = ENU = 'Reconcile',
                    //            ESP = 'Control';
                    Caption = 'Control'; //'Reconcile';
                    Image = Reconcile;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F11';
                    //ToolTipML = ENU = 'View the balances on bank accounts that are marked for reconciliation, usually liquid accounts.',
                    //            ESP = 'Permite ver los saldos de las cuentas bancarias marcadas para la conciliación, normalmente cuentas de liquidez.';
                    ToolTip = 'Permite ver los saldos de las cuentas bancarias marcadas para la conciliación, normalmente cuentas de liquidez.'; //'View the balances on bank accounts that are marked for reconciliation, usually liquid accounts.';

                    trigger OnAction();
                    begin
                        GLReconcile.SetGenJnlLine(Rec);
                        GLReconcile.RUN;
                    end;
                }
                action(TestReport)
                {
                    ApplicationArea = Basic, Suite;
                    //CaptionML = ENU = 'Test Report',
                    //            ESP = 'Informe prueba';
                    Caption = 'Informe prueba'; //'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    //ToolTipML = ENU = 'Preview the resulting entries to see the consequences before you perform the actual posting.',
                    //            ESP = 'Permite obtener una vista previa de los movimientos resultantes para ver las consecuencias antes de proceder al registro real.';
                    ToolTip = 'Permite obtener una vista previa de los movimientos resultantes para ver las consecuencias antes de proceder al registro real.'; //'Preview the resulting entries to see the consequences before you perform the actual posting.';

                    trigger OnAction();
                    begin
                        ReportPrint.PrintGenJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic, Suite;
                    //CaptionML = ENU = 'P&ost',
                    //            ESP = '&Registrar';
                    Caption = '&Registrar'; //'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    //ToolTipML = ENU = 'Post the documents to indicate that they are ready to submit to the bank for payment or collection. ',
                    //            ESP = 'Registra los documentos para indicar que están preparados para enviar al banco para el pago o cobro.';
                    ToolTip = 'Registra los documentos para indicar que están preparados para enviar al banco para el pago o cobro.'; //'Post the documents to indicate that they are ready to submit to the bank for payment or collection. ';

                    trigger OnAction();
                    var
                        OldLinDiaCar: Record "Gen. Journal Line";
                        DocPost: Codeunit "Document-Post";
                    begin
                        clear(OldLinDiaCar);
                        OldLinDiaCar.COPY(Rec);
                        PostOk := false;
                        DocPost.PostLines(OldLinDiaCar, PostOk, false);
                        Rec := OldLinDiaCar;
                        //TODO: CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        if PostOk then begin
                            //TODO:  DeleteAll;
                            ClosingForbidden := false;
                            COMMIT();
                        end;
                        //TODO: MARKEDONLY(false);
                        CurrPage.UPDATE(false);
                    end;
                }
                action(PostandPrint)
                {
                    ApplicationArea = Basic, Suite;
                    //CaptionML = ENU = 'Post and &Print',
                    //            ESP = 'Registrar e &imprimir';
                    Caption = 'Registrar e &imprimir'; //'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    //ToolTipML = ENU = 'Post and then print the documents to indicate that they are ready to submit to the bank for payment or collection.',
                    //            ESP = 'Registra y después imprime los documentos para indicar que están preparados para enviar al banco para el pago o cobro.';
                    ToolTip = 'Registra y después imprime los documentos para indicar que están preparados para enviar al banco para el pago o cobro.'; //'Post and then print the documents to indicate that they are ready to submit to the bank for payment or collection.';

                    trigger OnAction();
                    var
                        OldLinDiaCar: Record "Gen. Journal Line";
                        DocPost: Codeunit "Document-Post";
                    begin
                        clear(OldLinDiaCar);
                        OldLinDiaCar.COPY(Rec);
                        PostOk := false;
                        DocPost.PostLines(OldLinDiaCar, PostOk, true);
                        Rec := OldLinDiaCar;
                        //TODO: CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        if PostOk then begin
                            //TODO:  DeleteAll;
                            ClosingForbidden := false;
                            COMMIT();
                        end;
                        //TODO: MARKEDONLY(false);
                        CurrPage.UPDATE(false);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord();
    begin
        AfterGetCurrentRecord();
    end;

    trigger OnInit();
    begin
        TotalBalanceVisible := true;
        BalanceVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        UpdateBalance;
        //TODO: SetUpNewLine(xRec, Balance, BelowxRec);
        AfterGetCurrentRecord();
    end;

    trigger OnOpenPage();
    var
        JnlSelected: Boolean;
    begin
        if NOT LiqRetencion then begin
            BalAccName := '';
            if PassedCurrentJnlBatchName <> '' then CurrentJnlBatchName := PassedCurrentJnlBatchName;
            //TODO: OpenedFromBatch := ("Journal Batch Name" <> '') and ("Journal Template Name" = '');
            if OpenedFromBatch then begin
                //TODO: CurrentJnlBatchName := "Journal Batch Name";
                GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
                exit;
            end;
            GenJnlManagement.TemplateSelection(PAGE::"Cartera Journal", enum::"Gen. Journal Template Type"::Cartera, false, Rec, JnlSelected);

            if not JnlSelected then ERROR('');
            GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
        end
        else
            CurrentJnlBatchName := SeccionRet;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    var
        CarteraJnlForm: Page "Cartera Journal";
    begin
        if ClosingForbidden then begin
            MESSAGE(Text1100000);
            //TODO: CarteraJnlForm.SetJnlBatchName("Journal Batch Name");
            CarteraJnlForm.SETTABLEVIEW(Rec);
            CarteraJnlForm.SETRECORD(Rec);
            CarteraJnlForm.AllowClosing(true);
            CarteraJnlForm.RUNMODAL();
        end;
    end;

    var
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        GLReconcile: Page Reconciliation;
        ChangeExchangeRate: Page "Change Exchange Rate";
        CurrentJnlBatchName: Code[10];
        PassedCurrentJnlBatchName: Code[10];
        AccName: Text[50];
        BalAccName: Text[50];
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        ClosingForbidden: Boolean;
        PostOk: Boolean;
        OpenedFromBatch: Boolean;
        BalanceVisible: Boolean;
        TotalBalanceVisible: Boolean;
        SeccionRet: code[20];
        LiqRetencion: Boolean;
        Text1100000: Label 'Registre las líneas del Diario. Si no, podrían aparecer incoherencias entre los datos.';

    procedure LlamadaDesdeLiqRet(pSeccion: Code[20]);
    begin
        LiqRetencion := true;
        SeccionRet := pSeccion;
    end;

    local procedure UpdateBalance();
    begin
        GenJnlManagement.CalcBalance(Rec, xRec, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;

    procedure SetJnlBatchName(NewJnlBatchName: Code[10]);
    begin
        PassedCurrentJnlBatchName := NewJnlBatchName;
    end;

    procedure AllowClosing(FromBatch: Boolean);
    begin
        ClosingForbidden := FromBatch;
    end;

    local procedure CurrentJnlBatchNameOnAfterVali();
    begin
        CurrPage.SAVERECORD();
        GenJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.UPDATE(false);
    end;

    local procedure AfterGetCurrentRecord();
    begin
        xRec := Rec;
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        UpdateBalance();
    end;
}
