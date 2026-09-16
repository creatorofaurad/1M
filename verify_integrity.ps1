# Automated PowerShell SHA-256 Cryptographic Integrity Attestation Verifier
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " Verifying Cryptographic SHA-256 Hashes for 1M Master Monographs " -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

$expectedHashes = @{
    "papers/Srijan_Mandal_P_vs_NP_Final_Publication_Paper.pdf" = "1B1C26509C24C52C55E760BC7BB03FF8CC606407D4207EEE600B83A8768BB161"
    "papers/Srijan_Mandal_Hardened_Master_Monograph_P_neq_NP.pdf" = "02A1C0AD47C1A20EA8C3B55B69D056507F6AED56CBD76423A436AB5A1C8A60FF"
    "papers/Srijan_Mandal_NonMonotone_Circuit_Lifting_Proof.pdf" = "0A6F7B6251D38E2682554B99D8E0C14C9FDC782915DF8A27976BBCC90A1B6C5B"
    "papers/Srijan_Mandal_2Systole_Coboundary_Resolution_Proof.pdf" = "6AD711AA0332F53F2DEF45D609603B4864F49B582863D0F72703FD14887977EC"
    "papers/monograph_core/Srijan_Mandal_100Page_Master_Monograph.pdf" = "34D58494ACE4962035C5F2F98B375DB6A4DD51B387E99F736E2F2068A3664B19"
    "papers/FINAL_MASTER_PAPER_P_NEQ_NP.tex" = "D691A61715B1FE6666DD537D491B454B9AF3993C175986099A5A75C9D5C19A76"
    "papers/HARDENED_MASTER_MONOGRAPH_P_NEQ_NP.tex" = "8455568155815E58851169F38675E67BD70602F02A6F6B008F5C85D523A57447"
    "papers/NON_MONOTONE_CIRCUIT_LIFTING_PROOF.tex" = "4EB20ECFBABEF85791DB813AB0E039259B5B602FF1BBA1ED492154808F942EE2"
    "papers/SYSTOLE_COBOUNDARY_RESOLUTION_PROOF.tex" = "5A475682BDFFB68D76D948AC2EBABCAB0144A9FA866CB607129A591E95CD03D6"
    "papers/monograph_core/master_monograph.tex" = "137EDADEA79B948D6D8668634CA377FD420CEC1E0641ABF08663771B25AC726A"
}

$allPassed = $true

foreach ($filePath in $expectedHashes.Keys) {
    if (Test-Path $filePath) {
        $actualHash = (Get-FileHash -Path $filePath -Algorithm SHA256).Hash.ToUpper()
        $expected = $expectedHashes[$filePath].ToUpper()
        if ($actualHash -eq $expected) {
            Write-Host " [OK] $filePath" -ForegroundColor Green
        } else {
            Write-Host " [MISMATCH] $filePath" -ForegroundColor Red
            Write-Host "   Expected: $expected" -ForegroundColor Yellow
            Write-Host "   Actual:   $actualHash" -ForegroundColor Red
            $allPassed = $false
        }
    } else {
        Write-Host " [MISSING] $filePath" -ForegroundColor Red
        $allPassed = $false
    }
}

Write-Host "=================================================================" -ForegroundColor Cyan
if ($allPassed) {
    Write-Host " [SUCCESS] 100% Cryptographic Verification Passed." -ForegroundColor Green
} else {
    Write-Host " [FAILURE] Hash mismatch detected." -ForegroundColor Red
    exit 1
}
