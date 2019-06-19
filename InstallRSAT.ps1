# If Active Directory does not exist, install RSAT.
If (!(Test-Path("$env:windir\System32\dsa.msc")))
{
    # Key controlling Optional Components details.
    $RegistryPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Servicing"

    # Ensure registry key is controlling Optional Components details is created.
    # Note: This should be created by default, but in case it's not, do it!
    If (!(Test-Path $RegistryPath)) {New-Item -Path $RegistryPath -Force}

    # Enable Optional Component updates via Microsoft Windows Updates to install RSAT tools in WSUS environment.
    New-ItemProperty -Path $RegistryPath -Name RepairContentServerSource -Value "2" -PropertyType DWORD -Force

    # Install all RSAT features.
    Get-WindowsCapability -Online | Where-Object { $_.Name -like "RSAT*" -and $_.State -eq "NotPresent" } | Add-WindowsCapability -Online

    # Disable Optional Components via Microsoft Windows Updates after installing RSAT tools.
    Remove-ItemProperty -Path $RegistryPath -Name RepairContentServerSource
}
