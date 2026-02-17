# Oh My Pentest Report - Zsh Theme

`ohmy-pentest-report.zsh-theme` is a customizable Oh My Zsh theme for pentesters. It provides a clean, efficient prompt with real-time date, time, IP address, current directory, and command status ideal for audits and penetration testing. Features include manual/automatic IP configuration, custom symbols, command history logging, and more to enhance your workflow.

![Prompt Example](./prompt.png)

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Custom Command History Logging](#custom-command-history-logging)
- [Default Two-Line Prompt](#default-two-line-prompt)
- [Additional Customization](#additional-customization)
- [Contributions](#contributions)

## Features

- **Optional Date and Time Display**: Enable or disable the current date and time in cyan using `enabledate` and `disabledate`.
- **Dynamic IP Address**: Show the IP from a specific interface (e.g., `tun0`), a manually set IP, or the public IP address.
  - Set the IP manually or automatically with the `setip` command.
  - Toggle IP display with `enableip` and `disableip`.
- **Command Execution Status**: 
  - A white `❯` symbol indicates success.
  - A red `❯` symbol indicates failure.
  - For `root`, the prompt shows `#` in yellow (also turns red on failure).
- **Current Directory**: Shows the working directory in brackets (red and white).
- **Two-Line Prompt Option**: Use a two-line prompt for better readability (enabled by default).
- **Custom Command History Logging**:
    - Executed commands are logged to `~/.pentest_history` (configurable via `PENTEST_HISTORY_FILE`) as `DATE - IP - COMMAND`.
    - Logging works regardless of prompt display settings.
    - Only successful commands are logged; empty or aborted commands are ignored.
- **Flexible IP Source**: Easily switch between interface IP, manual IP, or public IP.
- **Git Branch & Status Display**: Shows the current Git branch in parentheses when inside a repository.
- **Cross-Platform Support**: Works on both Linux (`ip` command) and macOS/BSD (`ifconfig` fallback).
- **Secure History File**: The history file is created with restricted permissions (`600`) to protect sensitive commands.

## Oh My Zsh Installation

1. First, make sure you have ZSH installed:
```bash
sudo apt install zsh -y
```
2. You can set ZSH as the default shell with the following command:
```bash
chsh -s $(which zsh)
```
3. Once you have ZSH installed and set as the default shell, you can download Oh My Zsh with the following command:
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Installation

1. **Clone the repository** into your custom themes directory:
```bash
git clone https://github.com/sikumy/ohmy-pentest-report/ $ZSH_CUSTOM/themes/ohmy-pentest-report
mv $ZSH_CUSTOM/themes/ohmy-pentest-report/ohmy-pentest-report.zsh-theme ~/.oh-my-zsh/themes/ohmy-pentest-report.zsh-theme
```
2. **Set the theme** in your `.zshrc`:
```bash
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="ohmy-pentest-report"/' ~/.zshrc
```
3. **Add the following line to your `.zshrc`** before `"source $ZSH/oh-my-zsh.sh"` to fix/enable Git branch display in the prompt ([why?](https://github.com/ohmyzsh/ohmyzsh/issues/12328)).
```bash
zstyle ':omz:alpha:lib:git' async-prompt force
```
4. **Reload your terminal**:
```bash
exec $SHELL
```
## Usage

By default, both the IP address and date/time display are disabled. You can enable them as needed using the provided commands.

### Enable or Disable Date and Time in the Prompt

- Enable Date and Time Display:
```bash
enabledate
```

- Disable Date and Time Display:
```bash
disabledate
```

### Enable or Disable IP Address in the Prompt

- Enable IP Display:
```bash
enableip
```

- Disable IP Display:
```bash
disableip
```

### Set a Specific IP

-  To manually set an IP:
```bash
setip 192.168.1.100
```

- Use an Interface to get the IP

```bash
setip eth0
```

- Get the Public IP (Useful for Web Assessments or External Pentests)

```bash
setip public # The public IP will be refreshed automatically every 1 minute.
```

### Enable or Disable All

Enable IP and Date/Time in Prompt:
```bash
enableall
```
Disable IP and Date/Time in Prompt:
```bash
disableall
```

### Enable or Disable Two-Line Prompt

Enable Two-Line Prompt:
```bash
enabletwoline
```
Disable Two-Line Prompt (single-line):
```bash
disabletwoline
```

### Show Current Configuration

Display the current theme settings at a glance:
```bash
showconfig
```

### Tab Completion

The `setip` command supports tab completion. Press `Tab` after typing `setip` to see available options (`public` and all detected network interfaces).

## Custom Command History Logging

Executed commands are logged to `~/.pentest_history` (or the path set in `PENTEST_HISTORY_FILE`) in the format `DATE - IP - COMMAND`. This is useful for reporting and tracking activities during a penetration test.

- The history file is created automatically with secure permissions (`chmod 600`).
- You can customize the path by setting `PENTEST_HISTORY_FILE` in your `.zshrc` before the theme is loaded:
  ```bash
  export PENTEST_HISTORY_FILE="$HOME/.my_custom_pentest_log"
  ```
- Empty or aborted commands (e.g., pressing `Ctrl+C`) are ignored.
- The IP logged matches your current configuration (manual, interface, or public).
- Example:
```
28/10/23 16:38 - 192.168.1.100 - nmap -sV target.com
```

## Default Two-Line Prompt

By default, the prompt uses a two-line layout for better readability.  
You can toggle this dynamically:
```bash
disabletwoline  # Switch to single-line prompt
enabletwoline   # Switch back to two-line prompt
```

## Additional Customization

You can further customize the prompt by editing the theme file and modifying variables such as the date format, symbol styles, and colors.
- **Date Format**: Modify the `%D{}` format string in the `get_datetime` function to change how the date and time are displayed (uses zsh native prompt expansion).
- **Prompt Symbols**: Customize `cmd_symbol_success`, `cmd_symbol_fail`, and `cmd_symbol_root` for different symbols or colors.
- **Colors**: Change color codes within the prompt components to suit your preferences.
- **Spacing**: Some prompt variables include a trailing space to ensure proper spacing regardless of which elements are enabled.
- **Prompt Layout**: The prompt is built in the `construct_prompt` function. You can edit this function to change the order or add/remove elements as needed.

## Contributions

   Contributions, issues, and feature requests are welcome! Feel free to check out the [issues](https://github.com/sikumy/ohmy-pentest-report/issues) page if you want to contribute.
