Install-Module -Name MSCommerce # This is responsible for contacting the tenants
Import-Module MSCommerce

do {
    # Asks for Tenant Details
    Write-Host "Please sign in to the tenant you want to manage..." -ForegroundColor Cyan
    Connect-MSCommerce

    # Disable self-service purchase for all products currently enabled
    $enabledProducts = Get-MSCommerceProductPolicies -PolicyId AllowSelfServicePurchase | Where-Object { $_.PolicyValue -eq "Enabled" }

    foreach ($product in $enabledProducts) {
        Write-Host "Disabling self-service purchase for product: $($product.ProductName)" -ForegroundColor Yellow
        Update-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -ProductId $product.ProductID -Enabled $false
    }

    Write-Host "Self-service purchase disabled for all applicable products in this tenant." -ForegroundColor Green

    # Allows you to end the session or move onto another tenant you manage to disable it also
    $continue = Read-Host "Do you want to manage another tenant? (Y/N)"
} while ($continue -eq "Y")
