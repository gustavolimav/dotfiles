# Dotfiles

This repository contains configuration files for setting up your development environment. Follow the instructions below to set up your `.zshrc` with the configurations provided in this repository.

## Setup Instructions

1. **Clone the Repository**

   First, clone the repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/dotfiles.git
   ```

   Replace `yourusername` with your actual GitHub username.

2. **Locate Your .zshrc File**

   Open your terminal and navigate to your home directory:

   ```bash
   cd ~
   ```

   Open (or create) the `.zshrc` file in your preferred text editor. For example, using `nano`:

   ```bash
   nano .zshrc
   ```

3. **Replace the .zshrc Content**

   Replace the content of your `.zshrc` file with the following lines:

   ```bash
   export DB_PASSWORD="PASSWORD"
   source "/path/to/dotfiles/zsh/zshrc"

   export NVM_DIR="$HOME/.nvm"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
   [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
   ```

   Make sure to replace `/path/to/dotfiles` with the actual path to where you cloned the repository. For example, if you cloned it into your home directory, it would be something like `/home/yourusername/dotfiles`.

4. **Save and Close the .zshrc File**

   Save the changes and exit the text editor. In `nano`, you can do this by pressing `Ctrl + X`, then `Y` to confirm changes, and `Enter` to save.

5. **Reload the .zshrc Configuration**

   To apply the changes, reload your `.zshrc` by running:

   ```bash
   source ~/.zshrc
   ```

## Additional Information

- **NVM (Node Version Manager)**

  The setup also includes configurations for NVM (Node Version Manager). Make sure you have NVM installed. If not, you can install it by following the instructions on the [NVM GitHub repository](https://github.com/nvm-sh/nvm).

- **Customizing Dotfiles**

  Feel free to customize the configuration files in the `dotfiles` repository to suit your preferences. Any changes made in the `dotfiles/zsh/zshrc` will be applied the next time you source your `.zshrc`.

---

Enjoy your configured development environment!