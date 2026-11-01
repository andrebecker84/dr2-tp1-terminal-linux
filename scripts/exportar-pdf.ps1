# Exporta andre_becker_DR2_TP1.docx para PDF pelo proprio Word (mesma renderizacao do arquivo aberto).
#
#     powershell -ExecutionPolicy Bypass -File scripts/exportar-pdf.ps1
$raiz = Split-Path -Parent $PSScriptRoot
# [string] explicito: o resultado do Join-Path chega ao COM embrulhado num PSObject, e o SaveAs2 do
# Word fica parado para sempre com um caminho nesse formato.
[string]$docx = Join-Path $raiz 'andre_becker_DR2_TP1.docx'
[string]$pdf  = Join-Path $raiz 'andre_becker_DR2_TP1.pdf'

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
try {
    $doc = $word.Documents.Open($docx, $false, $true, $false)   # sem conversao, somente leitura
    $doc.SaveAs2($pdf, 17)                                      # 17 = wdFormatPDF
    "paginas: " + $doc.ComputeStatistics(2)
    $doc.Close($false)
} finally {
    $word.Quit()
}
"gerado: $pdf"
