# Oh My Pentest Report Zsh Theme

`ohmy-pentest-report.zsh-theme` is a customizable Oh My Zsh theme specifically designed for pentesters, offering a clean and efficient prompt to streamline daily tasks during audits and penetration testing. The theme includes real-time display of the date, time, IP address, current directory, and the result of the last executed command. The inclusion of date and time is particularly useful for reporting, allowing pentesters to clearly track when tests were executed, making it easier to document results. Additionally, the theme provides flexibility for manual or automatic IP configuration, custom symbols, and other features tailored to enhance a pentester's workflow.

## Features

- **Optional Date and Time Display**: Enable or disable the display of the current date and time in cyan for easy readability using `enabledate` and `disabledate` commands.
- **Dynamic IP Address**: Optionally show the IP from a specific interface (e.g., `tun0`), a manually set IP, or the public IP address.
  - Set IP manually or automatically using the `setip` function.
  - Toggle showing the IP with `enableip` and `disableip` commands.
- **Command Execution Status**: 
  - A white `❯` symbol indicates successful command execution.
  - A red `❯` symbol shows when the previous command failed.
  - If the user is `root`, the prompt shows `#` in red.
- **Current Directory**: The prompt shows the current working directory within brackets in red and white.
- **Customizable Interface**: Easily switch between displaying an IP from an interface, a manually set IP address, or the public IP.

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
2. **Set the theme** in your ```.zshrc```:
```bash
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="ohmy-pentest-report"/' ~/.zshrc
```
3. **Reload your terminal**:
```bash
source ~/.zshrc
```
## Usage

By default, both the IP address and date/time display are disabled. You can enable them as needed using the provided commands.

### Enable or Disable Date and Time in the Prompt

- Enable Date and Time Display:
```bash
enabledate
```
The prompt will now display the date and time in cyan.

- Disable Date and Time Display:
```bash
disabledate
```
The date and time will be removed from the prompt.

### Enable or Disable IP Address in the Prompt

- Enable IP Display:
```bash
enableip
```
The prompt will now display the IP address.

- Disable IP Display:
```bash
disableip
```
The IP address will be removed from the prompt.

#### Set a Specific IP

##### To manually set an IP:
   ```bash
   setip 192.168.1.100
   ```

##### Use an Interface to Get the IP

   To get the IP address from a specific network interface:
   ```bash
   setip eth0
   ```

##### Get the Public IP (Useful for Web Assessments or External Pentests)

   You can display the public IP address, which is particularly useful for web assessments or external penetration testing:
   ```bash
   setip public
   ```
   The public IP will be refreshed automatically every 15 minutes.

### Enable or Disable All

Enable IP and Date/Time in Prompt:
```bash
enableall
```
Disable IP and Date/Time in Prompt:
```bash
disableall
```

### Additional Customization

   You can further customize the prompt by editing the theme file and modifying variables such as the date format, symbol styles, and colors.

## Screenshots

   Here's an example of how the prompt looks:

   ![Prompt Example](./prompt.png)

## Contributions

   Contributions, issues, and feature requests are welcome! Feel free to check out the [issues](https://github.com/sikumy/ohmyzsh-theme/issues) page if you want to contribute.
