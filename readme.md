# Azure SFTP Storage with Terraform

This project provisions an Azure Storage Account with SFTP capabilities using Terraform. It creates a secure SFTP endpoint for file transfers using Azure Blob Storage with hierarchical namespace enabled.

<a href="https://www.buymeacoffee.com/techielass"> <img align="left" src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="50" width="210" alt="techielass" /></a></p>

<br><br>

## Overview

This Terraform configuration deploys:
- Azure Resource Group with CAF-compliant naming
- Premium BlockBlobStorage Account with SFTP enabled
- Storage container for SFTP root directory
- Local user with password authentication for SFTP access

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.10.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure Subscription
- Git (for cloning the repository)

## Project Structure

```
├── main.tf              # Main Terraform configuration
├── variables.tf         # Variable definitions
├── outputs.tf          # Output definitions
├── .terraform.lock.hcl # Terraform dependency lock file
├── .gitignore          # Git ignore rules
└── .devcontainer/      # VS Code dev container configuration
    └── devcontainer.json
```

## Configuration

### Variables

The following variables can be customized in [`variables.tf`](variables.tf) or by creating a `terraform.tfvars` file:

| Variable | Description | Default |
|----------|-------------|---------|
| `location` | Azure region for resources | `UK South` |
| `container_name` | Name of the storage container | `sftp-root` |
| `sftp_local_user` | Username for SFTP access | `extpartner1` |
| `account_replication_type` | Storage replication type (LRS/ZRS) | `LRS` |
| `tag_environment` | Environment tag | `Testing` |
| `tag_project` | Project tag | `SFTP` |
| `tag_creator` | Creator tag | `TechieLass` |

### Example terraform.tfvars

```hcl
location = "East US"
container_name = "my-sftp-container"
sftp_local_user = "myuser"
account_replication_type = "ZRS"
```

## Outputs

After deployment, Terraform will output:

- `storage_account_name` - The name of the created storage account
- `sftp_host` - SFTP endpoint hostname
- `sftp_username` - Full SFTP username for connection
- `sftp_password` - Password for SFTP authentication (sensitive)

To view the SFTP password after deployment:
```bash
terraform output -raw sftp_password
```

## Connecting to SFTP

Use any SFTP client with the following connection details:

- **Host**: `<storage_account_name>.blob.core.windows.net`
- **Port**: 22 (default SFTP port)
- **Username**: `<storage_account>.<container>.<local_user>`
- **Password**: Retrieved from Terraform output

### Example using command line:
```bash
sftp <username>@<host>
```

## Development Environment

This project includes a dev container configuration (`.devcontainer/devcontainer.json`) that provides a consistent development environment with all required tools pre-installed. The dev container can be used in:

- **GitHub Codespaces**: Cloud-based development environment accessible from any browser
- **VS Code with Dev Containers**: Local development with Docker-based containerization

The dev container includes:
- Ubuntu base image
- Azure CLI with Bicep support
- Terraform (latest version)
- Git with default branch set to `main`

To use the dev container within VS Code: 
1. Install [VS Code](https://code.visualstudio.com/) and the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Open the project in VS Code
3. When prompted, reopen in container

## Security Considerations

- The storage account enforces HTTPS-only connections
- Public blob access is disabled
- SFTP access requires authentication
- Consider using SSH key authentication instead of passwords for production
- Store sensitive outputs securely and never commit passwords to version control

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

Written by: Sarah Lean

[![YouTube Channel Subscribers](https://img.shields.io/youtube/channel/subscribers/UCQ8U53KvEX2JuCe48MxmV3Q?label=People%20subscribed%20to%20my%20YouTube%20channel&style=social)](https://www.youtube.com/techielass?sub_confirmation=1) [![Twitter Follow](https://img.shields.io/twitter/follow/techielass?label=Twitter%20Followers&style=social)](https://twitter.com/intent/follow?screen_name=techielass)

Find me on:

* My Blog: <https://www.techielass.com>
* Twitter: <https://twitter.com/techielass>
* LinkedIn: <http://uk.linkedin.com/in/sazlean>

## Acknowledgments

- Uses [Azure/naming](https://registry.terraform.io/modules/Azure/naming/azurerm/latest) Terraform module for CAF-compliant resource naming
- Built with Terraform and Azure Resource Manager