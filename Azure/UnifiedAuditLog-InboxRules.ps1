Connect-ExchangeOnline -UserPrincipalName ha-kwalsh@pointpark.edu

#It's required to authenticate to your tenant

$start = (Get-Date).AddDays(-30)
$end = (Get-Date).AddDays(1)
$user = "username@pointpark.edu"
$report = @()

$audit = Search-UnifiedAuditLog -UserIds $user -StartDate $start -EndDate $end -SessionCommand ReturnLargeSet -RecordType ExchangeAdmin # Can also run switches like -Operations "New-InboxRule","UpdateInboxRules" or pipe in | Where-Object {$_.Operations -eq "New-InboxRule" -or $_.Operations -eq "UpdateInboxRules"}

foreach ($auditlog in $audit)
{
    $logentry = [PSCustomObject] @{
        User = $user
        RecordType = $auditlog.RecordType
        CreationDate = $auditlog.CreationDate
        Operations = $auditlog.Operations
        AuditData = $auditlog.AuditData
    }
    $report += $logentry
}
$report | Export-Csv -Path "C:\Users\kwalsh1\Desktop\AuditLogTest.csv" -NoTypeInformation