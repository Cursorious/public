$uri = "https://localhost:8080/objects/?password=zabbix01D"
$out = 'C:\zabbix\4trassir\objects.json'

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

Invoke-WebRequest -Uri $uri -OutFile $out

$text = 'C:\zabbix\4trassir\dump.txt'

Get-Content $out | Select-String name,guid,class | Out-File $text 
$trobj = Get-Content $text| Where-Object -FilterScript {$_.Trim() -ne '' }

$first = 1
$num = 1

echo "{`n";
echo "`t`"data`":[`n`n";

ForEach ($obj in $trobj) 
{
    $temp = $obj.split('"')[3]
    if ($temp -like '*trassir') {$temp = 'trassir_gui'}
    
    if ($num -eq 1) {
            if ($first -eq 0) { echo "`t,`n" } 
            $first = 0
            echo "`t{`n"; 
            echo "`t`t`"{#TRNAME}`":`"$temp`",`n" 
        } elseif ($num -eq 2) { 
            echo "`t`t`"{#TRGUID}`":`"$temp`",`n"
        } elseif ($num -eq 3) {
            echo "`t`t`"{#TRCLAS}`":`"$temp`"`n"
            echo "`t}`n";
            $num = 0 
        } else { 
            echo 'algorithm error, stop'
            break
        }
    $num++     
}

echo "`n`t]`n";
echo "}`n";