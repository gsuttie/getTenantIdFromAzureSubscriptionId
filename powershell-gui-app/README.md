# PowerShell GUI Application

This project is a PowerShell GUI application that allows users to retrieve the Azure Tenant ID based on a given Subscription ID. The application features a simple user interface with a text box for input, a button to trigger the action, and a label to display the result.

## Project Structure

```
powershell-gui-app
├── src
│   ├── MainForm.ps1       # Contains the GUI form and event handling
│   └── GetTenantId.ps1    # Contains the function to get Tenant ID from Subscription ID
├── README.md               # Documentation for the project
└── LICENSE                 # Licensing information
```

## Getting Started

### Prerequisites

- PowerShell 5.1 or later
- Internet access to make web requests to Azure

### Running the Application

1. Open PowerShell.
2. Navigate to the project directory:
   ```powershell
   cd path\to\powershell-gui-app\src
   ```
3. Run the MainForm script:
   ```powershell
   .\MainForm.ps1
   ```

### Usage

- Enter the Subscription ID in the text box.
- Click the "Get Tenant ID" button.
- The Tenant ID will be displayed in the label below the button.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.