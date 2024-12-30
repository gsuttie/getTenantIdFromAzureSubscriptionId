function get-tenantIdFromSubscriptionID($subId) {
    $response = try {
        (Invoke-WebRequest -UseBasicParsing -Uri "https://management.azure.com/subscriptions/$($subId)?api-version=2015-01-01" -ErrorAction Stop).BaseResponse
    } catch {
        $_.Exception.Response
    }
    $stringHeader = $response.Headers.ToString()
    return($stringHeader.SubString($stringHeader.IndexOf("login.windows.net") + 18, 36))
}