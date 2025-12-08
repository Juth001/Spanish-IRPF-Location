namespace ScriptumVita.IRPF;
namespace ScriptumVita.IRPF;
page 86302 "IND Witholding Journal"
{
    // version INDRA
    AutoSplitKey = true;
    //CaptionML = ENU = 'Witholding Journal',
    //            ESP = 'Diario retenciones';
    Caption = 'Diario retenciones'; //'Witholding Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Gen. Journal Line";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic, Suite;
                //CaptionML = ENU = 'Batch Name',
                //            ESP = 'Nombre sección';
                Caption = 'Nombre sección'; //'Batch Name';
                Lookup = true;
                //ToolTipML = ENU = 'Specifies the name of the journal batch.',
                //            ESP = 'Especifica el nombre de la sección de diario.';
                ToolTip = 'Especifica el nombre de la sección de diario.'; //'Specifies the name of the journal batch.';

                trigger OnLookup(var Text: Text): Boolean;
                begin
                    CurrPage.SAVERECORD;
                    GenJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(false);
                end;

                trigger OnValidate();
                begin
                    GenJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies when the journal line will be posted. ',
                    //            ESP = 'Especifica cuándo se va a registrar la línea del diario.';
                    ToolTip = 'Especifica cuándo se va a registrar la línea del diario.'; //'Specifies when the journal line will be posted. ';
                }
                field("Transaction No."; "Transaction No.")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the transaction number for the journal line being processed.',
                    //            ESP = 'Especifica el número de transacción de la línea del diario que se está procesando.';
                    ToolTip = 'Especifica el número de transacción de la línea del diario que se está procesando.'; //'Specifies the transaction number for the journal line being processed.';
                }
                field("Document Date"; "Document Date")
                {
                    //ToolTip = ENU = 'Specifies the date when the document represented by the journal line was created.',
                    //            ESP = 'Especifica la fecha en la que se creó el documento representado mediante la línea del diario.';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Especifica la fecha en la que se creó el documento representado mediante la línea del diario.'; //'Specifies the date when the document represented by the journal line was created.';
                    Visible = false;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the type of document in question.',
                    //            ESP = 'Especifica el tipo de documento en cuestión.';
                    ToolTip = 'Especifica el tipo de documento en cuestión.'; //'Specifies the type of document in question.';
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the number of the document in a posted bill group/payment order, from which this document was generated.',
                    //            ESP = 'Especifica el número del documento de una remesa o una orden de pago registradas con el que se generó este documento.';
                    ToolTip = 'Especifica el número del documento de una remesa o una orden de pago registradas con el que se generó este documento.'; //'Specifies the number of the document in a posted bill group/payment order, from which this document was generated.';
                }
                field("Bill No."; "Bill No.")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies a number for this bill generated from the journal.',
                    //            ESP = 'Especifica un número para este efecto que se crea desde el diario.';
                    ToolTip = 'Especifica un número para este efecto que se crea desde el diario.'; //'Specifies a number for this bill generated from the journal.';
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies how payment for the document must be submitted, such as bank transfer or check.',
                    //            ESP = 'Especifica cómo debe enviarse el pago para el documento, por ejemplo, un cheque o una transferencia bancaria.';
                    ToolTip = 'Especifica cómo debe enviarse el pago para el documento, por ejemplo, un cheque o una transferencia bancaria.'; //'Specifies how payment for the document must be submitted, such as bank transfer or check.';
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the due date of this document in a posted bill group/payment order.',
                    //            ESP = 'Especifica la fecha de vencimiento de este documento en una remesa o una orden de pago registradas.';
                    ToolTip = 'Especifica la fecha de vencimiento de este documento en una remesa o una orden de pago registradas.'; //'Specifies the due date of this document in a posted bill group/payment order.';
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.',
                    //            ESP = 'Especifica un número de documento que hace referencia al sistema de numeración del cliente o proveedor.';
                    ToolTip = 'Especifica un número de documento que hace referencia al sistema de numeración del cliente o proveedor.'; //'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                    Visible = false;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the account type, such as Customer.',
                    //            ESP = 'Especifica el tipo de cuenta, como Cliente.';
                    ToolTip = 'Especifica el tipo de cuenta, como Cliente.'; //'Specifies the account type, such as Customer.';

                    trigger OnValidate();
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    end;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the account number of the customer/vendor.',
                    //            ESP = 'Especifica el número de cuenta del cliente o del proveedor.';
                    ToolTip = 'Especifica el número de cuenta del cliente o del proveedor.'; //'Specifies the account number of the customer/vendor.';

                    trigger OnValidate();
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies a description of the record.',
                    //            ESP = 'Especifica una descripción del registro.';
                    ToolTip = 'Especifica una descripción del registro.'; //'Specifies a description of the record.';
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.',
                    //            ESP = 'Especifica el código de dimensión del acceso directo 1, que es uno de los dos códigos de dimensión globales que se configuran en la ventana Configuración de contabilidad.';
                    ToolTip = 'Especifica el código de dimensión del acceso directo 1, que es uno de los dos códigos de dimensión globales que se configuran en la ventana Configuración de contabilidad.'; //'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.',
                    //            ESP = 'Especifica el código de dimensión del acceso directo 2, que es uno de los dos códigos de dimensión globales que se configuran en la ventana Configuración de contabilidad.';
                    ToolTip = 'Especifica el código de dimensión del acceso directo 2, que es uno de los dos códigos de dimensión globales que se configuran en la ventana Configuración de contabilidad.'; //'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Business Unit Code"; "Business Unit Code")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies a code for the business unit, in case the company is part of a group.',
                    //            ESP = 'Especifica un código para la unidad de negocio, en caso de que la empresa forme parte de un grupo.';
                    ToolTip = 'Especifica un código para la unidad de negocio, en caso de que la empresa forme parte de un grupo.'; //'Specifies a code for the business unit, in case the company is part of a group.';
                    Visible = false;
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.',
                    //            ESP = 'Especifica el código del vendedor o el comprador vinculado a la venta o la compra en la línea del diario.';
                    ToolTip = 'Especifica el código del vendedor o el comprador vinculado a la venta o la compra en la línea del diario.'; //'Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.';
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the code of the currency for the amounts on the journal line.',
                    //            ESP = 'Especifica el código de la divisa de los importes que constan en la línea del diario.';
                    ToolTip = 'Especifica el código de la divisa de los importes que constan en la línea del diario.'; //'Specifies the code of the currency for the amounts on the journal line.';
                    Visible = false;

                    trigger OnAssistEdit();
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date");
                        if ChangeExchangeRate.RUNMODAL = ACTION::OK then VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("Currency Factor"; "Currency Factor")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the relationship between the additional reporting currency and the local currency. Amounts are recorded in both LCY and the additional reporting currency, using the relevant exchange rate and the currency factor.',
                    //            ESP = 'Especifica la relación entre la divisa adicional de informe y la divisa local. Los importes se registran tanto en la divisa local como en la divisa adicional de informe, mediante el tipo de cambio y el factor de divisa correspondientes.';
                    ToolTip = 'Especifica la relación entre la divisa adicional de informe y la divisa local. Los importes se registran tanto en la divisa local como en la divisa adicional de informe, mediante el tipo de cambio y el factor de divisa correspondientes.'; //'Specifies the relationship between the additional reporting currency and the local currency. Amounts are recorded in both LCY and the additional reporting currency, using the relevant exchange rate and the currency factor.';
                    Visible = false;
                }
                field("Gen. Posting Type"; "Gen. Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the typical posting type for the historical general ledger account.',
                    //            ESP = 'Especifica el tipo de registro típico para la cuenta histórica de contabilidad.';
                    ToolTip = 'Especifica el tipo de registro típico para la cuenta histórica de contabilidad.'; //'Specifies the typical posting type for the historical general ledger account.';
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.',
                    //            ESP = 'Especifica el tipo de comercio del cliente o el proveedor para vincular las transacciones realizadas para este socio comercial con la cuenta de contabilidad general correspondiente según la configuración de registro general.';
                    ToolTip = 'Especifica el tipo de comercio del cliente o el proveedor para vincular las transacciones realizadas para este socio comercial con la cuenta de contabilidad general correspondiente según la configuración de registro general.'; //'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.',
                    //            ESP = 'Especifica el tipo de producto del artículo para vincular las transacciones realizadas para este artículo con la cuenta de contabilidad general correspondiente según la configuración de registro general.';
                    ToolTip = 'Especifica el tipo de producto del artículo para vincular las transacciones realizadas para este artículo con la cuenta de contabilidad general correspondiente según la configuración de registro general.'; //'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the total amount (including VAT) that the journal line consists of, if it is a debit amount.',
                    //            ESP = 'Especifica el importe total (IVA incluido) de la línea del diario, si es un importe del debe.';
                    ToolTip = 'Especifica el importe total (IVA incluido) de la línea del diario, si es un importe del debe.'; //'Specifies the total amount (including VAT) that the journal line consists of, if it is a debit amount.';
                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the total amount (including VAT) that the journal line consists of, if it is a credit amount.',
                    //            ESP = 'Especifica el importe total (IVA incluido) de la línea del diario, si es un importe del haber.';
                    ToolTip = 'Especifica el importe total (IVA incluido) de la línea del diario, si es un importe del haber.'; //'Specifies the total amount (including VAT) that the journal line consists of, if it is a credit amount.';
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the total on the journal line.',
                    //            ESP = 'Especifica el total de la línea del diario.';
                    ToolTip = 'Especifica el total de la línea del diario.'; //'Specifies the total on the journal line.';
                    Visible = false;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Especifica el importe total de la línea del diario en la divisa local.'; //'Specifies the total amount on the journal line in LCY.';
                                                                                                        //ToolTipML = ENU = 'Specifies the total amount on the journal line in LCY.',
                                                                                                        //            ESP = 'Especifica el importe total de la línea del diario en la divisa local.';
                }
                field("Tipo Percepción"; "Tipo Percepción")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Clave percepción"; "Clave percepción")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Base retención"; "Base retención")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Importe retención"; "Importe retención")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Porcentaje retención"; "Porcentaje retención")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the code for the balancing account type that should be used in this journal line.',
                    //            ESP = 'Especifica el código del tipo de cuenta de contrapartida que se debe utilizar en esta línea del diario.';
                    ToolTip = 'Especifica el código del tipo de cuenta de contrapartida que se debe utilizar en esta línea del diario.'; //'Specifies the code for the balancing account type that should be used in this journal line.';
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the number of the general ledger, customer, vendor, or bank account to which a balancing entry for the journal line will posted.',
                    //            ESP = 'Especifica el número de la cuenta de contabilidad, cliente, proveedor o banco en la que se registrará un movimiento de contrapartida para la línea del diario.';
                    ToolTip = 'Especifica el número de la cuenta de contabilidad, cliente, proveedor o banco en la que se registrará un movimiento de contrapartida para la línea del diario.'; //'Specifies the number of the general ledger, customer, vendor, or bank account to which a balancing entry for the journal line will posted.';

                    trigger OnValidate();
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    end;
                }
                field("Bal. Gen. Posting Type"; "Bal. Gen. Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the general posting type that will be used when you post the entry on the journal line.',
                    //            ESP = 'Especifica el tipo de registro general que se usará para registrar el movimiento en la línea del diario.';
                    ToolTip = 'Especifica el tipo de registro general que se usará para registrar el movimiento en la línea del diario.'; //'Specifies the general posting type that will be used when you post the entry on the journal line.';
                }
                field("Bal. Gen. Bus. Posting Group"; "Bal. Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the code of the general business posting group that will be used when you post the entry on the journal line.',
                    //            ESP = 'Especifica el código del grupo contable de negocio general que se utilizará cuando se registre el movimiento en la línea del diario.';
                    ToolTip = 'Especifica el código del grupo contable de negocio general que se utilizará cuando se registre el movimiento en la línea del diario.'; //'Specifies the code of the general business posting group that will be used when you post the entry on the journal line.';
                }
                field("Bal. Gen. Prod. Posting Group"; "Bal. Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the code of the general product posting group that will be used when you post the entry on the journal line.',
                    //            ESP = 'Especifica el código del grupo contable de producto general que se utilizará cuando se registre el movimiento en la línea del diario.';
                    ToolTip = 'Especifica el código del grupo contable de producto general que se utilizará cuando se registre el movimiento en la línea del diario.'; //'Specifies the code of the general product posting group that will be used when you post the entry on the journal line.';
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the code that represents the payments terms that apply to the entry on the journal line.',
                    //            ESP = 'Especifica el código que representa los términos de pago correspondientes al movimiento de la línea del diario.';
                    ToolTip = 'Especifica el código que representa los términos de pago correspondientes al movimiento de la línea del diario.'; //'Specifies the code that represents the payments terms that apply to the entry on the journal line.';
                    Visible = false;
                }
                field("Applies-to Doc. Type"; "Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.',
                    //            ESP = 'Especifica el tipo del documento registrado en el que se liquidará esta línea de diario o documento al registrar, por ejemplo, pagos.';
                    ToolTip = 'Especifica el tipo del documento registrado en el que se liquidará esta línea de diario o documento al registrar, por ejemplo, pagos.'; //'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                    Visible = false;
                }
                field("Applies-to Doc. No."; "Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.',
                    //            ESP = 'Especifica el número del documento registrado en el que se liquidará esta línea de diario o documento al registrar, por ejemplo, pagos.';
                    ToolTip = 'Especifica el número del documento registrado en el que se liquidará esta línea de diario o documento al registrar, por ejemplo, pagos.'; //'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("Applies-to Bill No."; "Applies-to Bill No.")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the number of the bill to be settled.',
                    //            ESP = 'Especifica el número de efecto que se va a liquidar.';
                    ToolTip = 'Especifica el número de efecto que se va a liquidar.'; //'Specifies the number of the bill to be settled.';
                }
                field("Applies-to ID"; "Applies-to ID")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.',
                    //            ESP = 'Especifica los identificadores de los movimientos que se liquidarán cuando elija la acción Liquidar movs.';
                    ToolTip = 'Especifica los identificadores de los movimientos que se liquidarán cuando elija la acción Liquidar movs.'; //'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
                    Visible = false;
                }
                field("On Hold"; "On Hold")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies that the On Hold check box is selected for this transaction in the Vendor Ledger Entries window. The payable document cannot be included in a payment order nor can it be settled until the check box is deselected on the vendor ledger entry.',
                    //            ESP = 'Especifica que la casilla de verificación Esperar está activada para esta transacción en la ventana Movimientos de proveedores. No se puede incluir el documento a pagar en una orden de pago ni se podrá liquidar hasta que se desactive la casilla de verificación del movimiento de proveedor.';
                    ToolTip = 'Especifica que la casilla de verificación Esperar está activada para esta transacción en la ventana Movimientos de proveedores. No se puede incluir el documento a pagar en una orden de pago ni se podrá liquidar hasta que se desactive la casilla de verificación del movimiento de proveedor.'; //'Specifies that the On Hold check box is selected for this transaction in the Vendor Ledger Entries window. The payable document cannot be included in a payment order nor can it be settled until the check box is deselected on the vendor ledger entry.';
                    Visible = false;
                }
                field("Bank Payment Type"; "Bank Payment Type")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the code for the payment type, for the entry on the payment journal line.',
                    //            ESP = 'Especifica el código del tipo de pago para el movimiento de la línea del diario de pagos.';
                    ToolTip = 'Especifica el código del tipo de pago para el movimiento de la línea del diario de pagos.'; //'Specifies the code for the payment type, for the entry on the payment journal line.';
                    Visible = false;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies why the entry is created. When reason codes are assigned to journal line or sales and purchase documents, all entries with a reason code will be marked during posting.',
                    //            ESP = 'Especifica por qué se crea el movimiento. Cuando los códigos de auditoría se asignan a la línea del diario o las ventas y los documentos de compra, todas las entradas con un código de auditoría se marcarán durante el registro.';
                    ToolTip = 'Especifica por qué se crea el movimiento. Cuando los códigos de auditoría se asignan a la línea del diario o las ventas y los documentos de compra, todas las entradas con un código de auditoría se marcarán durante el registro.'; //'Specifies why the entry is created. When reason codes are assigned to journal line or sales and purchase documents, all entries with a reason code will be marked during posting.';
                    Visible = false;
                }
                field("Recipient Bank Account"; "Recipient Bank Account")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the bank account that the amount will be transferred to after it has been exported from the journal.',
                    //            ESP = 'Especifica la cuenta bancaria a la que se transferirá el importe una vez se haya exportado del diario.';
                    ToolTip = 'Especifica la cuenta bancaria a la que se transferirá el importe una vez se haya exportado del diario.'; //'Specifies the bank account that the amount will be transferred to after it has been exported from the journal.';
                    Visible = false;
                }
                //COL-154++
                // field("Pmt. Address Code"; "Pmt. Address Code")
                // {
                //     ApplicationArea = Basic, Suite;
                //     //ToolTipML = ENU = 'Specifies a code.',
                //     //            ESP = 'Especifica un código.';
                //     ToolTip = 'Especifica un código.';//'Specifies a code.';
                //     Visible = false;
                // }
                //COL-154--
                field("Direct Debit Mandate ID"; "Direct Debit Mandate ID")
                {
                    ApplicationArea = Basic, Suite;
                    //ToolTipML = ENU = 'Specifies the direct-debit mandate that the customer has signed to allow direct debit collection of payments.',
                    //            ESP = 'Especifica la orden de domiciliación de adeudo directo que el cliente ha firmado para permitir realizar cobros por domiciliación de pagos.';
                    ToolTip = 'Especifica la orden de domiciliación de adeudo directo que el cliente ha firmado para permitir realizar cobros por domiciliación de pagos.'; //'Specifies the direct-debit mandate that the customer has signed to allow direct debit collection of payments.';
                }
            }
            group(Control30)
            {
                fixed(Control1901776101)
                {
                    group("Nombre cuenta")
                    {
                        //CaptionML = ENU = 'Account Name',
                        //            ESP = 'Nombre cuenta';
                        Caption = 'Nombre cuenta'; //'Account Name';

                        field(AccName; AccName)
                        {
                            ApplicationArea = Basic, Suite;
                            Editable = false;
                        }
                    }
                    group("Nombre contrapartida")
                    {
                        //CaptionML = ENU = 'Bal. Account Name',
                        //            ESP = 'Nombre contrapartida';
                        Caption = 'Nombre contrapartida'; //'Bal. Account Name';

                        field(BalAccName; BalAccName)
                        {
                            ApplicationArea = Basic, Suite;
                            //CaptionML = ENU = 'Bal. Account Name',
                            //            ESP = 'Nombre contrapartida';
                            Caption = 'Nombre contrapartida'; //'Bal. Account Name';
                            Editable = false;
                            //ToolTipML = ENU = 'Specifies the name of the balancing account that has been entered on the journal line.',
                            //            ESP = 'Especifica el nombre de la cuenta de contrapartida introducida en la línea del diario.';
                            ToolTip = 'Especifica el nombre de la cuenta de contrapartida introducida en la línea del diario.'; //'Specifies the name of the balancing account that has been entered on the journal line.';
                        }
                    }
                    group(Saldo)
                    {
                        //CaptionML = ENU = 'Balance',
                        //            ESP = 'Saldo';
                        Caption = 'Saldo'; //'Balance';

                        field(Balance; Balance + "Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            //CaptionML = ENU = 'Balance',
                            //            ESP = 'Saldo';
                            Caption = 'Saldo'; //'Balance';
                            Editable = false;
                            //ToolTipML = ENU = 'Specifies the balance on the journal line.',
                            //            ESP = 'Especifica el saldo de la línea del diario.';
                            ToolTip = 'Especifica el saldo de la línea del diario.'; //'Specifies the balance on the journal line.';
                            Visible = BalanceVisible;
                        }
                    }
                    group("Saldo total")
                    {
                        //CaptionML = ENU = 'Total Balance',
                        //            ESP = 'Saldo total';
                        Caption = 'Saldo total'; //'Total Balance';

                        field(TotalBalance; TotalBalance + "Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            //CaptionML = ENU = 'Total Balance',
                            //            ESP = 'Saldo total';
                            Caption = 'Saldo total'; //'Total Balance';
                            Editable = false;
                            //ToolTipML = ENU = 'Specifies the sum of balances. ',
                            //            ESP = 'Especifica la suma de saldos. ';
                            ToolTip = 'Especifica la suma de saldos. '; //'Specifies the sum of balances. ';
                            Visible = TotalBalanceVisible;
                        }
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
                        ShowDimensions;
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
                        CLEAR(OldLinDiaCar);
                        OldLinDiaCar.COPY(Rec);
                        PostOk := false;
                        DocPost.PostLines(OldLinDiaCar, PostOk, false);
                        Rec := OldLinDiaCar;
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        if PostOk then begin
                            DELETEALL;
                            ClosingForbidden := false;
                            COMMIT;
                        end;
                        MARKEDONLY(false);
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
                        CLEAR(OldLinDiaCar);
                        OldLinDiaCar.COPY(Rec);
                        PostOk := false;
                        DocPost.PostLines(OldLinDiaCar, PostOk, true);
                        Rec := OldLinDiaCar;
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        if PostOk then begin
                            DELETEALL;
                            ClosingForbidden := false;
                            COMMIT;
                        end;
                        MARKEDONLY(false);
                        CurrPage.UPDATE(false);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord();
    begin
        AfterGetCurrentRecord;
    end;

    trigger OnInit();
    begin
        TotalBalanceVisible := true;
        BalanceVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        UpdateBalance;
        SetUpNewLine(xRec, Balance, BelowxRec);
        AfterGetCurrentRecord;
    end;

    trigger OnOpenPage();
    var
        JnlSelected: Boolean;
    begin
        if NOT LiqRetencion THEN BEGIN
            BalAccName := '';
            if PassedCurrentJnlBatchName <> '' then CurrentJnlBatchName := PassedCurrentJnlBatchName;
            OpenedFromBatch := ("Journal Batch Name" <> '') and ("Journal Template Name" = '');
            if OpenedFromBatch then begin
                CurrentJnlBatchName := "Journal Batch Name";
                GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
                exit;
            end;
            //++ OT2-051963
            //GenJnlManagement.TemplateSelection(PAGE::"Cartera Journal", 12, false, Rec, JnlSelected);
            GenJnlManagement.TemplateSelection(PAGE::"Cartera Journal", enum::"Gen. Journal Template Type"::Cartera, false, Rec, JnlSelected);
            //-- OT2-051963
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
            CarteraJnlForm.SetJnlBatchName("Journal Batch Name");
            CarteraJnlForm.SETTABLEVIEW(Rec);
            CarteraJnlForm.SETRECORD(Rec);
            CarteraJnlForm.AllowClosing(true);
            CarteraJnlForm.RUNMODAL;
        end;
    end;

    var
        Text1100000: Label 'Registre las líneas del Diario. Si no, podrían aparecer incoherencias entre los datos.';
        GLReconcile: Page Reconciliation;
        ChangeExchangeRate: Page "Change Exchange Rate";
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
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
        [InDataSet]
        BalanceVisible: Boolean;
        [InDataSet]
        TotalBalanceVisible: Boolean;
        SeccionRet: code[20];
        LiqRetencion: Boolean;

    PROCEDURE LlamadaDesdeLiqRet(pSeccion: Code[20]);
    BEGIN
        LiqRetencion := TRUE;
        SeccionRet := pSeccion;
    END;

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
        CurrPage.SAVERECORD;
        GenJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.UPDATE(false);
    end;

    local procedure AfterGetCurrentRecord();
    begin
        xRec := Rec;
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        UpdateBalance;
    end;
}
