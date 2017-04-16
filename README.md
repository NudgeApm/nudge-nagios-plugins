# nudge-nagios-plugins

This reporitory contains several samples of Nagios plugins that grabs metrics from Nudge APM API to control the way your application works.

## Installation

You need a Nudge APM account : https://www.nudge-apm.com/.

Other requirements depend on each plugin. Specific documentations for each plugin explains those requirements.

## Plugins list

### transaction_execution_control.sh
If you have some batch jobs that should run regularly, you can check their executions with this plugin.

[Documentation](scripts/transaction_execution_control.md)

### apdex_control.sh
Control your application performance index (APDEX).

[Documentation](scripts/apdex_control.md)

### More to come ...
