# MainForm.ps1

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to convert Base64 string to Image
function Convert-Base64ToImage($base64String) {
    $bytes = [System.Convert]::FromBase64String($base64String)
    $stream = New-Object System.IO.MemoryStream(,$bytes)
    return [System.Drawing.Image]::FromStream($stream)
}

# Base64 string of the image (replace with your actual Base64 string)
$base64Image = "" # Removed for security reasons

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Tenant ID Finder"
$form.Size = New-Object System.Drawing.Size(400,450)  # Increased height
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false  # Disable maximize button
$form.MinimizeBox = $false  # Disable minimize button

# Create the label for Subscription ID
$subscriptionIdLabel = New-Object System.Windows.Forms.Label
$subscriptionIdLabel.Location = New-Object System.Drawing.Point(10,20)
$subscriptionIdLabel.Size = New-Object System.Drawing.Size(100,20)
$subscriptionIdLabel.Text = "Subscription ID:"
$form.Controls.Add($subscriptionIdLabel)

# Create the text box for subscription ID
$subscriptionIdTextBox = New-Object System.Windows.Forms.TextBox
$subscriptionIdTextBox.Location = New-Object System.Drawing.Point(120,20)
$subscriptionIdTextBox.Size = New-Object System.Drawing.Size(250,20)
$subscriptionIdTextBox.MaxLength = 36
$form.Controls.Add($subscriptionIdTextBox)

# Create the button
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(120,50)  # Aligned under the start of the textbox
$button.Size = New-Object System.Drawing.Size(110,23)  # Increased width
$button.Text = "Get Tenant ID"
$form.Controls.Add($button)

# Create the label for displaying the tenant ID
$tenantIdLabel = New-Object System.Windows.Forms.Label
$tenantIdLabel.Location = New-Object System.Drawing.Point(10,80)
$tenantIdLabel.Size = New-Object System.Drawing.Size(360,40)
$tenantIdLabel.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 10)
$form.Controls.Add($tenantIdLabel)

# Create the copy button
$copyButton = New-Object System.Windows.Forms.Button
$copyButton.Location = New-Object System.Drawing.Point(240,50)  # Positioned next to the Get Tenant ID button
$copyButton.Size = New-Object System.Drawing.Size(110,23)
$copyButton.Text = "Copy Tenant ID"
$form.Controls.Add($copyButton)

# Add the logo image at the bottom
$logo = New-Object System.Windows.Forms.PictureBox
$logo.Location = New-Object System.Drawing.Point(10, 130)
$logo.Size = New-Object System.Drawing.Size(360, 300)  # Adjusted size
$logo.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
##$logo.Image = Convert-Base64ToImage $base64Image
##$form.Controls.Add($logo)

function get-tenantIdFromSubscriptionID($subId) {
    $response = try {
        (Invoke-WebRequest -UseBasicParsing -Uri "https://management.azure.com/subscriptions/$($subId)?api-version=2015-01-01" -ErrorAction Stop).BaseResponse
    } catch {
        $_.Exception.Response
    }
    $stringHeader = $response.Headers.ToString()
    return($stringHeader.SubString($stringHeader.IndexOf("login.windows.net") + 18, 36))
}


# Define the button click event
$button.Add_Click({
    $subId = $subscriptionIdTextBox.Text
    $regex = '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
    if ($subId -match $regex) {
        $tenantId = get-tenantIdFromSubscriptionID $subId
        $tenantIdLabel.Text = "Tenant Id: $tenantId"
    } else {
        $tenantIdLabel.Text = "Invalid Subscription ID format."
    }
})

# Define the copy button click event
$copyButton.Add_Click({
    $tenantIdText = $tenantIdLabel.Text -replace '^Tenant Id: ', ''
    [System.Windows.Forms.Clipboard]::SetText($tenantIdText)
})

# Handle the form closing event to prevent the "Cancel" dialog
$form.add_FormClosing({
    param($sender, $e)
    $e.Cancel = $false
})

# Show the form
##$form.ShowDialog()

$result = $form.ShowDialog()

# Check the result
if ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
    #Write-Output "Form was cancelled."
} else {
    #Write-Output "Something else happened."
}