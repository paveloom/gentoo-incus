# Gentoo test environment setup

Git mirrors:
- [Codeberg](https://codeberg.org/paveloom/gentoo-incus)
- [GitHub](https://github.com/paveloom/gentoo-incus)
- [GitLab](https://gitlab.com/paveloom-g/personal/gentoo/incus)

Assumptions:
- There is only one user on the system making use of this setup, the developer
- The developer is only interested in using the [main ebuild repository](https://wiki.gentoo.org/wiki/Ebuild_repository#The_Gentoo_ebuild_repository) and the [GURU](https://wiki.gentoo.org/wiki/Project:GURU) repository
- The developer has the aforementioned repositories checked out locally
- The developer is willing to share the binary packages between the host system and guest systems
- The developer's non-root user's UID (`id -u`) and GID (`id -g`) are 1000 both
- The developer is using a Wayland compositor on the host system

Requirements:
- [Incus](https://linuxcontainers.org/incus/)

The following commands are supposed to be run on a Gentoo host.

Commands starting with `#` should be run as the root user, while commands starting with `$` should be run as a non-root user.

1. As the root user, create project `gentoo`:

   ```console
   # incus project create gentoo < project.yaml
   ```

2. Switch to the project:

   ```console
   # incus project switch gentoo
   ```

3. Create network `incusbr-gentoo`:

   ```console
   # incus network create incusbr-gentoo < network.yaml
   ```

4. Edit the default profile:

   ```console
   # incus profile edit default < profile.yaml
   ```

5. Allow other clients to use the project.

   1. Find the fingerprint of the client in the output of

      ```console
      # incus config trust list
      ```

   2. Add the project to the `projects` list in the trusted client configuration.

      Run

      ```console
      # incus config trust edit <fingerprint>
      ```

      Here's an example of the related configuration snippet:

      ```yaml
      # <...>
      projects:
      - user-1000
      - gentoo
      # <...>
      ```

6. Mount the ebuild repositories and the Portage configuration from this repository under `/mnt/gentoo`.

   Here's an example of doing it manually:

   ```console
   # mount -m --bind "$(pwd)/portage" /mnt/gentoo/portage
   # mount -m --bind /path/to/gentoo /mnt/gentoo/gentoo
   # mount -m --bind /path/to/guru /mnt/gentoo/guru
   ```

   Here's an example of doing it via `/etc/fstab` (for persistence):

   ```fstab
   /path/to/gentoo     /mnt/gentoo/gentoo     auto    bind,X-mount.mkdir
   /path/to/guru       /mnt/gentoo/guru       auto    bind,X-mount.mkdir
   /path/to/portage    /mnt/gentoo/portage    auto    bind,X-mount.mkdir
   ```

7. Copy the files for `root`'s and `user`'s home directories:

   ```console
   incus file push -v home/root/* gentoo/root/
   incus file push -v home/user/.* gentoo/home/user/
   ```

8. Now, as the user, switch to the `gentoo` project:

   ```console
   $ incus project switch gentoo
   ```

9. Launch a Gentoo container.

   For example,

   ```console
   $ incus launch images:gentoo/systemd gentoo
   ```

10. Enter the root user's login shell in the container:

   ```console
   $ incus shell gentoo
   ```

11. Run the `add_user.bash` script in the `/root` directory to create the user `user`:

    ```console
    # ./add_user.bash
    ```

From here on out the developer is free to use the system container as a clean Gentoo test environment.

To enter the login shell as the non-root user, run

```console
$ incus exec gentoo -- su -l user
```

# Binary packages

Note that the default Portage configuration in this repository makes the package manager create binary packages and share them with the host system. See the [official guide](https://wiki.gentoo.org/wiki/Binary_package_guide) for the details on how it works.

Here are some commands that can be useful when working on a new ebuild.

Build only the dependencies of the atom using binary packages where possible:

```console
# emerge -o atom
```

Build the atom without creating a binary package for it:

```console
# emerge --buildpkg=n atom
```

In the case an unwanted binary package exists (but it is not merged), delete it and fix the index:

```console
rm -rf /var/cache/binpkgs/category/name/
emaint binhost --fix
```

# GUI applications

To make use of the host's GPU, make sure that the non-root user on the host system and the non-root user inside the container have the same UIDs (check via `id -u`) and GIDs (check via `id -g`). The configuration in this repository assumes that both numbers are equal to 1000, as this is commonly the default for the first user on most systems. The user `user` must be added after the container is created (can be done via the [`add_user.bash`](./home/root/add_user.bash) script). The GUI applications are supposed to be launched preferably via that non-root user.

The configuration also assumes that the host's non-root user uses a Wayland compositor, thus assuming that the compositor is listening at the `$XDG_RUNTIME_DIR/wayland-0` socket. The value of `$XDG_RUNTIME_DIR` is assumed to be `/run/user/1000`, and this directory is bind mounted to the container by default. A custom personal initialization file for Bash (see [`.bash_profile`](./home/user/.bash_profile)) mush be copied into the container's non-root user's home directory to override the default value of that environment variable, thus making the Wayland compositor reachable from within.

# Acknowledgements

This set of instructions is mostly a bare bones reimplementation of the instructions on the [Incus/Gentoo Github pullrequest testing](https://wiki.gentoo.org/wiki/Incus/Gentoo_Github_pullrequest_testing) page.
