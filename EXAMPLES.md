# Report examples and troubleshooting

Author: Paul Bryant

These examples use fictional resource names and IDs. They show the expected output format, not a successful run against Microsoft infrastructure.

## Populated inventory

The Azure Cloud VM inventory report produces these columns when a matching VM is visible. Python writes CSV by default. In PowerShell, use `-OutputPath` to write CSV.

```csv
id,name,resourceGroup,subscriptionId,location,vmSize,provisioningState
/subscriptions/example/resourceGroups/sample/providers/Microsoft.Compute/virtualMachines/vm-one,vm-one,sample,example,eastus,Standard_B2s,Succeeded
```

Run it with `--subscription <subscription-id>` in Python or `-SubscriptionId '<subscription-id>'` in PowerShell. The [repository guide](README.md) shows both commands.

## Empty result

When no rows match, the CSV still contains a header:

```csv
id,name,resourceGroup,subscriptionId,location,vmSize,provisioningState
```

An empty result does not prove that the environment has no VMs. Check the subscription, signed-in tenant, read permissions, and Resource Graph visibility. Azure Resource Graph can lag changes. For Arc-enabled SDN reports, also check the full custom location ID and confirm SDN enablement separately.

## Errors and next steps

| Symptom | Check |
| --- | --- |
| The Azure report says a subscription is required | Supply at least one `--subscription` or `-SubscriptionId`. |
| Authentication or authorization error | Sign in with an identity that can read the selected scope. Check tenant and subscription access. |
| The Arc report says a custom location is required | Supply `--custom-location` or `-CustomLocation` with the full resource ID. |
| The on-premises report rejects the controller URI | Use a trusted HTTPS Network Controller address. |
| The on-premises endpoint returns an error | Confirm the deployed Network Controller version, endpoint, Kerberos identity, and certificate. |
| The report stops on truncated Resource Graph results | Narrow the scope or inspect the query response. The script refuses to present an incomplete inventory as complete. |

Do not attach unredacted output to a public issue. Resource IDs, IP addresses, hostnames, and configuration fields may expose details of your environment. Use the [issue template](.github/ISSUE_TEMPLATE/report_problem.yml) with sanitized examples.
