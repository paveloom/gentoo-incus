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

5.1 Find the fingerprint of the client in the output of

```console
# incus config trust list
```

5.2 Add the project to the `projects` list in the trusted client configuration.

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

7. Now, as the user, switch to the `gentoo` project:

```console
$ incus project switch gentoo
```

8. Launch a Gentoo container.

For example,

```console
$ incus launch images:gentoo/systemd gentoo
```

9. Enter a login shell in the container:

```console
$ incus shell gentoo
```

From here on out the developer is free to use the system container as a clean Gentoo test environment.

# Acknowledgements

This set of instructions is mostly a bare bones reimplementation of the instructions on the [Incus/Gentoo Github pullrequest testing](https://wiki.gentoo.org/wiki/Incus/Gentoo_Github_pullrequest_testing) page.
