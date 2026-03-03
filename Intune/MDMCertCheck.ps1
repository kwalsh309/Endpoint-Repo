$cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Issuer -eq "Microsoft Intune Device CA"}

if ($cert)
{
    Write-Host "Intune certificate found on this device"
}
else {
    Write-Host "No Intune cert found"
}