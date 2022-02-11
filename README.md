# dot-files

Repository to keep track of my dot-files

## Configuration of the repo

There's a `.git` file in $HOME that points to this repository.

```git
gitdir: /path/to/this/gitdir/.git
```

To clone this repository in a new machine, it needs a sequence of steps.

- Clone the repository using `--bare` flag
- Add the `.git` file as described above
- `git checkout` and `git reset` from $HOME

See this [ansible
script](https://github.com/punchagan/ansible-system-setup/commit/adb14c5) for
the actual commands to run.


### Using `core.worktree` config

Some people have set `core.worktree` in their configuration to allow for this
kind of a setup, but that doesn't play well with `magit`. Some people have
documented their setup here:

- https://www.wangzerui.com/2017/03/06/using-git-to-manage-system-configuration-files/
- https://drewdevault.com//2019/12/30/dotfiles.html
- https://stackoverflow.com/a/31841738

### Magit recommended way

@tarsius
[recommends](https://github.com/magit/magit/issues/460#issuecomment-36035787
"GitHub Issue comment") using a `.git` file in the worktree (`$HOME`) that
points to the `gitdir`.

### Workflow improvements

Adding new files is a little bit of a pain with the necessity to add it with
`git add -f`, and there not being a simpler `magit`-like way of doing it.

May be some directories should be excluded in `.gitignore` to make this easier?
