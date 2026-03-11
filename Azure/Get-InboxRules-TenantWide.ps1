Connect-ExchangeOnline

#It's required to authenticate to your tenant

$mailboxes = Get-Mailbox -ResultSize Unlimited

#Used this to iterate through specific mailboxes in original use-case
#$mailboxes = @()

#foreach ($changedmailbox in $changedmailboxes)
#{
#    $mb = Get-Mailbox $changedmailbox
#    $mailboxes += $mb
#}

#Commenting this in/out with above line for testing against a single mailbox prior to every mailbox
#$mailboxes = Get-Mailbox "username@pointpark.edu"

$report = @()
foreach ($mailbox in $mailboxes)
{
    $rules = Get-InboxRule -Mailbox $mailbox.PrimarySmtpAddress -IncludeHidden | Where-Object {$_.Description -match 'noreply-easypath@ecsi.net'} #Matches against known bad inbox rule
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

$report | Export-Csv -Path "C:\Users\kwalsh1\Desktop\InboxRules-ECSI.csv" -NoTypeInformation #Path should be modified to fit use-case