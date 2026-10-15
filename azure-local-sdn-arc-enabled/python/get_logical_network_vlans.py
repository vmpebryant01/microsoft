"""Report VLAN identifiers on Azure Local logical network subnets. Author: Paul Bryant."""

from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / '_shared'))
from reporting import main

if __name__ == '__main__':
    main('azure-local-sdn-arc-enabled', 'logical_network_vlans')
