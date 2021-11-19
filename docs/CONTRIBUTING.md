# Contribution

Read the following guide about how to contribute to this project and get
familiar with.

## Make

This project contains an easy-to-use interface with a `Makefile`. It allows you
to pass all the checks the pipeline will pass on certain events. So it worth get
familiar with all the targets. To know what targets are available in the project
just run:

```bash
$ make help

 Choose a command to run in fury-kubernetes-dr:

  version                       lists the latest version of tool
  bump-major                    Bumps the module up by a major version
  bump-minor                    Bumps the module up by a minor version
  bump-patch                    Bumps the module up by a patch version
  bump-rc                       Bumps the module up by a release candidate (this only adds a tag, and not bump the version in labels)
  add-license                   Add license headers in all files in the project
  check-license                 Check license headers are in-place in all files in the project
  lint                          Run the policeman over the repository
  deploy-all                    Deploys all the components in the dr module (with velero-on-prem)
  deploy-base                   Deploys the `base` component in the cluster
  deploy-on-prem                Deploys the `velero-on-prem` component in the cluster
  deploy-restic                 Deploys the `velero-restic` component in the cluster
  deploy-schedules              Deploys the `velero-schedules` component in the cluster
  clean-%                       Clean the container image resulting from another target.
```

## bump-version (Release process)

`bump-%v` targets is the recommended way of creating a new release in this
module. This target internally uses
[`bump2version`](https://github.com/c4urself/bump2version/#installation) to bump
the versions of the module in the `examples` directory and the `kustomization`
labels. Then it creates the tag corresponding to the target chosen. We follow
semantic versioning and following is the criteria for versions:

- `bump-major`: Bumps up a major version, i.e. from 1.x.y -> 2.0.0
- `bump-major`: Bumps up a major version, i.e. from x.2.y -> x.2.0
- `bump-patch`: Bumps up a patch version, i.e. from x.y.2 -> x.y.3
- `bump-rc`: Creates an `rc(release candidate)` tag based on the env
  variable `TAG` to be given with the make call.

Before bumping the version, make sure you have a file in the directory
`docs/releases/` with the name of the new tag to be created. That is if you are
planning to make a patch release to version `v1.8.1`, create a file
`docs/releases/v1.8.1.md` with the release notes. You can see an example
[here](releases/v1.8.0.md). Commit all the change with appropriate commit messages.

Before a real release(major, minor or patch) is made, it is recommended
to create a patch release to make sure that the module is ready for the
real release. For this you can use the target `bump-rc`.
`bump-rc` works a bit differently in that it does not bump the versions in the
`kustomization` files or `Furyfiles` as configured in `.bumpversion.cfg`. The
assumption behind this being the considering that a pre-release is more like a
draft release. Another difference of this target is, it expects the rc tag name as
a variable `TAG` along with the `make` call. This is because it is otherwise
quite difficult to interpret which is the target version for which a `rc` is
being created. So the example usage is:

```bash
$ TAG=v1.9.2-rc1 make bump-rc
# This essentially creates a tag `v1.9.2-rc1` which we can  push to github to create a pre-release
```

Then, in order to release it(assuming from version `1.8.0` to `1.8.1` - so a
patch release):

```bash
$ make bump-patch
Making a patch tag
$ git push --tags origin master
# This should trigger the drone pipeline to publish the new release with the release notes from the file created.
```

## lint

To ensure the code-bases follow a standard, we have automated pipelines testing
for the linting rules. If one has to test if the rules are respected locally,
the following command can be run:

```bash
$ make lint
# This will use a dockerised super-linter library to run linting
```

## add-license and check-license

### check-license

This target ensures that a BSD license clause-3 copyrighted to `SIGHUP
s.r.l` is added to all the code files in the repository. To run the
check, run the command:

```bash
$ make check-license
# This will use a dockerised `addlicense` library to run check for labels
```

### add-license

We ensure all of our files are LICENSED respecting the community standards. The
automated drone pipelines fail, if some files are left without license. To add
our preferred license(BSD clause-3), one could locally run:

```bash
$ make add-license
# This will use a dockerised `addlicense` library to add license to the
# missing files
```

## clean-%v

The `clean-%v` target has been designed to remove the local built image
resulting from the different targets in the [`Makefile`](Makefile).

The main reason to implement this target is to save disk space. `clean-%v`
target is automatically called in the targets `lint` and `add-license`.

## Deploy

To deploy the components available under this module easily, some make targets
are bundled in this repo. You can see the available option in the `make help`.
To deploy a minimal working setup of this module, one could run the following
command, which in turn triggers other make targets for individual components:

```bash
$ make deploy-all
# This deploys velero-base, velero-on-prem, velero-restic and velero-schedules
```
