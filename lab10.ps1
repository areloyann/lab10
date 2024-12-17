function Print-IPAddresses {
    Write-Host "Fetching IPv4 and IPv6 addresses..."
    $ipv4Addresses = (Get-NetIPAddress -AddressFamily IPv4 | Select-Object -ExpandProperty IPAddress)
    $ipv6Addresses = (Get-NetIPAddress -AddressFamily IPv6 | Select-Object -ExpandProperty IPAddress)
    
    foreach ($ip in $ipv4Addresses) {
        Write-Host "IPv4: $ip"
    }
    foreach ($ip in $ipv6Addresses) {
        Write-Host "IPv6: $ip"
    }
}

function Trace-Route {
    $hostname = Read-Host "Enter hostname or URL for traceroute"
    tracert $hostname
}

function Get-IPAddress {
    $hostname = Read-Host "Enter hostname or URL"
    try {
        $addresses = [System.Net.Dns]::GetHostAddresses($hostname)
        foreach ($address in $addresses) {
            Write-Host $address
        }
    } catch {
        Write-Host "Unable to resolve hostname."
    }
}

function Encrypt-Data {
    $input = Read-Host "Enter the text or file to encrypt"
    if (Test-Path $input) {
        $output = "$input.encrypted"
        certutil -encrypt $input $output
        Write-Host "File encrypted to $output"
    } else {
        $output = "encrypted_text.txt"
        $input | Out-File $output
        certutil -encrypt $output "$output.encrypted"
        Write-Host "Text encrypted to $output.encrypted"
    }
}

function Decrypt-Data {
    $input = Read-Host "Enter the file to decrypt"
    if (Test-Path $input) {
        $output = "$input.decrypted"
        certutil -decrypt $input $output
        Write-Host "File decrypted to $output"
    } else {
        Write-Host "File does not exist!"
    }
}

function Compress-Data {
    $input = Read-Host "Enter the file or text to compress"
    if (Test-Path $input) {
        Compress-Archive -Path $input -DestinationPath "$input.zip"
        Write-Host "File compressed to $input.zip"
    } else {
        $output = "compressed_text.txt"
        $input | Out-File $output
        Compress-Archive -Path $output -DestinationPath "$output.zip"
        Write-Host "Text compressed to $output.zip"
    }
}

function Restore-Data {
    $input = Read-Host "Enter the compressed file to restore"
    if (Test-Path $input) {
        Expand-Archive -Path $input -DestinationPath (Split-Path -Path $input -Parent)
        Write-Host "File restored."
    } else {
        Write-Host "File does not exist!"
    }
}

function Calculate-Checksum {
    $filename = Read-Host "Enter the file name"
    if (Test-Path $filename) {
        $hash = Get-FileHash -Path $filename -Algorithm SHA256
        Write-Host "SHA256 Checksum: $($hash.Hash)"
    } else {
        Write-Host "File does not exist!"
    }
}

while ($true) {
    Clear-Host
    Write-Host "=== MENU ==="
    Write-Host "1. Print IPv4 and IPv6 addresses"
    Write-Host "2. Trace the network path"
    Write-Host "3. Get IP address of a host"
    Write-Host "4. Encrypt a file or text"
    Write-Host "5. Decrypt a file or text"
    Write-Host "6. Compress a file or text"
    Write-Host "7. Restore a file or text"
    Write-Host "8. Calculate the checksum of a file"
    Write-Host "9. Exit"
    Write-Host "============"
    $choice = Read-Host "Choose an option"

    switch ($choice) {
        1 { Print-IPAddresses }
        2 { Trace-Route }
        3 { Get-IPAddress }
        4 { Encrypt-Data }
        5 { Decrypt-Data }
        6 { Compress-Data }
        7 { Restore-Data }
        8 { Calculate-Checksum }
        9 { Write-Host "Goodbye!"; break }
        default { Write-Host "Invalid option. Please try again." }
    }
    Pause
}


#powershell.exe -ExecutionPolicy Bypass -File "lab10.ps1"
