#$mailboxes = Get-Mailbox -ResultSize Unlimited

$changedmailboxes = @('garusse@pointpark.edu','mylie.uebelacker@pointpark.edu','georgia.harvey@pointpark.edu','skyler.gaudio@pointpark.edu','dustana.roberts@pointpark.edu','ejcarte@pointpark.edu','shanequaw.scott@pointpark.edu','aberg@pointpark.edu','gabrielle.johnson@pointpark.edu','mihawke@pointpark.edu','jackson.muller@pointpark.edu','kordell.booth@pointpark.edu','collin.reeder@pointpark.edu')
$mailboxes = @()

foreach ($changedmailbox in $changedmailboxes)
{
    $mb = Get-Mailbox $changedmailbox
    $mailboxes += $mb
}

#Commenting this in/out with above line for testing against a single mailbox prior to every mailbox
#$mailboxes = Get-Mailbox "alexandra.koontz@pointpark.edu"

$report = @()
foreach ($mailbox in $mailboxes)
{
    $rules = Get-InboxRule -Mailbox $mailbox.PrimarySmtpAddress -IncludeHidden | Where-Object {$_.Description -match 'noreply-easypath@ecsi.net'}
    foreach ($rule in $rules)
    {
        $ruleDetails = [PSCustomObject] @{
            MailboxName = $mailbox.PrimarySmtpAddress
            RuleName = $rule.Name
            Description = $rule.Description
            RuleIdentity = $rule.RuleIdentity
            Enabled = $rule.Enabled
        }
        Write-Host $ruleDetails
        $report += $ruleDetails
        Disable-InboxRule -Identity ';' -Mailbox $mailbox.PrimarySmtpAddress
    }
}

$report | Export-Csv -Path "C:\Users\kwalsh1\Desktop\InboxRules-ECSI.csv" -NoTypeInformation