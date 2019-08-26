If (!(Get-Module PowerGraph365))
    { Import-Module PowerGraph365 }

$azureDomain = "mycompany.com"
$appID = "[Your App ID]"
$appSecret = "[Your App Secret]"
$redirectUrl = "http://localhost" # your app redirect url

Connect-MSGraph -AzureADDomain $azureDomain -AppId $appID -AppSecret $appSecret -RedirectUrl $redirectUrl # -BaseUrl "https://graph.microsoft.com/beta/" <- use this for a Beta call

$groups =  Get-GraphGroups

$groups | select displayName, Id
