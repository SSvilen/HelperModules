function ConvertFrom-MofSchemaFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript( { Test-Path -Path $_ })]
        [string]
        $SchemaFile
    )
    process {
        $content = Get-Content -Path $SchemaFile
        foreach ($line in $content) {
            if ($line -match '\s*[.*].*;$') {
                if (-not ($parametername = ([regex]::Match($line, '(\w+)(?=;$)')).Value)) {
                    throw 'No parameter name found for that line.'
                }
                $description = [regex]::Match($line, '(?<=Description\(")([\w\s.]+)')
                @"
.PARAMETER $parametername
    $description
"@
            }
        }
    }
}
