# NixOS Configuration

This repository stores my declarative NixOS configuration, allowing for consistent system management and easy deployment across multiple machines.

---

## Repository Structure

* **`default.nix`**: This is the primary system configuration file. It defines all the packages, services, and system-wide settings. (It was originally `configuration.nix` but was renamed to `default.nix` to work seamlessly with `nixos-rebuild -I` when pointing to a directory).
* **`hardware-configuration.nix`**: This file contains hardware-specific settings for my primary machine. For new machines, this file will need to be generated or adapted based on the specific hardware.
* **`.git/`**: This is the standard Git version control directory, managing all the history and remote tracking for this repository.

---

## Local Development Workflow

When making changes to your NixOS configuration on this machine, follow these steps:

1.  **Edit Configuration Files:**
    Make all your desired changes directly to the files within this repository directory:
    * `~/GitHub/nixos-config/default.nix`
    * `~/GitHub/nixos-config/hardware-configuration.nix` (if applicable)
    * Any other custom modules or Nix files you choose to add to this directory.

2.  **Apply Changes to the System:**
    After saving your edits, apply them to your running NixOS system. This command will tell NixOS to build your system based on the `default.nix` file (and anything it imports) located in your repository:
    ```bash
    sudo nixos-rebuild switch -I nixos-config=$HOME/GitHub/nixos-config
    ```

3.  **Commit and Push Changes to GitHub:**
    If the `nixos-rebuild` command completes successfully and your system is working as expected, it's crucial to commit and push your changes to keep your GitHub repository synchronized:
    ```bash
    cd ~/GitHub/nixos-config
    git add .                                 # Stage all changes in the directory
    git commit -m "Briefly describe your changes here" # Example: "Added new user program and updated desktop environment."
    git push origin main                      # Push commits to the 'main' branch on GitHub
    ```
    * **Note on `/etc/nixos/`**: With this declarative setup, `~/GitHub/nixos-config/` is your authoritative source of truth. The `/etc/nixos/` directory on your running system is dynamically managed by `nixos-rebuild` and reflects the *active* configuration from the Nix store. **Do not edit files directly in `/etc/nixos/`**, as your changes there would be overwritten or ignored by your Git-managed workflow.

---

## Initial Deployment to a New Machine

To deploy this configuration to a brand new NixOS machine:

1.  **Install a minimal NixOS system:** Perform a basic installation.
2.  **Clone the repository:**
    After booting into the new system, switch to root or use `sudo` to clone the repository into a suitable system-level location, such as `/root/`:
    ```bash
    sudo su                          # Switch to root user
    cd /root/                        # Navigate to root's home directory
    git clone git@github.com:whatdapho/nixos.git # Clone the repo using SSH
    cd nixos                         # Enter the cloned directory
    ```
3.  **Ensure SSH Key Setup (if not already done on this new machine):**
    If this is a brand new machine, you'll need to generate SSH keys and add your public key to your GitHub account. This is essential for `git@github.com` to work for cloning and pushing.
    * Generate key: `ssh-keygen -t ed25519 -C "your.email@example.com"` (press Enter for default path)
    * Start agent & add key: `eval "$(ssh-agent -s)"` then `ssh-add ~/.ssh/id_ed25519`
    * Add public key to GitHub (copy output of `cat ~/.ssh/id_ed25519.pub` and paste into GitHub settings > SSH and GPG keys).
    * Test SSH connection: `ssh -T git@github.com` (expect successful authentication message).

4.  **Apply the configuration:**
    Once the repository is cloned, tell the new system to build itself using this configuration:
    ```bash
    sudo nixos-rebuild switch -I nixos-config=/root/nixos
    ```
    * **Explanation:** This command instructs the `nixos-rebuild` tool to locate your `default.nix` (and related files) within the `/root/nixos` directory and apply them as the system's configuration.

---

## Important Considerations

* **Secrets Management**: **NEVER** commit sensitive information (like passwords, private API keys, or personal private data) directly into a public Git repository. For managing secrets in NixOS, consider using dedicated tools like `agenix` or `sops-nix`, which provide secure, encrypted solutions.
* **Hardware Configuration**: Remember that `hardware-configuration.nix` is inherently machine-specific. You might need to generate a new `hardware-configuration.nix` for each different machine you deploy to (`nixos-generate-config --root /mnt`) or adapt an existing one.
* **Organization**: As your `default.nix` grows, consider breaking it down into smaller, more manageable modular files (e.g., `modules/`, `users/`, `programs/`) and importing them. This improves readability and maintainability.
